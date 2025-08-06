{
  # =====================================================================
  # CONFORM.NVIM - Formatage unifié et centralisé
  # Hub principal pour tous les formatters de l'écosystème
  # =====================================================================

  plugins.conform-nvim = {
    enable = true;

    settings = {
      # =================================================================
      # FORMATTERS PAR FILETYPE - Exhaustif et organisé
      # =================================================================
      formatters_by_ft = {
        # === LANGAGES ACTUELS ===
        
        # Nix
        nix = [ "nixpkgs_fmt" ]; # Ou "alejandra" pour une alternative
        
        # Haskell
        haskell = [ "ormolu" ]; # Ou "stylish_haskell" pour une alternative
      };

      # =================================================================
      # CONFIGURATION DES FORMATTERS - Détaillée et optimisée
      # =================================================================
      formatters = {
        # === NIX FORMATTERS ===
        nixpkgs_fmt = {
          command = "nixpkgs-fmt";
          args = [ ];
          stdin = true;
          timeout_ms = 2000;
          cwd.__raw = ''
            function(self, ctx)
              return vim.fn.getcwd()
            end
          '';
        };
        
        alejandra = {
          command = "alejandra";
          args = [ "--quiet" ];
          stdin = true;
          timeout_ms = 2000;
          cwd.__raw = ''
            function(self, ctx)
              return vim.fn.getcwd()
            end
          '';
        };

        # === HASKELL FORMATTERS ===
        ormolu = {
          command = "ormolu";
          args = [ ];
          stdin = true;
          timeout_ms = 3000;
          cwd.__raw = ''
            function(self, ctx)
              return vim.fn.getcwd()
            end
          '';
        };
        
        stylish_haskell = {
          command = "stylish-haskell";
          args = [ ];
          stdin = true;
          timeout_ms = 3000;
        };

      };

      # =================================================================
      # CONFIGURATION DE FORMATAGE AVANCÉE
      # =================================================================
      
      # Format on save conditionnel
      format_on_save = {
        # Timeout adaptatif selon le formatter
        timeout_ms = 1000;
        lsp_fallback = false; # Jamais de fallback LSP
        quiet = false;
        
        # Fonction conditionnelle pour format on save
        condition.__raw = ''
          function(bufnr)
            -- Vérifier l'état global
            if not _G.lsp_unified_state or not _G.lsp_unified_state.auto_format then
              return false
            end
            
            -- Éviter les gros fichiers
            local max_lines = 10000
            if vim.api.nvim_buf_line_count(bufnr) > max_lines then
              return false
            end
            
            -- Éviter certains filetypes
            local excluded_fts = { "oil", "gitcommit", "gitrebase" }
            local ft = vim.bo[bufnr].filetype
            for _, excluded_ft in ipairs(excluded_fts) do
              if ft == excluded_ft then
                return false
              end
            end
            
            return true
          end
        '';
      };

      # Format after save pour les formatters lents
      format_after_save = {
        timeout_ms = 5000;
        lsp_fallback = false;
        
        # Seulement pour certains formatters lents
        condition.__raw = ''
          function(bufnr)
            local ft = vim.bo[bufnr].filetype
            local slow_formatters = { "ormolu", "stylish_haskell" }
            
            local formatters = require("conform").list_formatters(bufnr)
            for _, formatter in ipairs(formatters) do
              for _, slow in ipairs(slow_formatters) do
                if formatter.name == slow then
                  return _G.lsp_unified_state and _G.lsp_unified_state.auto_format
                end
              end
            end
            
            return false
          end
        '';
      };

      # Notifications
      notify_on_error = true;
      notify_no_formatters = false; # Éviter le spam

      # Configuration par défaut pour les appels manuels
      default_format_opts = {
        timeout_ms = 3000;
        async = false;
        quiet = false;
        lsp_format = "never"; # Jamais de fallback LSP
      };

      # =================================================================
      # LOG ET DEBUG
      # =================================================================
      log_level = 1; # ERROR only, évite le spam
    };
  };

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE LUA
  # =====================================================================

  extraConfigLua = ''
    -- ===================================================================
    -- CONFIGURATION CONFORM AVANCÉE
    -- ===================================================================
    
    vim.defer_fn(function()
      local conform_ok, conform = pcall(require, "conform")
      if not conform_ok then
        print("Conform not available")
        return
      end
      
      -- ===================================================================
      -- FONCTIONS UTILITAIRES CONFORM
      -- ===================================================================
      
      -- Override de la fonction unified_format pour plus de contrôle
      _G.unified_format = function(opts)
        opts = opts or {}
        
        local format_opts = vim.tbl_deep_extend("force", {
          timeout_ms = _G.lsp_unified_state.format_timeout,
          async = opts.async or false,
          lsp_fallback = false,
          quiet = opts.quiet or false,
          bufnr = opts.bufnr or vim.api.nvim_get_current_buf(),
        }, opts)
        
        -- Vérifier qu'on a des formatters
        local formatters = conform.list_formatters(format_opts.bufnr)
        if #formatters == 0 then
          require("snacks").notify(
            "No formatters available for " .. vim.bo.filetype,
            { title = "Format", level = "warn" }
          )
          return
        end
        
        -- Afficher les formatters qui vont être utilisés
        if not format_opts.quiet then
          local formatter_names = vim.tbl_map(function(f) return f.name end, formatters)
          require("snacks").notify(
            "Formatting with: " .. table.concat(formatter_names, ", "),
            { title = "Format", timeout = 1000 }
          )
        end
        
        -- Formater
        conform.format(format_opts, function(err, did_edit)
          if err then
            require("snacks").notify(
              "Format error: " .. tostring(err),
              { title = "Format", level = "error" }
            )
          elseif did_edit and not format_opts.quiet then
            require("snacks").notify(
              "Formatted successfully",
              { title = "Format", timeout = 1000 }
            )
          end
        end)
      end
      
      -- Fonction pour changer de formatter
      _G.cycle_formatter = function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo.filetype
        
        -- Récupérer les formatters disponibles pour ce filetype
        local current_formatters = conform.formatters_by_ft[ft]
        if not current_formatters or #current_formatters == 0 then
          require("snacks").notify(
            "No formatters configured for " .. ft,
            { title = "Format", level = "warn" }
          )
          return
        end
        
        if #current_formatters == 1 then
          require("snacks").notify(
            "Only one formatter available: " .. current_formatters[1],
            { title = "Format" }
          )
          return
        end
        
        -- Pour Nix: cycle entre nixpkgs_fmt et alejandra
        if ft == "nix" then
          local current = current_formatters[1]
          local new_formatter
          
          if current == "nixpkgs_fmt" then
            new_formatter = { "alejandra" }
          else
            new_formatter = { "nixpkgs_fmt" }
          end
          
          -- Mettre à jour temporairement
          conform.formatters_by_ft[ft] = new_formatter
          
          require("snacks").notify(
            "Switched to: " .. new_formatter[1],
            { title = "Format" }
          )
          
        -- Pour Haskell: cycle entre ormolu et stylish-haskell
        elseif ft == "haskell" then
          local current = current_formatters[1]
          local new_formatter
          
          if current == "ormolu" then
            new_formatter = { "stylish_haskell" }
          else
            new_formatter = { "ormolu" }
          end
          
          conform.formatters_by_ft[ft] = new_formatter
          
          require("snacks").notify(
            "Switched to: " .. new_formatter[1],
            { title = "Format" }
          )
        else
          require("snacks").notify(
            "Formatter cycling not configured for " .. ft,
            { title = "Format", level = "info" }
          )
        end
      end
      
      -- ===================================================================
      -- HEALTH CHECK FORMATTERS
      -- ===================================================================
      
      _G.check_formatters_health = function()
        print("=== Formatters Health Check ===")
        
        local all_formatters = {
          -- Nix
          { name = "nixpkgs-fmt", cmd = "nixpkgs-fmt" },
          { name = "alejandra", cmd = "alejandra" },
          
          -- Haskell
          { name = "ormolu", cmd = "ormolu" },
          { name = "stylish-haskell", cmd = "stylish-haskell" },
        }
        
        print("Formatter availability:")
        local available_count = 0
        for _, formatter in ipairs(all_formatters) do
          local status = vim.fn.executable(formatter.cmd) == 1 and "✓" or "✗"
          print(string.format("  %s %s", status, formatter.name))
          if status == "✓" then
            available_count = available_count + 1
          end
        end
        
        print("")
        print(string.format("Available: %d/%d formatters", available_count, #all_formatters))
        
        -- Test des formatters pour le buffer actuel
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo.filetype
        local formatters = conform.list_formatters(buf)
        
        print("")
        print("For current buffer (" .. ft .. "):")
        if #formatters > 0 then
          for _, formatter in ipairs(formatters) do
            local status = formatter.available and "✓" or "✗"
            print(string.format("  %s %s", status, formatter.name))
            if not formatter.available and formatter.available_msg then
              print(string.format("    Reason: %s", formatter.available_msg))
            end
          end
        else
          print("  No formatters configured")
        end
      end
      
    end, 1000)
    
    -- ===================================================================
    -- COMMANDES CONFORM
    -- ===================================================================
    
    vim.api.nvim_create_user_command("FormatWith", function(opts)
      local formatter_name = opts.args
      if not formatter_name or formatter_name == "" then
        require("snacks").notify(
          "Usage: :FormatWith <formatter_name>",
          { title = "Format", level = "warn" }
        )
        return
      end
      
      local conform_ok, conform = pcall(require, "conform")
      if conform_ok then
        conform.format({
          formatters = { formatter_name },
          timeout_ms = 5000,
          lsp_fallback = false,
        }, function(err, did_edit)
          if err then
            require("snacks").notify(
              "Format error: " .. tostring(err),
              { title = "Format", level = "error" }
            )
          elseif did_edit then
            require("snacks").notify(
              "Formatted with " .. formatter_name,
              { title = "Format" }
            )
          else
            require("snacks").notify(
              "Formatter " .. formatter_name .. " made no changes",
              { title = "Format" }
            )
          end
        end)
      end
    end, { 
      nargs = 1,
      desc = "Format with specific formatter",
      complete = function()
        local conform_ok, conform = pcall(require, "conform")
        if conform_ok then
          local formatters = conform.list_formatters()
          return vim.tbl_map(function(f) return f.name end, formatters)
        end
        return {}
      end
    })
    
    vim.api.nvim_create_user_command("FormatCycle", function()
      _G.cycle_formatter()
    end, { desc = "Cycle between available formatters" })
    
    vim.api.nvim_create_user_command("FormatHealth", function()
      _G.check_formatters_health()
    end, { desc = "Check formatters health" })
    
    vim.api.nvim_create_user_command("FormatDisable", function()
      _G.lsp_unified_state.auto_format = false
      require("snacks").notify("Auto-format disabled", { title = "Format" })
    end, { desc = "Disable auto-format" })
    
    vim.api.nvim_create_user_command("FormatEnable", function()
      _G.lsp_unified_state.auto_format = true
      require("snacks").notify("Auto-format enabled", { title = "Format" })
    end, { desc = "Enable auto-format" })
    
  '';
}
