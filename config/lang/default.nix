{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION DES LANGAGES - Index principal UNIFIÉ
  # =====================================================================

  imports = [
    ./nix.nix
    ./haskell.nix
    # Ajoutez ici vos futurs langages :
    # ./python.nix
    # ./rust.nix
    # ./javascript.nix
    # ./lua.nix
    # ./go.nix
    # ./typescript.nix
    # ./html.nix
    # ./css.nix
    # ./json.nix
    # ./yaml.nix
    # ./markdown.nix
    # ./bash.nix
  ];

  # =====================================================================
  # PLUGINS REQUIS POUR L'ÉCOSYSTÈME LSP UNIFIÉ
  # Note: Les plugins sont maintenant configurés dans leurs fichiers dédiés
  # =====================================================================

  plugins = {
    # LSP de base uniquement (le reste dans plugins/)
    lsp.enable = true;
  };

  # =====================================================================
  # PACKAGES GLOBAUX POUR LSP/FORMATTING/LINTING
  # =====================================================================
  extraPackages = with pkgs; [
    # Formatters communs
    nixpkgs-fmt        # Nix
    alejandra          # Nix alternatif
    ormolu             # Haskell
    stylish-haskell    # Haskell alternatif
    
    # Linters communs
    hlint              # Haskell
    deadnix            # Nix
    statix             # Nix
  ];

  # =====================================================================
  # TREESITTER GLOBAL - Configuration centralisée
  # =====================================================================

  plugins.treesitter = {
    enable = true;

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      # Langages de base
      lua
      vim
      vimdoc
      query
      regex

      # Langages de programmation actuels
      nix
      haskell
      python
      rust
      javascript
      typescript
      go
      c
      cpp
      java

      # Web
      html
      css
      scss

      # Configuration et données
      json
      yaml
      toml
      xml

      # Documentation et markup
      markdown
      markdown_inline

      # Shell
      bash
      fish

      # Autres
      diff
      git_config
      git_rebase
      gitcommit
      gitignore
    ];

    settings = {
      highlight = {
        enable = true;
        additional_vim_regex_highlighting = false;
      };

      indent = {
        enable = true;
      };

      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = "<C-space>";
          node_incremental = "<C-space>";
          scope_incremental = "<C-s>";
          node_decremental = "<M-space>";
        };
      };

      textobjects = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
          };
        };
        move = {
          enable = true;
          set_jumps = true;
          goto_next_start = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
          };
          goto_next_end = {
            "]M" = "@function.outer";
            "][" = "@class.outer";
          };
          goto_previous_start = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
          };
          goto_previous_end = {
            "[M" = "@function.outer";
            "[]" = "@class.outer";
          };
        };
      };
    };
  };

  # =====================================================================
  # CONFIGURATION LSP UNIFIÉE - onAttach principal
  # =====================================================================

  plugins.lsp = {
    
    # Configuration des capabilities unifiée
    capabilities = ''
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      
      -- Intégration avec blink.cmp
      local ok, blink = pcall(require, 'blink.cmp')
      if ok and blink.get_lsp_capabilities then
        capabilities = vim.tbl_deep_extend('force', capabilities, blink.get_lsp_capabilities())
      end
      
      -- Support pour les snippets
      capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        },
      }
      
      -- Support pour les folding ranges
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      
    '';

    # onAttach UNIFIÉ - gère tous les LSP de façon cohérente
    onAttach = ''
      -- ===================================================================
      -- CONFIGURATION COMMUNE POUR TOUS LES LSP
      -- ===================================================================
      
      -- Document highlighting
      if client.server_capabilities.documentHighlightProvider then
        local group_name = "lsp_document_highlight_" .. bufnr
        vim.api.nvim_create_augroup(group_name, { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          group = group_name,
          buffer = bufnr,
          callback = function()
            pcall(vim.lsp.buf.document_highlight)
          end,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          group = group_name,
          buffer = bufnr,
          callback = function()
            pcall(vim.lsp.buf.clear_references)
          end,
        })
      end
      
      -- Inlay hints si supporté (Neovim 0.10+)
      if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
      end
      
      -- Optimisations selon le LSP
      client.config.flags = client.config.flags or {}
      
      if client.name == "nixd" then
        -- nixd est lent, optimiser agressivement
        client.config.flags.debounce_text_changes = 500
        client.config.flags.allow_incremental_sync = true
        client.server_capabilities.documentFormattingProvider = false -- conform gère ça
        client.server_capabilities.documentRangeFormattingProvider = false
        
      elseif client.name == "haskell-language-server" or client.name == "hls" then
        -- HLS est rapide mais peut être optimisé
        client.config.flags.debounce_text_changes = 150
        client.config.flags.allow_incremental_sync = true
        
      else
        -- Configuration par défaut pour les autres LSP
        client.config.flags.debounce_text_changes = 200
        client.config.flags.allow_incremental_sync = true
      end
      
      -- Désactiver le formatage LSP par défaut (conform gère)
      if client.server_capabilities.documentFormattingProvider then
        client.server_capabilities.documentFormattingProvider = false
      end
      if client.server_capabilities.documentRangeFormattingProvider then
        client.server_capabilities.documentRangeFormattingProvider = false
      end
      
      -- Log d'attachement
      local capabilities_count = 0
      if client.server_capabilities then
        for _ in pairs(client.server_capabilities) do
          capabilities_count = capabilities_count + 1
        end
      end
      
      require("snacks").notify(
        string.format("LSP %s attached (%d capabilities)", client.name, capabilities_count),
        { title = "LSP", timeout = 2000 }
      )
    '';
  };

  # =====================================================================
  # NONE-LS, CONFORM, NVIM-LINT - Configurés dans plugins/
  # Voir: plugins/none-ls.nix, plugins/conform.nix, plugins/lint.nix
  # =====================================================================

  # =====================================================================
  # AUTOCOMMANDS POUR L'ÉCOSYSTÈME LSP UNIFIÉ
  # Note: Autocommands spécifiques aux langages dans leurs fichiers respectifs
  # =====================================================================

  autoCmd = [
    # === Mise à jour globale des diagnostics ===
    {
      event = [ "DiagnosticChanged" ];
      pattern = "*";
      callback.__raw = ''
        function()
          -- Mettre à jour la statusline lors des changements de diagnostics
          vim.cmd("redrawstatus")
        end
      '';
    }
  ];

  # =====================================================================
  # CONFIGURATION LUA - Fonctions globales et utilitaires LSP
  # =====================================================================

  extraConfigLua = ''
    -- ===================================================================
    -- ÉTAT GLOBAL LSP
    -- ===================================================================
    
    _G.lsp_unified_state = {
      auto_format = true,
      auto_lint = true,
      format_timeout = 3000,
      diagnostics_enabled = true,
    }
    
    -- ===================================================================
    -- FONCTIONS GLOBALES UNIFIÉES
    -- ===================================================================
    
    -- Fonction globale : Code Actions unifiées (LSP + none-ls)
    _G.unified_code_action = function()
      local actions = {}
      
      -- Récupérer les actions LSP
      vim.lsp.buf.code_action({
        apply = false,
        context = {
          only = nil,
          diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 }),
        },
        callback = function(lsp_actions)
          if lsp_actions then
            vim.list_extend(actions, lsp_actions)
          end
          
          -- Ajouter les actions none-ls si disponible
          local null_ls_ok, null_ls = pcall(require, "null-ls")
          if null_ls_ok then
            -- none-ls va automatiquement fusionner ses actions
          end
          
          -- Appliquer l'action sélectionnée
          if #actions > 0 then
            vim.lsp.buf.code_action()
          else
            require("snacks").notify("No code actions available", { title = "LSP" })
          end
        end
      })
    end
    
    -- Fonction globale : Format unifié (conform prioritaire)
    _G.unified_format = function(opts)
      opts = opts or {}
      
      local conform_ok, conform = pcall(require, "conform")
      if not conform_ok then
        require("snacks").notify("Conform not available", { title = "Format", level = "error" })
        return
      end
      
      local format_opts = vim.tbl_deep_extend("force", {
        timeout_ms = _G.lsp_unified_state.format_timeout,
        async = opts.async or false,
        lsp_fallback = false, -- Jamais de fallback LSP
        quiet = opts.quiet or false,
      }, opts)
      
      conform.format(format_opts, function(err, did_edit)
        if err then
          require("snacks").notify(
            "Format failed: " .. tostring(err), 
            { title = "Format", level = "error" }
          )
        elseif did_edit then
          require("snacks").notify(
            "Formatted with " .. (conform.list_formatters()[1] or {}).name or "unknown",
            { title = "Format", timeout = 1000 }
          )
        else
          require("snacks").notify(
            "No formatter available for " .. vim.bo.filetype,
            { title = "Format", level = "warn" }
          )
        end
      end)
    end
    
    -- Fonction globale : Rename unifié
    _G.unified_rename = function()
      local current_word = vim.fn.expand("<cword>")
      if current_word == "" then
        require("snacks").notify("No symbol under cursor", { title = "Rename" })
        return
      end
      
      -- Utiliser LSP rename avec amélioration
      vim.lsp.buf.rename(nil, {
        filter = function(client)
          return client.server_capabilities.renameProvider
        end,
      })
    end
    
    -- Fonction globale : Toggle auto-format
    _G.toggle_auto_format = function()
      _G.lsp_unified_state.auto_format = not _G.lsp_unified_state.auto_format
      
      require("snacks").notify(
        "Auto-format " .. (_G.lsp_unified_state.auto_format and "enabled" or "disabled"),
        { title = "Format" }
      )
    end
    
    -- Fonction globale : Toggle linting
    _G.toggle_linting = function()
      _G.lsp_unified_state.auto_lint = not _G.lsp_unified_state.auto_lint
      
      if _G.lsp_unified_state.auto_lint then
        local lint_ok, lint = pcall(require, "lint")
        if lint_ok then
          lint.try_lint()
        end
      end
      
      require("snacks").notify(
        "Auto-lint " .. (_G.lsp_unified_state.auto_lint and "enabled" or "disabled"),
        { title = "Lint" }
      )
    end
    
    -- Fonction globale : Informations LSP complètes
    _G.lsp_info = function()
      local buf = vim.api.nvim_get_current_buf()
      local ft = vim.bo.filetype
      local clients = vim.lsp.get_clients({ bufnr = buf })
      
      print("=== LSP Information ===")
      print("File: " .. (vim.api.nvim_buf_get_name(buf) or "[No Name]"))
      print("Filetype: " .. ft)
      print("Buffer: " .. buf)
      print("")
      
      if #clients > 0 then
        print("LSP Clients:")
        for i, client in ipairs(clients) do
          local caps = client.server_capabilities or {}
          local cap_count = vim.tbl_count(caps)
          
          print(string.format("  %d. %s", i, client.name))
          print(string.format("     Root: %s", client.config.root_dir or "none"))
          print(string.format("     Capabilities: %d", cap_count))
          
          -- Afficher les principales capabilities
          local main_caps = {
            "hoverProvider",
            "definitionProvider", 
            "referencesProvider",
            "codeActionProvider",
            "renameProvider",
            "documentFormattingProvider"
          }
          
          for _, cap in ipairs(main_caps) do
            local status = caps[cap] and "✓" or "✗"
            print(string.format("     %s %s", status, cap))
          end
          print("")
        end
      else
        print("No LSP clients attached")
      end
      
      -- Informations Treesitter
      local ts_ok, ts = pcall(vim.treesitter.get_parser, buf, ft)
      print("Treesitter: " .. (ts_ok and "✓ enabled" or "✗ disabled"))
      
      -- Informations diagnostics
      local diagnostics = vim.diagnostic.get(buf)
      local errors = vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })
      local warnings = vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.WARN })
      
      print(string.format("Diagnostics: %d total (%d errors, %d warnings)", 
        #diagnostics, #errors, #warnings))
      
      -- Informations formatage
      local conform_ok, conform = pcall(require, "conform")
      if conform_ok then
        local formatters = conform.list_formatters(buf)
        if #formatters > 0 then
          print("Formatters: " .. table.concat(
            vim.tbl_map(function(f) return f.name end, formatters), 
            ", "
          ))
        else
          print("Formatters: none available")
        end
      end
      
      -- Informations linting
      local lint_ok, lint = pcall(require, "lint")
      if lint_ok then
        local linters = lint.linters_by_ft[ft] or {}
        if #linters > 0 then
          print("Linters: " .. table.concat(linters, ", "))
        else
          print("Linters: none configured")
        end
      end
      
      print("")
      print("Global state:")
      print("  Auto-format: " .. tostring(_G.lsp_unified_state.auto_format))
      print("  Auto-lint: " .. tostring(_G.lsp_unified_state.auto_lint))
      print("  Format timeout: " .. _G.lsp_unified_state.format_timeout .. "ms")
    end
    
    -- Fonction globale : Restart all LSP
    _G.unified_lsp_restart = function()
      local clients = vim.lsp.get_clients()
      local count = #clients
      
      if count == 0 then
        require("snacks").notify("No LSP clients to restart", { title = "LSP" })
        return
      end
      
      -- Restart tous les clients
      for _, client in ipairs(clients) do
        client.stop(true)
      end
      
      vim.defer_fn(function()
        vim.cmd("edit") -- Force reload pour redémarrer les LSP
        require("snacks").notify(
          string.format("Restarted %d LSP client(s)", count),
          { title = "LSP" }
        )
      end, 1000)
    end
    
    -- Fonction globale : Status complet de l'écosystème
    _G.show_complete_ecosystem_status = function()
      print("=== 🚀 Complete LSP Ecosystem Status ===")
      print("")
      
      -- Statut global
      local state = _G.lsp_unified_state or {}
      print("🌐 Global Configuration:")
      print("  Auto-format: " .. (state.auto_format and "✅ ON" or "❌ OFF"))
      print("  Auto-lint: " .. (state.auto_lint and "✅ ON" or "❌ OFF"))
      print("  Format timeout: " .. (state.format_timeout or 3000) .. "ms")
      print("  Diagnostics: " .. (state.diagnostics_enabled and "✅ ON" or "❌ OFF"))
      print("")
      
      -- Buffer actuel
      local buf = vim.api.nvim_get_current_buf()
      local ft = vim.bo.filetype
      local file = vim.api.nvim_buf_get_name(buf)
      print("📄 Current Context:")
      print("  File: " .. (file ~= "" and vim.fn.fnamemodify(file, ':t') or "[No Name]"))
      print("  Filetype: " .. ft)
      print("  Buffer: " .. buf)
      print("")
      
      -- Écosystème par composant
      local components = {
        {
          name = "🔌 LSP Clients",
          check = function()
            local clients = vim.lsp.get_clients({ bufnr = buf })
            if #clients > 0 then
              for _, client in ipairs(clients) do
                local caps = client.server_capabilities and vim.tbl_count(client.server_capabilities) or 0
                print("    ✅ " .. client.name .. " (" .. caps .. " capabilities)")
              end
              return true
            else
              print("    ❌ No LSP clients")
              return false
            end
          end
        },
        {
          name = "🎨 Conform (Formatting)",
          check = function()
            local ok, conform = pcall(require, "conform")
            if ok then
              local formatters = conform.list_formatters(buf)
              if #formatters > 0 then
                for _, f in ipairs(formatters) do
                  local status = f.available and "✅" or "❌"
                  print("    " .. status .. " " .. f.name)
                end
                return true
              else
                print("    ❌ No formatters for " .. ft)
                return false
              end
            else
              print("    ❌ Conform not available")
              return false
            end
          end
        },
        {
          name = "🔍 nvim-lint",
          check = function()
            local ok, lint = pcall(require, "lint")
            if ok then
              local linters = lint.linters_by_ft[ft] or {}
              if #linters > 0 then
                for _, linter_name in ipairs(linters) do
                  local linter = lint.linters[linter_name]
                  local available = linter and linter.cmd and vim.fn.executable(linter.cmd) == 1
                  print("    " .. (available and "✅" or "❌") .. " " .. linter_name)
                end
                return true
              else
                print("    ℹ️ No linters for " .. ft)
                return true -- pas d'erreur, juste pas configuré
              end
            else
              print("    ❌ nvim-lint not available")
              return false
            end
          end
        },
        {
          name = "🚀 none-ls",
          check = function()
            local ok, null_ls = pcall(require, "null-ls")
            if ok then
              local sources = null_ls.get_sources({ filetype = ft })
              if #sources > 0 then
                local by_method = {}
                for _, source in ipairs(sources) do
                  local method = source.method or "unknown"
                  by_method[method] = by_method[method] or {}
                  table.insert(by_method[method], source.name)
                end
                
                for method, source_names in pairs(by_method) do
                  print("    ✅ " .. method .. ": " .. table.concat(source_names, ", "))
                end
                return true
              else
                print("    ℹ️ No sources for " .. ft)
                return true
              end
            else
              print("    ❌ none-ls not available")
              return false
            end
          end
        }
      }
      
      -- Exécuter les checks
      local all_ok = true
      for _, component in ipairs(components) do
        print(component.name .. ":")
        local ok = component.check()
        all_ok = all_ok and ok
        print("")
      end
      
      -- Résumé diagnostics
      local diagnostics = vim.diagnostic.get(buf)
      local errors = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })
      local warnings = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.WARN })
      
      print("🩺 Diagnostics Summary:")
      print("  " .. #diagnostics .. " total (" .. errors .. " errors, " .. warnings .. " warnings)")
      print("")
      
      -- Status final
      local status_emoji = all_ok and "🎉" or "⚠️"
      local status_text = all_ok and "All systems operational" or "Some issues detected"
      print(status_emoji .. " Overall Status: " .. status_text)
      print("")
      print("💡 Quick Commands: :FormatHealth | :LintHealth | :NullLsInfo")
    end
    
    -- Fonction globale : Health check complet
    _G.check_complete_ecosystem_health = function()
      print("=== 🔧 Complete Ecosystem Health Check ===")
      print("")
      
      -- Check des binaires requis
      local required_tools = {
        -- LSP
        { name = "nixd", desc = "Nix LSP", optional = false },
        { name = "haskell-language-server", desc = "Haskell LSP", optional = false },
        
        -- Formatters
        { name = "nixpkgs-fmt", desc = "Nix formatter", optional = false },
        { name = "alejandra", desc = "Nix formatter (alt)", optional = true },
        { name = "ormolu", desc = "Haskell formatter", optional = false },
        { name = "stylish-haskell", desc = "Haskell formatter (alt)", optional = true },
        
        -- Linters
        { name = "deadnix", desc = "Nix dead code", optional = false },
        { name = "statix", desc = "Nix linter", optional = false },
        { name = "hlint", desc = "Haskell linter", optional = false },
        
        -- Build tools
        { name = "ghc", desc = "Haskell compiler", optional = false },
        { name = "cabal", desc = "Haskell build", optional = true },
        { name = "stack", desc = "Haskell build", optional = true },
      }
      
      print("🔧 Tool Availability:")
      local missing_required = {}
      local missing_optional = {}
      
      for _, tool in ipairs(required_tools) do
        local available = vim.fn.executable(tool.name) == 1
        local status = available and "✅" or "❌"
        local optional_text = tool.optional and " (optional)" or ""
        
        print("  " .. status .. " " .. tool.name .. " - " .. tool.desc .. optional_text)
        
        if not available then
          if tool.optional then
            table.insert(missing_optional, tool.name)
          else
            table.insert(missing_required, tool.name)
          end
        end
      end
      
      print("")
      
      -- Résumé des manques
      if #missing_required > 0 then
        print("❌ Missing required tools:")
        for _, tool in ipairs(missing_required) do
          print("   - " .. tool)
        end
        print("   Action: Add to extraPackages in your config")
        print("")
      end
      
      if #missing_optional > 0 then
        print("ℹ️ Missing optional tools:")
        for _, tool in ipairs(missing_optional) do
          print("   - " .. tool)
        end
        print("   Impact: Reduced functionality but ecosystem will work")
        print("")
      end
      
      -- Check des plugins
      print("🧩 Plugin Status:")
      local plugins = {
        { name = "conform", module = "conform" },
        { name = "nvim-lint", module = "lint" },
        { name = "none-ls", module = "null-ls" },
        { name = "blink.cmp", module = "blink.cmp" },
        { name = "which-key", module = "which-key" },
        { name = "gitsigns", module = "gitsigns" },
        { name = "snacks", module = "snacks" },
      }
      
      for _, plugin in ipairs(plugins) do
        local ok = pcall(require, plugin.module)
        print("  " .. (ok and "✅" or "❌") .. " " .. plugin.name)
      end
      
      print("")
      
      -- Résumé final
      local ecosystem_healthy = #missing_required == 0
      print(ecosystem_healthy and "🎉 Ecosystem Status: HEALTHY" or "⚠️ Ecosystem Status: DEGRADED")
      
      if ecosystem_healthy then
        print("✨ All core components operational!")
      else
        print("🔧 Install missing tools to fully activate ecosystem")
      end
    end
    
    -- Fonction globale : Reset complet de l'écosystème
    _G.reset_lsp_ecosystem = function()
      print("=== 🔄 Resetting LSP Ecosystem ===")
      
      -- Reset LSP clients
      local clients = vim.lsp.get_clients()
      print("Stopping " .. #clients .. " LSP clients...")
      for _, client in ipairs(clients) do
        client.stop(true)
      end
      
      -- Reset diagnostics
      print("Clearing diagnostics...")
      vim.diagnostic.reset()
      
      -- Reset état global
      print("Resetting global state...")
      _G.lsp_unified_state = {
        auto_format = true,
        auto_lint = true,
        format_timeout = 3000,
        diagnostics_enabled = true,
      }
      
      -- Reset conform
      local conform_ok, conform = pcall(require, "conform")
      if conform_ok then
        print("Resetting conform...")
        -- Recharger la config si possible
      end
      
      -- Reset none-ls
      local null_ls_ok, null_ls = pcall(require, "null-ls")
      if null_ls_ok then
        print("Resetting none-ls...")
        null_ls.disable({})
        vim.defer_fn(function()
          null_ls.enable({})
        end, 500)
      end
      
      -- Reset nvim-lint
      local lint_ok, lint = pcall(require, "lint")
      if lint_ok then
        print("Clearing lint diagnostics...")
        vim.diagnostic.reset(vim.api.nvim_create_namespace("nvim-lint"))
      end
      
      -- Redémarrer tout
      vim.defer_fn(function()
        vim.cmd("edit") -- Recharger le buffer pour redémarrer les LSP
        require("snacks").notify(
          "LSP ecosystem reset complete",
          { title = "Ecosystem", timeout = 3000 }
        )
        
        -- Recheck après reset
        vim.defer_fn(function()
          _G.show_complete_ecosystem_status()
        end, 2000)
      end, 1000)
    end
    
    -- ===================================================================
    -- CONFIGURATION DES DIAGNOSTICS UNIFIÉ
    -- ===================================================================
    
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = "󰌵 ",
        },
      },
      
      virtual_text = {
        enabled = true,
        spacing = 4,
        prefix = "●",
        format = function(diagnostic)
          local message = diagnostic.message
          if #message > 60 then
            message = message:sub(1, 57) .. "..."
          end
          
          -- Ajouter la source si elle existe
          local source = diagnostic.source
          if source and source ~= "" then
            return string.format("[%s] %s", source, message)
          end
          
          return message
        end,
      },
      
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        suffix = "",
        format = function(diagnostic)
          local code = diagnostic.code and string.format(" [%s]", diagnostic.code) or ""
          local source = diagnostic.source and string.format(" (%s)", diagnostic.source) or ""
          return string.format("%s%s%s", diagnostic.message, code, source)
        end,
      },
      
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      
      jump = {
        float = true,  -- Ouvrir float automatiquement lors de la navigation
      },
    })
    
    -- ===================================================================
    -- COMMANDES UNIFIÉES
    -- ===================================================================
    
    vim.api.nvim_create_user_command("LspInfo", function()
      _G.lsp_info()
    end, { desc = "Show complete LSP information" })
    
    vim.api.nvim_create_user_command("LspRestart", function()
      _G.unified_lsp_restart()
    end, { desc = "Restart all LSP clients" })
    
    vim.api.nvim_create_user_command("FormatToggle", function()
      _G.toggle_auto_format()
    end, { desc = "Toggle auto-format on save" })
    
    vim.api.nvim_create_user_command("LintToggle", function()
      _G.toggle_linting()
    end, { desc = "Toggle auto-linting" })
    
    vim.api.nvim_create_user_command("ToggleDiagnostics", function()
      local config = vim.diagnostic.config()
      if config and config.virtual_text then
        vim.diagnostic.config({ 
          virtual_text = false,
          signs = false,
          underline = false,
        })
        require("snacks").notify("Diagnostics disabled", { title = "Diagnostics" })
      else
        vim.diagnostic.config({ 
          virtual_text = true,
          signs = true, 
          underline = true,
        })
        require("snacks").notify("Diagnostics enabled", { title = "Diagnostics" })
      end
    end, { desc = "Toggle all diagnostics display" })
    
    vim.api.nvim_create_user_command("EcosystemStatus", function()
      _G.show_complete_ecosystem_status()
    end, { desc = "Show complete LSP ecosystem status" })
    
    vim.api.nvim_create_user_command("EcosystemHealth", function()
      _G.check_complete_ecosystem_health()
    end, { desc = "Run complete ecosystem health check" })
    
    vim.api.nvim_create_user_command("EcosystemReset", function()
      _G.reset_lsp_ecosystem()
    end, { desc = "Reset entire LSP ecosystem" })
    
    vim.api.nvim_create_user_command("FormatInfo", function()
      local conform_ok, conform = pcall(require, "conform")
      if conform_ok then
        local buf = vim.api.nvim_get_current_buf()
        local formatters = conform.list_formatters(buf)
        
        print("=== Format Information ===")
        print("Filetype: " .. vim.bo.filetype)
        print("Auto-format: " .. tostring(_G.lsp_unified_state.auto_format))
        
        if #formatters > 0 then
          print("Available formatters:")
          for i, formatter in ipairs(formatters) do
            local status = formatter.available and "✓" or "✗"
            print(string.format("  %d. %s %s", i, status, formatter.name))
            if not formatter.available and formatter.available_msg then
              print(string.format("     Reason: %s", formatter.available_msg))
            end
          end
        else
          print("No formatters configured for this filetype")
        end
      else
        print("Conform not available")
      end
    end, { desc = "Show formatting information" })
    
    vim.api.nvim_create_user_command("LintInfo", function()
      local lint_ok, lint = pcall(require, "lint")
      if lint_ok then
        local ft = vim.bo.filetype
        local linters = lint.linters_by_ft[ft] or {}
        
        print("=== Lint Information ===")
        print("Filetype: " .. ft)
        print("Auto-lint: " .. tostring(_G.lsp_unified_state.auto_lint))
        
        if #linters > 0 then
          print("Configured linters: " .. table.concat(linters, ", "))
        else
          print("No linters configured for this filetype")
        end
        
        -- Test de disponibilité des linters
        for _, linter_name in ipairs(linters) do
          local linter = lint.linters[linter_name]
          if linter and linter.cmd then
            local available = vim.fn.executable(linter.cmd) == 1
            print(string.format("  %s %s", available and "✓" or "✗", linter_name))
          end
        end
      else
        print("nvim-lint not available")
      end
    end, { desc = "Show linting information" })
    
    -- ===================================================================
    -- CONFIGURATION AVANCÉE
    -- ===================================================================
    
    -- Configuration none-ls avec sources dynamiques
    vim.defer_fn(function()
      local null_ls_ok, null_ls = pcall(require, "null-ls")
      if null_ls_ok then
        -- Ajouter des sources dynamiques selon les outils disponibles
        local sources = {}
        
        -- Gitsigns code actions
        if pcall(require, "gitsigns") then
          table.insert(sources, null_ls.builtins.code_actions.gitsigns)
        end
        
        -- Diagnostic sources selon la disponibilité
        if vim.fn.executable("deadnix") == 1 then
          table.insert(sources, null_ls.builtins.diagnostics.deadnix)
        end
        
        if vim.fn.executable("statix") == 1 then
          table.insert(sources, null_ls.builtins.diagnostics.statix)
        end
        
        if vim.fn.executable("shellcheck") == 1 then
          table.insert(sources, null_ls.builtins.diagnostics.shellcheck)
        end
        
        if vim.fn.executable("yamllint") == 1 then
          table.insert(sources, null_ls.builtins.diagnostics.yamllint)
        end
        
        if vim.fn.executable("actionlint") == 1 then
          table.insert(sources, null_ls.builtins.diagnostics.actionlint)
        end
        
        -- Reconfigurer none-ls avec les sources disponibles
        if #sources > 0 then
          null_ls.setup({
            sources = sources,
            on_attach = function(client, bufnr)
              -- Pas de formatage via none-ls (conform gère)
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end,
          })
        end
      end
    end, 1000)
    
  '';
}
