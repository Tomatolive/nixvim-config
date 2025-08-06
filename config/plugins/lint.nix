{
  # =====================================================================
  # NVIM-LINT - Linting complémentaire et indépendant
  # Intégré avec l'écosystème LSP unifié
  # =====================================================================

  plugins.lint = {
    enable = true;

    # =====================================================================
    # LINTERS PAR FILETYPE
    # =====================================================================
    lintersByFt = {
      # === LANGAGES ACTUELS ===
      
      # Nix
      nix = [ "deadnix" "statix" ];
      
      # Haskell  
      haskell = [ "hlint" ];
    };

    # =====================================================================
    # CONFIGURATION DES LINTERS
    # =====================================================================
    linters = {
      # === NIX LINTERS ===
      deadnix = {
        cmd = "deadnix";
        args = [ "--output-format" "json" ];
        stdin = false; # deadnix lit les fichiers directement
        stream = "stdout";
        ignore_exitcode = true;
        parser.__raw = ''
          function(output, bufnr)
            local ok, decoded = pcall(vim.json.decode, output)
            if not ok or not decoded or not decoded.results then
              return {}
            end
            
            local diagnostics = {}
            for _, result in ipairs(decoded.results) do
              if result.file == vim.api.nvim_buf_get_name(bufnr) then
                for _, issue in ipairs(result.issues or {}) do
                  table.insert(diagnostics, {
                    lnum = (issue.line or 1) - 1,
                    col = (issue.column or 1) - 1,
                    end_lnum = (issue.end_line or issue.line or 1) - 1,
                    end_col = (issue.end_column or issue.column or 1) - 1,
                    severity = vim.diagnostic.severity.WARN,
                    message = issue.message or "Dead code detected",
                    source = "deadnix",
                  })
                end
              end
            end
            return diagnostics
          end
        '';
      };

      statix = {
        cmd = "statix";
        args = [ "check" "--format" "stderr" "--" ];
        stdin = false;
        stream = "stderr";
        ignore_exitcode = true;
        parser.__raw = ''
          function(output, bufnr)
            local diagnostics = {}
            local current_file = vim.api.nvim_buf_get_name(bufnr)
            
            for line in output:gmatch("[^\r\n]+") do
              -- Format statix: file:line:col:level:message
              local file, lnum, col, level, message = line:match("^([^:]+):(%d+):(%d+):(%w+):(.+)$")
              
              if file and file == current_file then
                local severity = vim.diagnostic.severity.INFO
                if level == "error" then
                  severity = vim.diagnostic.severity.ERROR
                elseif level == "warn" or level == "warning" then
                  severity = vim.diagnostic.severity.WARN
                end
                
                table.insert(diagnostics, {
                  lnum = tonumber(lnum) - 1,
                  col = tonumber(col) - 1,
                  severity = severity,
                  message = message:gsub("^%s+", ""):gsub("%s+$", ""),
                  source = "statix",
                })
              end
            end
            
            return diagnostics
          end
        '';
      };

      # === HASKELL LINTERS ===
      hlint = {
        cmd = "hlint";
        args = [ "--json" "-" ];
        stdin = true;
        stream = "stdout";
        ignore_exitcode = true;
        parser.__raw = ''
          function(output, bufnr)
            local ok, decoded = pcall(vim.json.decode, output)
            if not ok or not decoded then
              return {}
            end
            
            local diagnostics = {}
            for _, hint in ipairs(decoded) do
              local severity = vim.diagnostic.severity.INFO
              if hint.severity == "Error" then
                severity = vim.diagnostic.severity.ERROR
              elseif hint.severity == "Warning" then
                severity = vim.diagnostic.severity.WARN
              end
              
              table.insert(diagnostics, {
                lnum = (hint.startLine or 1) - 1,
                col = (hint.startColumn or 1) - 1,
                end_lnum = (hint.endLine or hint.startLine or 1) - 1,
                end_col = (hint.endColumn or hint.startColumn or 1) - 1,
                severity = severity,
                message = hint.hint or "HLint suggestion",
                source = "hlint",
                code = hint.rule,
              })
            end
            
            return diagnostics
          end
        '';
      };
    };
  };

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE LUA
  # =====================================================================

  extraConfigLua = ''
    -- ===================================================================
    -- CONFIGURATION NVIM-LINT AVANCÉE
    -- ===================================================================
    
    vim.defer_fn(function()
      local lint_ok, lint = pcall(require, "lint")
      if not lint_ok then
        print("nvim-lint not available")
        return
      end
      
      -- ===================================================================
      -- FONCTIONS UTILITAIRES LINT
      -- ===================================================================
      
      -- Override de la fonction toggle_linting
      _G.toggle_linting = function()
        _G.lsp_unified_state.auto_lint = not _G.lsp_unified_state.auto_lint
        
        if _G.lsp_unified_state.auto_lint then
          -- Lancer le linting immédiatement
          lint.try_lint()
          require("snacks").notify(
            "Auto-lint enabled",
            { title = "Lint" }
          )
        else
          -- Nettoyer les diagnostics nvim-lint existants
          vim.diagnostic.reset(vim.api.nvim_create_namespace("nvim-lint"))
          require("snacks").notify(
            "Auto-lint disabled",
            { title = "Lint" }
          )
        end
      end
      
      -- Fonction pour lancer le linting manuellement avec feedback
      _G.lint_now = function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo.filetype
        local linters = lint.linters_by_ft[ft] or {}
        
        if #linters == 0 then
          require("snacks").notify(
            "No linters configured for " .. ft,
            { title = "Lint", level = "warn" }
          )
          return
        end
        
        -- Afficher les linters utilisés
        require("snacks").notify(
          "Linting with: " .. table.concat(linters, ", "),
          { title = "Lint", timeout = 1000 }
        )
        
        -- Lancer le linting
        lint.try_lint()
        
        -- Feedback après un délai
        vim.defer_fn(function()
          local diagnostics = vim.diagnostic.get(buf, { namespace = vim.api.nvim_create_namespace("nvim-lint") })
          local count = #diagnostics
          
          if count > 0 then
            local errors = #vim.diagnostic.get(buf, { 
              namespace = vim.api.nvim_create_namespace("nvim-lint"),
              severity = vim.diagnostic.severity.ERROR 
            })
            local warnings = count - errors
            
            require("snacks").notify(
              string.format("Found %d issues (%d errors, %d warnings)", count, errors, warnings),
              { title = "Lint", level = errors > 0 and "warn" or "info" }
            )
          else
            require("snacks").notify(
              "No issues found",
              { title = "Lint", timeout = 1000 }
            )
          end
        end, 1000)
      end
      
      -- Fonction pour health check des linters
      _G.check_linters_health = function()
        print("=== Linters Health Check ===")
        
        local all_linters = {
          -- Nix
          { name = "deadnix", cmd = "deadnix" },
          { name = "statix", cmd = "statix" },
          
          -- Haskell
          { name = "hlint", cmd = "hlint" },
        }
        
        print("Linter availability:")
        local available_count = 0
        for _, linter in ipairs(all_linters) do
          local status = vim.fn.executable(linter.cmd) == 1 and "✓" or "✗"
          print(string.format("  %s %s", status, linter.name))
          if status == "✓" then
            available_count = available_count + 1
          end
        end
        
        print("")
        print(string.format("Available: %d/%d linters", available_count, #all_linters))
        
        -- Test pour le buffer actuel
        local ft = vim.bo.filetype
        local configured_linters = lint.linters_by_ft[ft] or {}
        
        print("")
        print("For current buffer (" .. ft .. "):")
        if #configured_linters > 0 then
          print("  Configured linters: " .. table.concat(configured_linters, ", "))
          
          -- Vérifier la disponibilité
          for _, linter_name in ipairs(configured_linters) do
            local linter = lint.linters[linter_name]
            if linter and linter.cmd then
              local available = vim.fn.executable(linter.cmd) == 1
              print(string.format("    %s %s", available and "✓" or "✗", linter_name))
            end
          end
        else
          print("  No linters configured")
        end
      end
      
      -- ===================================================================
      -- AUTOCOMMANDS POUR LINTING AUTOMATIQUE
      -- ===================================================================
      
      -- Linting sur les événements appropriés
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          if not _G.lsp_unified_state or not _G.lsp_unified_state.auto_lint then
            return
          end
          
          local ft = vim.bo.filetype
          local linters = lint.linters_by_ft[ft] or {}
          
          if #linters > 0 then
            lint.try_lint()
          end
        end,
      })
      
      -- Nettoyage à la fermeture du buffer
      vim.api.nvim_create_autocmd("BufDelete", {
        callback = function(event)
          vim.diagnostic.reset(vim.api.nvim_create_namespace("nvim-lint"), event.buf)
        end,
      })
      
    end, 1200)
    
    -- ===================================================================
    -- COMMANDES NVIM-LINT
    -- ===================================================================
    
    vim.api.nvim_create_user_command("Lint", function()
      _G.lint_now()
    end, { desc = "Run linting on current buffer" })
    
    vim.api.nvim_create_user_command("LintHealth", function()
      _G.check_linters_health()
    end, { desc = "Check linters health and availability" })
    
    vim.api.nvim_create_user_command("LintClear", function()
      local buf = vim.api.nvim_get_current_buf()
      vim.diagnostic.reset(vim.api.nvim_create_namespace("nvim-lint"), buf)
      require("snacks").notify("Lint diagnostics cleared", { title = "Lint" })
    end, { desc = "Clear lint diagnostics for current buffer" })
    
    vim.api.nvim_create_user_command("LintEnable", function()
      _G.lsp_unified_state.auto_lint = true
      require("snacks").notify("Auto-lint enabled", { title = "Lint" })
    end, { desc = "Enable auto-linting" })
    
    vim.api.nvim_create_user_command("LintDisable", function()
      _G.lsp_unified_state.auto_lint = false
      vim.diagnostic.reset(vim.api.nvim_create_namespace("nvim-lint"))
      require("snacks").notify("Auto-lint disabled", { title = "Lint" })
    end, { desc = "Disable auto-linting" })
    
    vim.api.nvim_create_user_command("LintToggle", function()
      _G.toggle_linting()
    end, { desc = "Toggle auto-linting" })
    
  '';
}
