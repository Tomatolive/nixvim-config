{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION HASKELL - haskell-tools.nvim avec fallback LSP standard
  # =====================================================================

  # =====================================================================
  # HASKELL-TOOLS.NVIM - Plugin moderne pour Haskell
  # =====================================================================

  extraPlugins = with pkgs.vimPlugins; [
    haskell-tools-nvim
  ];

  # =====================================================================
  # LSP HASKELL STANDARD (fallback si haskell-tools ne fonctionne pas)
  # =====================================================================
  plugins.lsp.servers.hls = {
    enable = false; # Désactivé par défaut, activé si haskell-tools fail
    filetypes = [ "haskell" "lhaskell" ];

    settings = {
      haskell = {
        formattingProvider = "ormolu";
        checkParents = "CheckOnSave";
        checkProject = true;
        maxCompletions = 40;
        plugin = {
          "ghcide-completions" = { globalOn = true; };
          "ghcide-hover-and-symbols" = { globalOn = true; };
          "ghcide-type-lenses" = { globalOn = true; };
          hlint = { globalOn = true; };
          ormolu = { globalOn = true; };
          stan = { globalOn = false; };
        };
      };
    };
  };

  # =====================================================================
  # PACKAGES REQUIS POUR HASKELL
  # =====================================================================
  extraPackages = with pkgs; [
    # Compilateur et outils de base
    ghc
    cabal-install
    stack

    # Language Server
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
        end
      '';
    }
  ];

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE
  # =====================================================================
  extraConfigLua = ''
    -- ===================================================================
    -- ÉTAT GLOBAL POUR HASKELL-TOOLS
    -- ===================================================================
    local haskell_tools_available = false
    local ht = nil
    
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
    
    -- Fonction pour ouvrir un terminal avec une commande
    local function run_in_terminal(cmd, title)
      title = title or "Haskell"
      require("snacks").terminal.open(cmd, {
        cwd = vim.fn.getcwd(),
        title = title,
        size = { width = 0.8, height = 0.8 }
      })
    end
    
    -- Fonction pour ouvrir GHCi (fallback si haskell-tools pas disponible)
    local function open_ghci_fallback()
      local project_type = detect_project_type()
      local cmd
      
      if project_type == "stack" then
        cmd = "stack ghci"
      elseif project_type == "cabal" then
        cmd = "cabal repl"
      else
        cmd = "ghci"
      end
      
      run_in_terminal(cmd, "GHCi REPL")
    end
    
    -- ===================================================================
    -- SETUP HASKELL-TOOLS (avec gestion d'erreur et fallback)
    -- ===================================================================
    
    -- Fonction pour initialiser haskell-tools
    local function setup_haskell_tools()
      -- Essayer de charger haskell-tools
      local ok, haskell_tools = pcall(require, 'haskell-tools')
      
      if ok and haskell_tools and haskell_tools.setup then
        
        -- Setup haskell-tools
        local setup_ok, setup_err = pcall(function()
          haskell_tools.setup({
            tools = {
              repl = {
                handler = 'builtin',
                auto_focus = true,
              },
              hover = {
                disable = false,
                border = "rounded",
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
        end)
        
        if setup_ok then
          haskell_tools_available = true
          ht = haskell_tools
          return true
        end
      end
      
      -- Fallback vers LSP standard
      return false
    end
    
    -- ===================================================================
    -- FONCTIONS GLOBALES POUR HASKELL (appelées par les keymaps)
    -- ===================================================================
    
    _G.haskell_toggle_repl = function()
      if haskell_tools_available and ht.repl then
        ht.repl.toggle()
      else
        open_ghci_fallback()
      end
    end
    
    _G.haskell_load_file = function()
      if haskell_tools_available and ht.repl then
        local file = vim.api.nvim_buf_get_name(0)
        if file and file ~= "" then
          ht.repl.load_file(file)
        else
          ht.repl.toggle()
        end
      else
        local file = vim.api.nvim_buf_get_name(0)
        if file and file ~= "" then
          local cmd = "ghci " .. vim.fn.shellescape(file)
          run_in_terminal(cmd, "GHCi - " .. vim.fn.fnamemodify(file, ':t'))
        else
          open_ghci_fallback()
        end
      end
    end
    
    _G.haskell_execute_selection = function()
      if haskell_tools_available and ht.repl then
        ht.repl.operator()
      else
        local start_row = vim.fn.line("'<")
        local end_row = vim.fn.line("'>")
        local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
        local selection = table.concat(lines, "\n")
        vim.fn.setreg('+', selection)
        print("Selection copied to clipboard - paste in GHCi")
        open_ghci_fallback()
      end
    end
    
    _G.haskell_execute_line = function()
      if haskell_tools_available and ht.repl then
        local line = vim.api.nvim_get_current_line()
        if line and line:match("%S") then
          ht.repl.toggle()
          vim.defer_fn(function()
            vim.cmd('normal! yy')
            ht.repl.operator()
          end, 200)
        end
      else
        local line = vim.api.nvim_get_current_line()
        if line and line:match("%S") then
          vim.fn.setreg('+', line)
          print("Line copied to clipboard - paste in GHCi")
          open_ghci_fallback()
        end
      end
    end
    
    _G.haskell_clear_repl = function()
      if haskell_tools_available and ht.repl then
        ht.repl.quit()
        vim.defer_fn(function()
          ht.repl.toggle()
        end, 500)
      else
        -- Fermer les terminaux GHCi et en ouvrir un nouveau
        local buffers = vim.api.nvim_list_bufs()
        for _, buf in ipairs(buffers) do
          if vim.bo[buf].buftype == "terminal" then
            local name = vim.api.nvim_buf_get_name(buf)
            if name:match("ghci") or name:match("GHCi") then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end
        vim.defer_fn(open_ghci_fallback, 300)
      end
    end
    
    _G.haskell_build_project = function()
      local project_type = detect_project_type()
      local cmd
      
      if project_type == "stack" then
        cmd = "stack build"
      elseif project_type == "cabal" then
        cmd = "cabal build"
      else
        cmd = "ghc --make " .. vim.fn.expand('%')
      end
      
      run_in_terminal(cmd, "Build")
    end
    
    _G.haskell_test_project = function()
      local project_type = detect_project_type()
      local cmd
      
      if project_type == "stack" then
        cmd = "stack test"
      elseif project_type == "cabal" then
        cmd = "cabal test"
      else
        print("No test configuration found")
        return
      end
      
      run_in_terminal(cmd, "Tests")
    end
    
    _G.haskell_clean_build = function()
      local project_type = detect_project_type()
      local cmd
      
      if project_type == "stack" then
        cmd = "stack clean && stack build"
      elseif project_type == "cabal" then
        cmd = "cabal clean && cabal build"
      else
        cmd = "rm -f *.hi *.o " .. vim.fn.expand('%:r') .. " && ghc --make " .. vim.fn.expand('%')
      end
      
      run_in_terminal(cmd, "Clean Build")
    end
    
    _G.haskell_quick_compile = function()
      local file = vim.api.nvim_buf_get_name(0)
      if file and file ~= "" then
        local cmd = "ghc -Wall " .. vim.fn.shellescape(file)
        run_in_terminal(cmd, "Quick Compile")
      else
        print("No file to compile")
      end
    end
    
    _G.haskell_hoogle_search = function()
      if haskell_tools_available and ht.hoogle then
        ht.hoogle.hoogle_signature()
      else
        local word = vim.fn.expand('<cword>')
        if word and word ~= "" then
          local url = "https://hoogle.haskell.org/?hoogle=" .. vim.fn.substitute(word, ' ', '+', 'g')
          local browsers = {"xdg-open", "open", "start"}
          for _, browser in ipairs(browsers) do
            if vim.fn.executable(browser) == 1 then
              vim.fn.system(browser .. ' "' .. url .. '"')
              print("Opening Hoogle for: " .. word)
              return
            end
          end
          print("URL: " .. url)
        end
      end
    end
    
    _G.haskell_restart_lsp = function()
      if haskell_tools_available and ht.lsp and ht.lsp.restart then
        ht.lsp.restart()
      else
        vim.cmd("LspRestart")
      end
    end
    
    -- ===================================================================
    -- INITIALISATION
    -- ===================================================================
    
    -- Essayer de charger haskell-tools au démarrage
    vim.defer_fn(function()
      setup_haskell_tools()
    end, 2000)
  '';
}
