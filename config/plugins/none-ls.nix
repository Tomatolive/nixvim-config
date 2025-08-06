{
  # =====================================================================
  # NONE-LS - Configuration centralisée des sources non-LSP
  # Intégré avec l'écosystème LSP unifié
  # =====================================================================

  plugins.none-ls = {
    enable = true;
    enableLspFormat = false; # conform.nvim gère le formatage
    updateInInsert = false;   # Évite le spam de diagnostics

    # =====================================================================
    # SOURCES NONE-LS - Organisées par type
    # =====================================================================
    sources = {
      # =================================================================
      # CODE ACTIONS - Actions intelligentes non-LSP
      # =================================================================
      code_actions = {
        # Git intégration
        gitsigns = {
          enable = true;
          # Actions: stage hunk, reset hunk, etc.
        };
      };

      # =================================================================
      # DIAGNOSTICS - Linting complémentaire aux LSP
      # =================================================================
      diagnostics = {
        # === NIX ===
        deadnix = {
          enable = true;
          # condition.__raw = ''
          #   function(utils)
          #     return utils.root_has_file({"flake.nix", "default.nix", "shell.nix"})
          #   end
          # '';
        };

        statix = {
          enable = true;
          # condition.__raw = ''
          #   function(utils)
          #     return utils.root_has_file({"flake.nix", "default.nix", "shell.nix"})
          #   end
          # '';
        };

        # === HASKELL (complémentaire à HLS) ===
        # hlint géré par nvim-lint mais on peut l'avoir ici aussi
        
      };

      # =================================================================
      # FORMATAGE - Seulement pour les cas où conform ne suffit pas
      # =================================================================
      formatting = {
        # Généralement, on laisse conform gérer le formatage
        # none-ls est utilisé ici pour des cas très spéciaux seulement
        
        # Exemple pour un formatter très spécialisé :
        # custom_formatter = {
        #   enable = false; # Désactivé par défaut
        #   command = "custom-tool";
        #   args = ["--stdin"];
        #   to_stdin = true;
        # };
      };

      # =================================================================
      # HOVER - Informations supplémentaires
      # =================================================================
      hover = {
        # Dictionnaire (désactivé car trop intrusif)
        dictionary = {
          enable = false;
        };
      };

      # =================================================================
      # COMPLETION - Sources de complétion non-LSP
      # =================================================================
      completion = {
        # Snippets générés dynamiquement
        # Note: Blink gère déjà les snippets, donc on évite la duplication
      };
    };

    # =====================================================================
    # CONFIGURATION NONE-LS
    # =====================================================================
    settings = {
      # Mise à jour en temps réel (mais pas en insert)
      update_in_insert = false;
      
      # Debounce pour éviter le spam
      debounce = 250;
      
      # Sources par défaut (peuvent être override par filetype)
      default_timeout = 5000;
      
      # Niveau de log
      log_level = "warn"; # Évite le spam de logs
      
      # Diagnostics config
      diagnostics_config = {
        underline = true;
        virtual_text = {
          spacing = 4;
          prefix = "●";
        };
        signs = true;
        update_in_insert = false;
        severity_sort = true;
      };

      # Sources conditionnelles selon les outils disponibles
      root_dir.__raw = ''
        function(fname)
          return require("null-ls.utils").root_pattern(
            "flake.nix",
            ".git",
            "package.json",
            "Cargo.toml",
            "pyproject.toml",
            "go.mod",
            "stack.yaml",
            "cabal.project"
          )(fname)
        end
      '';
    };
  };

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE LUA
  # =====================================================================

  extraConfigLua = ''
    -- ===================================================================
    -- CONFIGURATION NONE-LS AVANCÉE
    -- ===================================================================
    
    vim.defer_fn(function()
      local null_ls_ok, null_ls = pcall(require, "null-ls")
      if not null_ls_ok then
        print("none-ls not available")
        return
      end
      
      -- ===================================================================
      -- SOURCES DYNAMIQUES SELON LA DISPONIBILITÉ DES OUTILS
      -- ===================================================================
      
      local dynamic_sources = {}
      
      -- Vérifier la disponibilité des outils et ajouter les sources
      local tool_checks = {
        -- Git
        {
          tool = "git",
          source = null_ls.builtins.code_actions.gitsigns,
          desc = "Git actions"
        },
        
        -- Nix tools
        {
          tool = "deadnix",
          source = null_ls.builtins.diagnostics.deadnix,
          desc = "Nix dead code detection"
        },
        {
          tool = "statix",
          source = null_ls.builtins.diagnostics.statix,
          desc = "Nix linting"
        },
      }
      
      -- Ajouter les sources disponibles
      local available_tools = {}
      for _, check in ipairs(tool_checks) do
        if vim.fn.executable(check.tool) == 1 then
          table.insert(dynamic_sources, check.source)
          table.insert(available_tools, check.desc)
        end
      end
      
      -- Configuration finale none-ls avec sources dynamiques
      if #dynamic_sources > 0 then
        null_ls.setup({
          sources = dynamic_sources,
          
          -- onAttach spécifique none-ls
          on_attach = function(client, bufnr)
            -- Désactiver le formatage none-ls (conform gère)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            
            -- Debug info
            local source_count = #dynamic_sources
            require("snacks").notify(
              string.format("none-ls attached with %d sources", source_count),
              { title = "none-ls", timeout = 2000 }
            )
          end,
          
          -- Configuration avancée
          update_in_insert = false,
          debounce = 250,
          default_timeout = 5000,
          
          -- Root dir detection
          root_dir = function(fname)
            return require("null-ls.utils").root_pattern(
              "flake.nix",
              ".git", 
              "package.json",
              "Cargo.toml",
              "pyproject.toml",
              "go.mod",
              "stack.yaml",
              "cabal.project"
            )(fname) or vim.fn.getcwd()
          end,
        })
        
        print("none-ls configured with tools: " .. table.concat(available_tools, ", "))
      else
        print("none-ls: no tools available")
      end
    end, 1500)
    
    -- ===================================================================
    -- FONCTIONS UTILITAIRES NONE-LS
    -- ===================================================================
    
    _G.none_ls_info = function()
      local null_ls_ok, null_ls = pcall(require, "null-ls")
      if not null_ls_ok then
        print("none-ls not available")
        return
      end
      
      print("=== none-ls Information ===")
      
      -- Sources actives
      local sources = null_ls.get_sources()
      print("Active sources (" .. #sources .. "):")
      
      local by_method = {}
      for _, source in ipairs(sources) do
        local method = source.method or "unknown"
        by_method[method] = by_method[method] or {}
        table.insert(by_method[method], source.name)
      end
      
      for method, source_names in pairs(by_method) do
        print("  " .. method .. ": " .. table.concat(source_names, ", "))
      end
      
      -- État par buffer
      local buf = vim.api.nvim_get_current_buf()
      local ft = vim.bo.filetype
      local buf_sources = null_ls.get_sources({ filetype = ft })
      
      print("")
      print("For current buffer (" .. ft .. "):")
      print("  Available sources: " .. #buf_sources)
      for _, source in ipairs(buf_sources) do
        print("    - " .. source.name .. " (" .. (source.method or "unknown") .. ")")
      end
    end
    
    _G.none_ls_toggle = function()
      local null_ls_ok, null_ls = pcall(require, "null-ls")
      if null_ls_ok then
        null_ls.disable({})
        vim.defer_fn(function()
          null_ls.enable({})
          require("snacks").notify("none-ls reloaded", { title = "none-ls" })
        end, 500)
      else
        require("snacks").notify("none-ls not available", { title = "none-ls", level = "error" })
      end
    end
    
    -- ===================================================================
    -- COMMANDES NONE-LS
    -- ===================================================================
    
    vim.api.nvim_create_user_command("NullLsInfo", function()
      _G.none_ls_info()
    end, { desc = "Show none-ls information" })
    
    vim.api.nvim_create_user_command("NullLsToggle", function()
      _G.none_ls_toggle()
    end, { desc = "Toggle none-ls on/off" })
    
  '';
}
