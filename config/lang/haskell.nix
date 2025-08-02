{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION HASKELL - haskell-tools.nvim + HLS
  # =====================================================================
  
  # Activer treesitter pour Haskell
  plugins.treesitter.settings.ensure_installed = [ "haskell" ];
  
  # =====================================================================
  # HASKELL-TOOLS.NVIM - Plugin moderne pour Haskell
  # =====================================================================
  
  # Ajouter haskell-tools.nvim via extraPlugins
  extraPlugins = with pkgs.vimPlugins; [
    haskell-tools-nvim
  ];
  
  # =====================================================================
  # PACKAGES REQUIS POUR HASKELL
  # =====================================================================
  extraPackages = with pkgs; [
    # Compilateur et outils de base
    ghc                           # Glasgow Haskell Compiler
    cabal-install                 # Build tool
    stack                         # Alternative build tool
    
    # Language Server et outils de développement
    haskell-language-server       # LSP server principal
    haskellPackages.haskell-debug-adapter         # Pour debugging (optionnel)
    
    # Outils de formatage et linting
    ormolu                        # Formatage du code Haskell
    hlint                         # Linter Haskell
    
    # Outils de recherche et documentation
    haskellPackages.hoogle                        # Recherche de types et fonctions
    haskellPackages.fast-tags                     # Génération de tags
    
    # REPL et outils interactifs
    ghcid                         # Live reloading pour GHCi
  ];
  
  # =====================================================================
  # CONFIGURATION HASKELL-TOOLS (corrigée)
  # =====================================================================
  globals = {
    # Configuration simplifiée et correcte de haskell-tools
    haskell_tools = {
      # Configuration des outils
      tools = {
        # Configuration REPL
        repl = {
          handler = "builtin";  # ou "toggleterm" si vous avez toggleterm
        };
        
        # Configuration des tags
        tags = {
          enable = true;
          package_events = [ "BufWritePost" ];
        };
      };
      
      # Configuration HLS (Haskell Language Server)
      hls = {
        # Paramètres HLS
        settings = {
          haskell = {
            # Formatage avec ormolu
            formattingProvider = "ormolu";
            
            # Vérifications
            checkParents = "CheckOnSave";
            checkProject = true;
            
            # Complétion
            maxCompletions = 40;
            
            # Plugins HLS
            plugin = {
              # Activer les plugins utiles
              "ghcide-completions" = { globalOn = true; };
              "ghcide-hover-and-symbols" = { globalOn = true; };
              "ghcide-type-lenses" = { globalOn = true; };
              hlint = { globalOn = true; };
              ormolu = { globalOn = true; };
              
              # Désactiver les plugins moins utiles
              stan = { globalOn = false; };
            };
          };
        };
      };
      
      # Configuration DAP (debugging) - optionnel
      dap = {
        auto_discover = true;
      };
    };
  };
  
  # =====================================================================
  # FORMATAGE AVEC ORMOLU
  # =====================================================================
  plugins.conform-nvim.settings = {
    formatters_by_ft = {
      haskell = [ "ormolu" ];
    };
    
    formatters = {
      ormolu = {
        command = "ormolu";
        args = [ ];
        stdin = true;
      };
    };
  };
  
  # =====================================================================
  # KEYMAPS SPÉCIFIQUES À HASKELL - SUPPRIMÉS (voir extraConfigLua)
  # =====================================================================
  # Les keymaps sont maintenant définis dans extraConfigLua via autocommands
  # car buffer = true ne fonctionne pas correctement dans nixvim
  
  # =====================================================================
  # AUTOCOMMANDS POUR HASKELL
  # =====================================================================
  autoCmd = [
    # Configuration pour les fichiers Haskell
    {
      event = [ "FileType" ];
      pattern = [ "haskell" "lhaskell" ];
      callback.__raw = ''
        function()
          -- Configuration d'indentation Haskell (2 espaces standard)
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.softtabstop = 2
          
          -- Commentaires Haskell
          vim.bo.commentstring = "-- %s"
          
          -- Options spécifiques Haskell
          vim.wo.foldmethod = "indent"
          vim.wo.foldlevel = 99
          
          -- Refresh automatique des code lenses (simplifié)
          vim.defer_fn(function()
            if vim.lsp.codelens then
              vim.lsp.codelens.refresh()
            end
          end, 1000)
          
          print("Haskell configuration loaded with haskell-tools.nvim")
        end
      '';
    }
    
    # Configuration pour les fichiers Cabal
    {
      event = [ "FileType" ];
      pattern = [ "cabal" "cabalproject" ];
      callback.__raw = ''
        function()
          -- Configuration Cabal
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.commentstring = "-- %s"
          
          print("Cabal configuration loaded")
        end
      '';
    }
    
    # Auto-format on save pour Haskell (optionnel)
    {
      event = [ "BufWritePre" ];
      pattern = [ "*.hs" "*.lhs" ];
      callback.__raw = ''
        function()
          -- Format avec ormolu si disponible
          require("conform").format({ 
            async = false, 
            timeout_ms = 2000,
            lsp_fallback = true 
          })
        end
      '';
    }
  ];
  
  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE
  # =====================================================================
  extraConfigLua = ''
    -- Configuration avancée pour Haskell
    
    -- ===================================================================
    -- KEYMAPS SPÉCIFIQUES À HASKELL (via autocommands + which-key)
    -- ===================================================================
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "haskell", "lhaskell" },
      callback = function(event)
        local bufnr = event.buf
        local opts = { noremap = true, silent = true, buffer = bufnr }
        
        -- Code Lenses (très important pour HLS)
        vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, 
          vim.tbl_extend('force', opts, { desc = "Run Code Lens (Haskell)" }))
        
        -- Hoogle - Recherche de signatures de types
        vim.keymap.set('n', '<leader>hs', function()
          require('haskell-tools').hoogle.hoogle_signature()
        end, vim.tbl_extend('force', opts, { desc = "Hoogle search signature" }))
        
        -- Évaluation de code
        vim.keymap.set('n', '<leader>ea', function()
          require('haskell-tools').lsp.buf_eval_all()
        end, vim.tbl_extend('force', opts, { desc = "Evaluate all code snippets" }))
        
        -- REPL
        vim.keymap.set('n', '<leader>hr', function()
          require('haskell-tools').repl.toggle()
        end, vim.tbl_extend('force', opts, { desc = "Toggle Haskell REPL" }))
        
        vim.keymap.set('v', '<leader>hr', function()
          require('haskell-tools').repl.operator()
        end, vim.tbl_extend('force', opts, { desc = "Send selection to REPL" }))
        
        -- LSP spécifique Haskell
        vim.keymap.set('n', '<leader>hR', function()
          require('haskell-tools').lsp.restart()
        end, vim.tbl_extend('force', opts, { desc = "Restart Haskell LSP" }))
        
        -- Gestion de projets
        vim.keymap.set('n', '<leader>hb', '<cmd>!stack build<cr>', 
          vim.tbl_extend('force', opts, { desc = "Stack build" }))
        
        vim.keymap.set('n', '<leader>ht', '<cmd>!stack test<cr>', 
          vim.tbl_extend('force', opts, { desc = "Stack test" }))
        
        -- Fast Tags
        vim.keymap.set('n', '<leader>hT', '<cmd>!fast-tags -R .<cr>', 
          vim.tbl_extend('force', opts, { desc = "Generate tags" }))
        
        -- ===== INTÉGRATION WHICH-KEY POUR HASKELL =====
        vim.defer_fn(function()
          local ok, wk = pcall(require, "which-key")
          if ok then
            wk.add({
              { "<leader>h", group = "Haskell", icon = " ", buffer = bufnr },
              { "<leader>hb", desc = "Stack Build", icon = "󰇘 ", buffer = bufnr },
              { "<leader>ht", desc = "Stack Test", icon = " ", buffer = bufnr },
              { "<leader>hT", desc = "Generate Tags", icon = " ", buffer = bufnr },
              { "<leader>hr", desc = "Toggle REPL", icon = " ", buffer = bufnr },
              { "<leader>hR", desc = "Restart HLS", icon = "󰜉 ", buffer = bufnr },
              { "<leader>hs", desc = "Hoogle Search", icon = " ", buffer = bufnr },
              { "<leader>ea", desc = "Evaluate Code", icon = " ", buffer = bufnr },
              { "<leader>cl", desc = "Code Lens", icon = "󰌵 ", buffer = bufnr },
            })
          end
        end, 100)
        
        print("Haskell keymaps + which-key loaded for buffer " .. bufnr)
      end,
    })
    
    -- ===================================================================
    -- FONCTIONS UTILITAIRES
    -- ===================================================================
    
    -- Fonction pour détecter le type de projet (Stack vs Cabal)
    local function detect_project_type()
      local stack_file = vim.fn.findfile('stack.yaml', '.;')
      local cabal_project = vim.fn.findfile('cabal.project', '.;')
      local cabal_file = vim.fn.glob('*.cabal')
      
      if stack_file ~= "" then
        return "stack"
      elseif cabal_project ~= "" or cabal_file ~= "" then
        return "cabal"
      else
        return "unknown"
      end
    end
    
    -- Fonction utilitaire pour débugger haskell-tools
    _G.debug_haskell_tools = function()
      local ht_ok, ht = pcall(require, "haskell-tools")
      if not ht_ok then
        print("haskell-tools.nvim not loaded")
        return
      end
      
      print("=== Haskell Tools Debug ===")
      print("Project type:", detect_project_type())
      
      -- Vérifier HLS
      local clients = vim.lsp.get_clients({ name = "haskell-language-server" })
      if #clients > 0 then
        print("HLS clients:", #clients)
        for _, client in ipairs(clients) do
          print("  - Client ID:", client.id)
          print("  - Root dir:", client.config.root_dir)
          print("  - Capabilities:", vim.tbl_count(client.server_capabilities or {}))
        end
      else
        print("No HLS clients active")
      end
      
      -- Diagnostics Haskell
      local diagnostics = vim.diagnostic.get(0)
      print("Diagnostics:", #diagnostics)
    end
    
    -- Fonction pour rebuild le projet
    _G.haskell_build = function()
      local project_type = detect_project_type()
      local cmd
      
      if project_type == "stack" then
        cmd = "stack build"
      elseif project_type == "cabal" then
        cmd = "cabal build"
      else
        print("Unknown project type")
        return
      end
      
      print("Building with: " .. cmd)
      vim.cmd("!" .. cmd)
    end
    
    -- Fonction pour lancer les tests
    _G.haskell_test = function()
      local project_type = detect_project_type()
      local cmd
      
      if project_type == "stack" then
        cmd = "stack test"
      elseif project_type == "cabal" then
        cmd = "cabal test"
      else
        print("Unknown project type")
        return
      end
      
      print("Testing with: " .. cmd)
      vim.cmd("!" .. cmd)
    end
    
    -- Commandes personnalisées
    vim.api.nvim_create_user_command("HaskellBuild", function()
      haskell_build()
    end, { desc = "Build Haskell project" })
    
    vim.api.nvim_create_user_command("HaskellTest", function()
      haskell_test()
    end, { desc = "Test Haskell project" })
    
    vim.api.nvim_create_user_command("HaskellRepl", function()
      require('haskell-tools').repl.toggle()
    end, { desc = "Toggle Haskell REPL" })
    
    vim.api.nvim_create_user_command("HoogleSignature", function()
      require('haskell-tools').hoogle.hoogle_signature()
    end, { desc = "Search Hoogle for signature under cursor" })
    
    -- Auto-setup pour différents types de projets
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Détecter et configurer selon le type de projet
        vim.defer_fn(function()
          local project_type = detect_project_type()
          if project_type ~= "unknown" then
            print("Detected " .. project_type .. " project")
          end
        end, 500)
      end,
    })
  '';
}
