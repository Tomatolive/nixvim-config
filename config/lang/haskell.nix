{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION HASKELL - haskell-tools.nvim + HLS
  # =====================================================================
  
  # =====================================================================
  # HASKELL-TOOLS.NVIM - Plugin moderne pour Haskell
  # =====================================================================
  
  extraPlugins = with pkgs.vimPlugins; [
    haskell-tools-nvim
  ];
  
  # =====================================================================
  # PACKAGES REQUIS POUR HASKELL
  # =====================================================================
  extraPackages = with pkgs; [
    # Compilateur et outils de base
    ghc
    cabal-install
    stack
    
    # Language Server et outils de développement
    haskell-language-server
    
    # Outils de formatage et linting
    ormolu
    hlint
    
    # Outils de recherche et documentation
    haskellPackages.hoogle
    haskellPackages.fast-tags
    
    # REPL et outils interactifs
    ghcid
  ];
  
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
  ];
  
  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE
  # =====================================================================
  extraConfigLua = ''
    -- Configuration haskell-tools.nvim
    
    -- Setup haskell-tools avec configuration simplifiée
    local ht = require('haskell-tools')
    ht.setup({
      tools = {
        repl = {
          handler = 'builtin',
        },
      },
      hls = {
        settings = {
          haskell = {
            formattingProvider = 'ormolu',
            checkParents = 'CheckOnSave',
            checkProject = true,
            maxCompletions = 40,
            plugin = {
              ["ghcide-completions"] = { globalOn = true },
              ["ghcide-hover-and-symbols"] = { globalOn = true },
              ["ghcide-type-lenses"] = { globalOn = true },
              hlint = { globalOn = true },
              ormolu = { globalOn = true },
              stan = { globalOn = false },
            },
          },
        },
      },
    })
    
    -- ===================================================================
    -- KEYMAPS SPÉCIFIQUES À HASKELL (via autocommands)
    -- ===================================================================
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "haskell", "lhaskell" },
      callback = function(event)
        local bufnr = event.buf
        local opts = { noremap = true, silent = true, buffer = bufnr }
        
        -- Hoogle - Recherche de signatures de types
        vim.keymap.set('n', '<leader>hs', function()
          ht.hoogle.hoogle_signature()
        end, vim.tbl_extend('force', opts, { desc = "Hoogle search signature" }))
        
        -- Évaluation de code
        vim.keymap.set('n', '<leader>ea', function()
          ht.lsp.buf_eval_all()
        end, vim.tbl_extend('force', opts, { desc = "Evaluate all code snippets" }))
        
        -- REPL
        vim.keymap.set('n', '<leader>hr', function()
          ht.repl.toggle()
        end, vim.tbl_extend('force', opts, { desc = "Toggle Haskell REPL" }))
        
        vim.keymap.set('v', '<leader>hr', function()
          ht.repl.operator()
        end, vim.tbl_extend('force', opts, { desc = "Send selection to REPL" }))
        
        -- LSP spécifique Haskell
        vim.keymap.set('n', '<leader>hR', function()
          ht.lsp.restart()
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
            })
          end
        end, 100)
        
        print("Haskell keymaps loaded for buffer " .. bufnr)
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
      local ht_ok, _ = pcall(require, "haskell-tools")
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
      ht.repl.toggle()
    end, { desc = "Toggle Haskell REPL" })
    
    vim.api.nvim_create_user_command("HoogleSignature", function()
      ht.hoogle.hoogle_signature()
    end, { desc = "Search Hoogle for signature under cursor" })
    
    -- Auto-setup pour différents types de projets
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
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
