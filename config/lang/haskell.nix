{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION HASKELL - Spécificités uniquement
  # LSP/Format/Lint gérés par l'écosystème unifié dans lang/default.nix
  # =====================================================================

  # =====================================================================
  # HASKELL-TOOLS.NVIM - Plugin moderne pour Haskell
  # =====================================================================

  extraPlugins = with pkgs.vimPlugins; [
    haskell-tools-nvim
  ];

  # =====================================================================
  # LSP HASKELL STANDARD (sera configuré par l'écosystème unifié)
  # =====================================================================
  plugins.lsp.servers.hls = {
    enable = true;
    filetypes = [ "haskell" "lhaskell" ];

    settings = {
      haskell = {
        formattingProvider = "ormolu"; # Sera désactivé par l'écosystème unifié
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
  # PACKAGES SPÉCIFIQUES HASKELL
  # (les formatters/linters sont dans default.nix)
  # =====================================================================
  extraPackages = with pkgs; [
    # Compilateur et outils de base
    ghc
    cabal-install
    stack

    # Language Server
    haskell-language-server

    # Outils de recherche et documentation (spécifiques Haskell)
    haskellPackages.hoogle
    haskellPackages.fast-tags

    # REPL et outils interactifs (spécifiques Haskell)
    ghcid
  ];

  # =====================================================================
  # AUTOCOMMANDS POUR HASKELL
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "haskell" "lhaskell" ];
      callback.__raw = ''
        function()
          -- Configuration d'indentation Haskell
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.softtabstop = 2
          
          -- Commentaires Haskell
          vim.bo.commentstring = "-- %s"
          
          -- Options spécifiques Haskell
          vim.wo.foldmethod = "indent"
          vim.wo.foldlevel = 99
          
          -- Configuration Blink pour Haskell (HLS est rapide)
          local blink_ok, blink = pcall(require, 'blink.cmp')
          if blink_ok and blink.update_sources then
            pcall(function()
              blink.update_sources({
                per_filetype = {
                  haskell = { "lsp", "snippets", "buffer" }  -- LSP en premier (rapide)
                }
              })
            end)
          end
        end
      '';
    }

    {
      event = [ "FileType" ];
      pattern = [ "cabal" "cabalproject" ];
      callback.__raw = ''
        function()
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.commentstring = "-- %s"
        end
      '';
    }
  ];

  # =====================================================================
  # FONCTIONS SPÉCIFIQUES HASKELL - REPL, Build, Documentation
  # (pas liées à l'écosystème LSP standard)
  # =====================================================================
  extraConfigLua = ''
    -- ===================================================================
    -- ÉTAT GLOBAL POUR HASKELL-TOOLS
    -- ===================================================================
    local haskell_tools_available = false
    local ht = nil
    
    -- ===================================================================
    -- FONCTIONS UTILITAIRES HASKELL
    -- ===================================================================
    
    -- Détecter le type de projet
    local function detect_haskell_project_type()
      local stack_file = vim.fn.findfile('stack.yaml', '.;')
      local cabal_project = vim.fn.findfile('cabal.project', '.;')
      local cabal_file = vim.fn.glob('*.cabal')
      
      if stack_file ~= "" then
        return "stack"
      elseif cabal_project ~= "" or cabal_file ~= "" then
        return "cabal"
      else
        return "standalone"
      end
    end
    
    -- Terminal Haskell
    local function run_haskell_terminal(cmd, title)
      title = title or "Haskell"
      require("snacks").terminal.open(cmd, {
        cwd = vim.fn.getcwd(),
        title = title,
        size = { width = 0.8, height = 0.8 }
      })
    end
    
    -- GHCi fallback
    local function open_ghci_fallback()
      local project_type = detect_haskell_project_type()
      local cmd
      
      if project_type == "stack" then
        cmd = "stack ghci"
      elseif project_type == "cabal" then
        cmd = "cabal repl"
      else
        cmd = "ghci"
      end
      
      run_haskell_terminal(cmd, "GHCi REPL")
    end
    
    -- ===================================================================
    -- SETUP HASKELL-TOOLS
    -- ===================================================================
    
    local function setup_haskell_tools()
      local ok, haskell_tools = pcall(require, 'haskell-tools')
      
      if ok and haskell_tools and haskell_tools.setup then
        local setup_ok = pcall(function()
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
              -- Note: formatting et capabilities gérés par l'écosystème unifié
              settings = {
                haskell = {
                  formattingProvider = 'ormolu', -- Sera désactivé
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
          require("snacks").notify(
            "haskell-tools loaded (ecosystem: LSP unified)",
            { title = "Haskell", timeout = 2000 }
          )
          return true
        else
          require("snacks").notify(
            "haskell-tools setup failed, using standard HLS",
            { title = "Haskell", level = "warn" }
          )
        end
      end
      
      return false
    end
    
    -- ===================================================================
    -- FONCTIONS GLOBALES SPÉCIFIQUES HASKELL
    -- Note: Format/Rename/Actions gérés par l'écosystème unifié
    -- Ces fonctions sont pour REPL, Build, Documentation uniquement
    -- ===================================================================
    
    -- === REPL Functions ===
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
          run_haskell_terminal(cmd, "GHCi - " .. vim.fn.fnamemodify(file, ':t'))
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
        require("snacks").notify(
          "Selection copied - paste in GHCi",
          { title = "Haskell" }
        )
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
          require("snacks").notify(
            "Line copied - paste in GHCi",
            { title = "Haskell" }
          )
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
        -- Fermer les terminaux GHCi
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
    
    -- === Build Functions ===
    _G.haskell_build_project = function()
      local project_type = detect_haskell_project_type()
      local cmd
      
      if project_type == "stack" then
        cmd = "stack build"
      elseif project_type == "cabal" then
        cmd = "cabal build"
      else
        cmd = "ghc --make " .. vim.fn.expand('%')
      end
      
      run_haskell_terminal(cmd, "Build")
    end
    
    _G.haskell_test_project = function()
      local project_type = detect_haskell_project_type()
      local cmd
      
      if project_type == "stack" then
        cmd = "stack test"
      elseif project_type == "cabal" then
        cmd = "cabal test"
      else
        require("snacks").notify(
          "No test configuration found",
          { title = "Haskell", level = "warn" }
        )
        return
      end
      
      run_haskell_terminal(cmd, "Tests")
    end
    
    _G.haskell_clean_build = function()
      local project_type = detect_haskell_project_type()
      local cmd
      
      if project_type == "stack" then
        cmd = "stack clean && stack build"
      elseif project_type == "cabal" then
        cmd = "cabal clean && cabal build"
      else
        cmd = "rm -f *.hi *.o " .. vim.fn.expand('%:r') .. " && ghc --make " .. vim.fn.expand('%')
      end
      
      run_haskell_terminal(cmd, "Clean Build")
    end
    
    _G.haskell_quick_compile = function()
      local file = vim.api.nvim_buf_get_name(0)
      if file and file ~= "" then
        local cmd = "ghc -Wall " .. vim.fn.shellescape(file)
        run_haskell_terminal(cmd, "Quick Compile")
      else
        require("snacks").notify(
          "No file to compile",
          { title = "Haskell", level = "warn" }
        )
      end
    end
    
    -- === Documentation Functions ===
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
              require("snacks").notify(
                "Opening Hoogle for: " .. word,
                { title = "Haskell" }
              )
              return
            end
          end
          require("snacks").notify(
            "Hoogle URL: " .. url,
            { title = "Haskell" }
          )
        else
          require("snacks").notify(
            "No word under cursor",
            { title = "Haskell", level = "warn" }
          )
        end
      end
    end
    
    _G.haskell_docs_search = function()
      local word = vim.fn.expand('<cword>')
      if word and word ~= "" then
        local cmd = "hoogle --info " .. vim.fn.shellescape(word)
        run_haskell_terminal(cmd, "Hoogle Info - " .. word)
      else
        require("snacks").notify(
          "No word under cursor", 
          { title = "Haskell", level = "warn" }
        )
      end
    end
    
    _G.haskell_hackage_search = function()
      local word = vim.fn.expand('<cword>')
      if word and word ~= "" then
        local url = "https://hackage.haskell.org/packages/search?terms=" .. word
        local browsers = {"xdg-open", "open", "start"}
        for _, browser in ipairs(browsers) do
          if vim.fn.executable(browser) == 1 then
            vim.fn.system(browser .. ' "' .. url .. '"')
            require("snacks").notify(
              "Opening Hackage for: " .. word,
              { title = "Haskell" }
            )
            return
          end
        end
        require("snacks").notify(
          "Hackage URL: " .. url,
          { title = "Haskell" }
        )
      else
        require("snacks").notify(
          "No word under cursor",
          { title = "Haskell", level = "warn" }
        )
      end
    end
    
    -- === Project Functions ===
    _G.haskell_run_project = function()
      local project_type = detect_haskell_project_type()
      local cmd
      
      if project_type == "stack" then
        cmd = "stack run"
      elseif project_type == "cabal" then
        cmd = "cabal run"
      else
        local file = vim.api.nvim_buf_get_name(0)
        if file and file ~= "" then
          local exe = vim.fn.expand('%:r')
          cmd = "./" .. exe
        else
          require("snacks").notify(
            "No executable to run",
            { title = "Haskell", level = "warn" }
          )
          return
        end
      end
      
      run_haskell_terminal(cmd, "Run")
    end
    
    _G.haskell_install_deps = function()
      local project_type = detect_haskell_project_type()
      local cmd
      
      if project_type == "stack" then
        cmd = "stack install --dependencies-only"
      elseif project_type == "cabal" then
        cmd = "cabal install --dependencies-only"
      else
        require("snacks").notify(
          "No project configuration found",
          { title = "Haskell", level = "warn" }
        )
        return
      end
      
      run_haskell_terminal(cmd, "Install Dependencies")
    end
    
    -- ===================================================================
    -- INITIALISATION HASKELL-TOOLS
    -- ===================================================================
    
    vim.defer_fn(function()
      local success = setup_haskell_tools()
      if not success then
        require("snacks").notify(
          "Using standard HLS (ecosystem: LSP unified)",
          { title = "Haskell", level = "info" }
        )
      end
    end, 2000)
    
    -- ===================================================================
    -- COMMANDES SPÉCIFIQUES HASKELL
    -- ===================================================================
    
    -- REPL commands
    vim.api.nvim_create_user_command("HaskellRepl", function()
      haskell_toggle_repl()
    end, { desc = "Toggle Haskell REPL" })
    
    vim.api.nvim_create_user_command("HaskellLoad", function()
      haskell_load_file()
    end, { desc = "Load current file in REPL" })
    
    -- Build commands
    vim.api.nvim_create_user_command("HaskellBuild", function()
      haskell_build_project()
    end, { desc = "Build Haskell project" })
    
    vim.api.nvim_create_user_command("HaskellTest", function()
      haskell_test_project()
    end, { desc = "Test Haskell project" })
    
    vim.api.nvim_create_user_command("HaskellRun", function()
      haskell_run_project()
    end, { desc = "Run Haskell project" })
    
    vim.api.nvim_create_user_command("HaskellClean", function()
      haskell_clean_build()
    end, { desc = "Clean and build Haskell project" })
    
    vim.api.nvim_create_user_command("HaskellCompile", function()
      haskell_quick_compile()
    end, { desc = "Quick compile current file" })
    
    vim.api.nvim_create_user_command("HaskellDeps", function()
      haskell_install_deps()
    end, { desc = "Install project dependencies" })
    
    -- Documentation commands
    vim.api.nvim_create_user_command("HaskellHoogle", function()
      haskell_hoogle_search()
    end, { desc = "Hoogle search for word under cursor" })
    
    vim.api.nvim_create_user_command("HaskellDocs", function()
      haskell_docs_search()
    end, { desc = "Hoogle docs for word under cursor" })
    
    vim.api.nvim_create_user_command("HaskellHackage", function()
      haskell_hackage_search()
    end, { desc = "Hackage search for word under cursor" })
    
    -- Info command
    vim.api.nvim_create_user_command("HaskellInfo", function()
      local project_type = detect_haskell_project_type()
      local clients = vim.lsp.get_clients({ bufnr = 0, name = "haskell-language-server" })
      local ht_available = haskell_tools_available and "✓" or "✗"
      
      print("=== Haskell Configuration ===")
      print("Project type: " .. project_type)
      print("haskell-tools: " .. ht_available)
      print("HLS clients: " .. #clients)
      
      if #clients > 0 then
        for _, client in ipairs(clients) do
          print("  - " .. client.name .. " (root: " .. (client.config.root_dir or "none") .. ")")
        end
      end
      
      print("")
      print("Ecosystem status:")
      print("  Format: managed by conform (ormolu)")
      print("  Lint: managed by nvim-lint (hlint)")
      print("  Actions: managed by unified LSP + none-ls")
      print("")
      print("Haskell-specific commands:")
      print("  :HaskellRepl/:HaskellLoad - REPL management")
      print("  :HaskellBuild/:HaskellTest/:HaskellRun - Build system")
      print("  :HaskellHoogle/:HaskellDocs/:HaskellHackage - Documentation")
      print("")
      print("Unified LSP actions available via <leader>c*")
    end, { desc = "Show Haskell configuration info" })
    
    print("Haskell language configuration loaded (ecosystem managed globally)")
  '';
}
