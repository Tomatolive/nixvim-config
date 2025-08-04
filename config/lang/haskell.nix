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
          
          print("Haskell file loaded - setting up tools...")
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
        print("Loading haskell-tools.nvim...")
        
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
          print("✓ haskell-tools.nvim loaded successfully")
          return true
        else
          print("✗ haskell-tools.nvim setup failed: " .. (setup_err or "unknown error"))
        end
      else
        print("✗ haskell-tools.nvim not available: " .. (ok and "no setup function" or "require failed"))
      end
      
      -- Fallback vers LSP standard
      print("→ Falling back to standard HLS")
      return false
    end
    
    -- ===================================================================
    -- KEYMAPS ADAPTATIFS (haskell-tools ou fallback)
    -- ===================================================================
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "haskell", "lhaskell" },
      callback = function(event)
        local bufnr = event.buf
        local opts = { noremap = true, silent = true, buffer = bufnr }
        
        print("Setting up Haskell keymaps for buffer " .. bufnr)
        
        -- Essayer de configurer haskell-tools (avec délai pour le chargement)
        vim.defer_fn(function()
          if not haskell_tools_available then
            setup_haskell_tools()
          end
          
          -- ===== INFORMATION & DOCUMENTATION =====
          vim.keymap.set('n', '<leader>hi', function()
            vim.lsp.buf.hover()
          end, vim.tbl_extend('force', opts, { desc = "Show type info" }))
          
          vim.keymap.set('n', '<leader>hI', function()
            vim.lsp.buf.signature_help()
          end, vim.tbl_extend('force', opts, { desc = "Signature help" }))
          
          -- Hoogle search
          vim.keymap.set('n', '<leader>hs', function()
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
          end, vim.tbl_extend('force', opts, { desc = "Hoogle search" }))
          
          vim.keymap.set('n', '<leader>hd', function()
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
          end, vim.tbl_extend('force', opts, { desc = "Hoogle documentation" }))
          
          -- ===== REPL & EXECUTION =====
          vim.keymap.set('n', '<leader>hr', function()
            if haskell_tools_available and ht.repl then
              ht.repl.toggle()
            else
              open_ghci_fallback()
            end
          end, vim.tbl_extend('force', opts, { desc = "Toggle REPL" }))
          
          vim.keymap.set('n', '<leader>hl', function()
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
          end, vim.tbl_extend('force', opts, { desc = "Load file in REPL" }))
          
          vim.keymap.set('v', '<leader>he', function()
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
          end, vim.tbl_extend('force', opts, { desc = "Send selection to REPL" }))
          
          vim.keymap.set('n', '<leader>he', function()
            if haskell_tools_available and ht.repl then
              -- Pour haskell-tools, on peut envoyer la ligne courante
              local line = vim.api.nvim_get_current_line()
              if line and line:match("%S") then
                ht.repl.toggle()
                -- Envoyer la ligne via haskell-tools
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
          end, vim.tbl_extend('force', opts, { desc = "Execute line in REPL" }))
          
          -- Clear/restart REPL
          vim.keymap.set('n', '<leader>hc', function()
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
          end, vim.tbl_extend('force', opts, { desc = "Clear/restart REPL" }))
          
          -- ===== BUILD & COMPILATION =====
          vim.keymap.set('n', '<leader>hb', function()
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
          end, vim.tbl_extend('force', opts, { desc = "Build project" }))
          
          vim.keymap.set('n', '<leader>ht', function()
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
          end, vim.tbl_extend('force', opts, { desc = "Run tests" }))
          
          vim.keymap.set('n', '<leader>hC', function()
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
          end, vim.tbl_extend('force', opts, { desc = "Clean & build" }))
          
          vim.keymap.set('n', '<leader>hq', function()
            local file = vim.api.nvim_buf_get_name(0)
            if file and file ~= "" then
              local cmd = "ghc -Wall " .. vim.fn.shellescape(file)
              run_in_terminal(cmd, "Quick Compile")
            else
              print("No file to compile")
            end
          end, vim.tbl_extend('force', opts, { desc = "Quick compile" }))
          
          -- ===== CODE ACTIONS =====
          vim.keymap.set('n', '<leader>hf', function()
            require('conform').format({ async = true, lsp_fallback = true })
          end, vim.tbl_extend('force', opts, { desc = "Format code" }))
          
          vim.keymap.set('n', '<leader>hE', function()
            vim.diagnostic.setloclist()
          end, vim.tbl_extend('force', opts, { desc = "Show diagnostics" }))
          
          -- LSP restart
          vim.keymap.set('n', '<leader>hR', function()
            if haskell_tools_available and ht.lsp and ht.lsp.restart then
              ht.lsp.restart()
            else
              vim.cmd("LspRestart")
            end
          end, vim.tbl_extend('force', opts, { desc = "Restart LSP" }))
          
          -- ===== OUTILS AVANCÉS =====
          vim.keymap.set('n', '<leader>hx', function()
            local project_name = vim.fn.input("Executable name: ")
            if project_name and project_name ~= "" then
              local cmd = "stack exec " .. project_name
              run_in_terminal(cmd, "Stack Exec")
            end
          end, vim.tbl_extend('force', opts, { desc = "Stack exec" }))
          
          vim.keymap.set('n', '<leader>hB', function()
            local project_type = detect_project_type()
            local cmd
            
            if project_type == "stack" then
              cmd = "stack bench"
            elseif project_type == "cabal" then
              cmd = "cabal bench"
            else
              print("No benchmark configuration")
              return
            end
            
            run_in_terminal(cmd, "Benchmarks")
          end, vim.tbl_extend('force', opts, { desc = "Run benchmarks" }))
          
          vim.keymap.set('n', '<leader>hT', function()
            run_in_terminal("fast-tags -R .", "Generate Tags")
          end, vim.tbl_extend('force', opts, { desc = "Generate tags" }))
          
          vim.keymap.set('n', '<leader>hL', function()
            run_in_terminal("hlint " .. vim.fn.expand('%'), "HLint")
          end, vim.tbl_extend('force', opts, { desc = "Run HLint" }))
          
          -- ===== WHICH-KEY INTEGRATION =====
          vim.defer_fn(function()
            local ok, wk = pcall(require, "which-key")
            if ok then
              local tool_name = haskell_tools_available and "haskell-tools" or "standard"
              
              wk.add({
                -- Groupe principal avec indication de l'outil utilisé
                { "<leader>h", group = "Haskell (" .. tool_name .. ")", icon = " ", buffer = bufnr },
                
                -- Information & Documentation
                { "<leader>hi", desc = "Type Info", icon = " ", buffer = bufnr },
                { "<leader>hI", desc = "Signature Help", icon = "󰋼 ", buffer = bufnr },
                { "<leader>hs", desc = "Hoogle Search", icon = " ", buffer = bufnr },
                { "<leader>hd", desc = "Hoogle Docs", icon = "󰈙 ", buffer = bufnr },
                
                -- REPL & Execution
                { "<leader>hr", desc = "Toggle REPL", icon = " ", buffer = bufnr },
                { "<leader>hl", desc = "Load in REPL", icon = "󰈙 ", buffer = bufnr },
                { "<leader>he", desc = "Execute in REPL", icon = " ", buffer = bufnr },
                { "<leader>hc", desc = "Clear REPL", icon = "󰃢 ", buffer = bufnr },
                
                -- Build & Compilation
                { "<leader>hb", desc = "Build", icon = "󰇘 ", buffer = bufnr },
                { "<leader>ht", desc = "Test", icon = " ", buffer = bufnr },
                { "<leader>hC", desc = "Clean Build", icon = "󰃢 ", buffer = bufnr },
                { "<leader>hq", desc = "Quick Compile", icon = "󰅴 ", buffer = bufnr },
                
                -- Code Actions
                { "<leader>hf", desc = "Format", icon = " ", buffer = bufnr },
                { "<leader>hE", desc = "Diagnostics", icon = " ", buffer = bufnr },
                { "<leader>hR", desc = "Restart LSP", icon = "󰜉 ", buffer = bufnr },
                
                -- Advanced Tools
                { "<leader>hx", desc = "Stack Exec", icon = " ", buffer = bufnr },
                { "<leader>hB", desc = "Benchmarks", icon = "󰓅 ", buffer = bufnr },
                { "<leader>hT", desc = "Tags", icon = " ", buffer = bufnr },
                { "<leader>hL", desc = "HLint", icon = "󰠘 ", buffer = bufnr },
              })
              print("Haskell which-key mappings added (" .. tool_name .. " mode)")
            else
              print("Which-key not available")
            end
          end, 300)
          
          print("Haskell keymaps setup complete (" .. (haskell_tools_available and "haskell-tools" or "standard") .. " mode)")
        end, 1000) -- Délai plus long pour laisser le temps aux plugins de se charger
      end,
    })
    
    -- ===================================================================
    -- FONCTIONS GLOBALES DE DEBUG
    -- ===================================================================
    
    _G.debug_haskell = function()
      print("=== Haskell Debug ===")
      print("Filetype:", vim.bo.filetype)
      print("Project type:", detect_project_type())
      print("Haskell-tools available:", haskell_tools_available)
      
      if haskell_tools_available then
        print("Haskell-tools features:")
        if ht.repl then print("  ✓ REPL") else print("  ✗ REPL") end
        if ht.hoogle then print("  ✓ Hoogle") else print("  ✗ Hoogle") end
        if ht.lsp then print("  ✓ LSP extensions") else print("  ✗ LSP extensions") end
      end
      
      -- LSP clients
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      print("LSP clients:", #clients)
      for _, client in ipairs(clients) do
        print("  - " .. client.name)
      end
      
      -- Diagnostics
      local diagnostics = vim.diagnostic.get(0)
      print("Diagnostics:", #diagnostics)
      
      -- Which-key
      local ok, wk = pcall(require, "which-key")
      print("Which-key available:", ok)
    end
    
    _G.test_haskell_tools = function()
      print("=== Testing Haskell Tools ===")
      
      -- Test require
      local ok, ht_test = pcall(require, 'haskell-tools')
      print("Require haskell-tools:", ok)
      
      if ok then
        print("Available functions:")
        for k, v in pairs(ht_test) do
          print("  " .. k .. ": " .. type(v))
        end
      end
      
      -- Test setup
      setup_haskell_tools()
    end
    
    -- ===================================================================
    -- INITIALISATION
    -- ===================================================================
    
    -- Essayer de charger haskell-tools au démarrage
    vim.defer_fn(function()
      setup_haskell_tools()
    end, 2000)
    
    print("Haskell configuration with haskell-tools support loaded")
  '';
}
