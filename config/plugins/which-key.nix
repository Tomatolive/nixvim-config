{
  # =====================================================================
  # WHICH-KEY - Configuration dans le style LazyVim UNIFIÉE
  # Intégré avec l'écosystème LSP unifié (conform + none-ls + nvim-lint)
  # =====================================================================

  plugins.which-key = {
    enable = true;

    settings = {
      # Preset helix comme LazyVim
      preset = "helix";

      # Pas de defaults dans LazyVim v3+
      defaults = { };

      # Configuration des icônes LazyVim style
      icons = {
        breadcrumb = "»";
        separator = "➜";
        group = "+";
        ellipsis = "…";
        mappings = true;
        rules = false;
        colors = true;
      };

      # Configuration de la fenêtre
      win = {
        no_overlap = true;
        padding = [
          1
          2
        ];
        title = true;
        title_pos = "center";
        border = "rounded";
        wo = {
          winblend = 10;
        };
      };

      # Layout LazyVim style
      layout = {
        width = {
          min = 20;
        };
        spacing = 3;
        align = "left";
      };

      # Delay LazyVim (plus rapide que notre ancienne config)
      delay = 200;

      # Disable pour certains filetypes (style LazyVim)
      disable = {
        ft = [ "TelescopePrompt" ];
      };
    };
  };

  # =====================================================================
  # CONFIGURATION LUA STYLE LAZYVIM AVEC ÉCOSYSTÈME LSP UNIFIÉ
  # =====================================================================

  extraConfigLua = ''
    -- Configuration LazyVim style pour which-key avec écosystème LSP unifié

    -- ===============================================================
    -- CONFIGURATION IMMÉDIATE DES GROUPES PRINCIPAUX
    -- ===============================================================

    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        -- Groupes principaux avec titres et icônes
        wk.add({
          { "<leader>f", group = " 󰈞 File & Find" },
          { "<leader>g", group = " 󰊢 Git" },
          { "<leader>b", group = " 󰓩 Buffers" },
          { "<leader>c", group = " 󰘦 Code (Unified LSP)" }, -- Mise à jour pour indiquer l'unification
          { "<leader>u", group = " 󰙵 UI & Toggles" }, -- Étendu avec les toggles
          { "<leader>x", group = " 󱖫 Diagnostics" },
          { "<leader>t", group = " 󰆍 Terminal" },
          { "<leader>n", group = " 󰂚 Notifications" },
          { "<leader>q", group = " 󰗼 Quit" },
          { "<leader>s", group = " 󰍉 Search" },
          
          -- Navigation avec titres
          { "g", group = " 󰈮 Goto" },
          { "[", group = " 󰒮 Previous" },
          { "]", group = " 󰒭 Next" },
          { "z", group = " 󰗘 Fold" },
          
          -- Which-key meta commands
          { 
            "<leader>?", 
            function()
              require("which-key").show({ global = false })
            end,
            desc = "Buffer Keymaps"
          },
          { 
            "<leader>K", 
            function()
              require("which-key").show({ global = true })
            end,
            desc = "All Keymaps"
          },
        })
      else
        print("Which-key: Failed to load")
      end
    end, 100)

    -- ===============================================================
    -- GROUPES CODE UNIFIÉS - <leader>c
    -- ===============================================================

    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          -- Code group principal avec sous-groupes organisés
          { "<leader>c", group = " 󰘦 Code (Unified Ecosystem)" },
          
          -- === Actions principales ===
          { "<leader>ca", desc = "Actions (LSP + none-ls)", icon = "󰌵" },
          { "<leader>cr", desc = "Rename (Unified)", icon = "󰑕" },
          
          -- === Formatage ===
          { "<leader>cf", desc = "Format (Conform)", icon = "" },
          { "<leader>cF", desc = "Format Async", icon = "󰃭" },
          { "<leader>cC", desc = "Cycle Formatter", icon = "󰦖" },
          { "<leader>ct", desc = "Toggle Auto-Format", icon = "󰔡" },
          
          -- === Linting ===
          { "<leader>cl", desc = "Toggle Auto-Lint", icon = "󰔡" },
          { "<leader>cL", desc = "Lint Now", icon = "" },
          { "<leader>cc", desc = "Clear Lint", icon = "󰃢" },
          
          -- === Information et debug ===
          { "<leader>ci", desc = "LSP Info (Complete)", icon = "" },
          { "<leader>cI", desc = "Format Info", icon = "" },
          { "<leader>cH", desc = "Format Health", icon = "󰓙" },
          { "<leader>ch", desc = "Lint Health", icon = "󰓙" },
          { "<leader>cn", desc = "none-ls Info", icon = "" },
          { "<leader>cN", desc = "none-ls Toggle", icon = "󰔡" },
          
          -- === Ecosystem management ===
          { "<leader>cS", desc = "Ecosystem Status", icon = "" },
          { "<leader>cE", desc = "Ecosystem Health", icon = "󰓙" },
          { "<leader>cX", desc = "Reset Ecosystem", icon = "󰜉" },
          
          -- === Système ===
          { "<leader>cR", desc = "Restart LSP", icon = "󰜉" },
          
          -- === Diagnostics ===
          { "<leader>cd", desc = "Line Diagnostics", icon = "" },
          { "<leader>cD", desc = "Buffer Diagnostics", icon = "" },
        })
      end
    end, 200)

    -- ===============================================================
    -- GROUPES UI ÉTENDUS - <leader>u
    -- ===============================================================

    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          -- UI group étendu avec tous les toggles de l'écosystème
          { "<leader>u", group = " 󰙵 UI & Toggles (Extended)" },
          
          -- === Toggles visuels ===
          { "<leader>ul", desc = "Toggle Line Numbers", icon = "󰎠" },
          { "<leader>ur", desc = "Toggle Relative Numbers", icon = "󰎠" },
          { "<leader>uw", desc = "Toggle Word Wrap", icon = "󰖶" },
          { "<leader>uG", desc = "Toggle Git Signs", icon = "󰊢" },
          { "<leader>un", desc = "Dismiss Notifications", icon = "󰂚" },
          
          -- === Toggles LSP/Format/Lint ===
          { "<leader>ud", desc = "Toggle Diagnostics", icon = "" },
          { "<leader>uf", desc = "Toggle Auto-Format", icon = "" },
          { "<leader>uL", desc = "Toggle Auto-Lint", icon = "" },
          
          -- === Shortcuts pour commandes fréquentes ===
          { "<leader>uF", desc = "Format Health Check", icon = "󰓙" },
          { "<leader>uh", desc = "Lint Health Check", icon = "󰓙" },
          { "<leader>ui", desc = "LSP Ecosystem Status", icon = "" },
        })
      end
    end, 250)

    -- ===============================================================
    -- INTÉGRATIONS SPÉCIALISÉES ET SOUS-GROUPES
    -- ===============================================================

    -- Git hunks (inchangé mais avec icônes améliorées)
    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          { "<leader>gh", group = " 󰊢 Git Hunks" },
          { "<leader>ghs", desc = "Stage Hunk", icon = "" },
          { "<leader>ghr", desc = "Reset Hunk", icon = "󰜉" },
          { "<leader>ghS", desc = "Stage Buffer", icon = "" },
          { "<leader>ghu", desc = "Undo Stage", icon = "󰕌" },
          { "<leader>ghR", desc = "Reset Buffer", icon = "󰜉" },
          { "<leader>ghp", desc = "Preview Inline", icon = "󰈈" },
          { "<leader>ghP", desc = "Preview Hunk", icon = "󰈈" },
          { "<leader>ghb", desc = "Blame Line", icon = "󰊢" },
          { "<leader>ghB", desc = "Blame Buffer", icon = "󰊢" },
          { "<leader>ghd", desc = "Diff This", icon = "󰈙" },
          { "<leader>ghD", desc = "Diff This ~", icon = "󰈙" },
        })
      end
    end, 300)

    -- Mini.surround (inchangé)
    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          { "gs", group = "󰴈 Surround" },
          { "gsa", desc = "Add Surround", icon = "󰴈" },
          { "gsd", desc = "Delete Surround", icon = "󰆴" },
          { "gsr", desc = "Replace Surround", icon = "󰛔" },
          { "gsf", desc = "Find Surround →", icon = "󰮡" },
          { "gsF", desc = "Find Surround ←", icon = "󰮢" },
          { "gsh", desc = "Highlight Surround", icon = "󰸱" },
          { "gsn", desc = "Update Lines", icon = "󰆾" },
        })
      end
    end, 350)

    -- Noice intégration (inchangé)
    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          { "<leader>sn", group = " 󰂚 Noice" },
          { "<leader>snh", desc = "Message History", icon = "󰄉" },
          { "<leader>sns", desc = "Stats", icon = "󰄉" },
        })
      end
    end, 400)

    -- ===============================================================
    -- LSP INTÉGRATION GLOBALE UNIFIÉE
    -- ===============================================================

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then return end
        
        local bufnr = event.buf
        local ft = vim.bo[bufnr].filetype
        local lsp_name = client.name
        
        vim.defer_fn(function()
          local ok, wk = pcall(require, "which-key")
          if not ok then return end
          
          -- Descriptions LSP dynamiques pour les keymaps existants
          local lsp_maps = {}
          
          -- Remapper les descriptions avec le nom du LSP
          if client.server_capabilities.hoverProvider then
            table.insert(lsp_maps, {
              "K",
              desc = "Hover (" .. lsp_name .. ")",
              buffer = bufnr
            })
            table.insert(lsp_maps, {
              "gh",
              desc = "Hover (" .. lsp_name .. ")",
              buffer = bufnr
            })
          end
          
          if client.server_capabilities.definitionProvider then
            table.insert(lsp_maps, {
              "gd",
              desc = "Definition (" .. lsp_name .. ")",
              buffer = bufnr
            })
          end
          
          if client.server_capabilities.referencesProvider then
            table.insert(lsp_maps, {
              "gr",
              desc = "References (" .. lsp_name .. ")",
              buffer = bufnr  
            })
          end
          
          if client.server_capabilities.implementationProvider then
            table.insert(lsp_maps, {
              "gi",
              desc = "Implementation (" .. lsp_name .. ")",
              buffer = bufnr
            })
          end
          
          if client.server_capabilities.typeDefinitionProvider then
            table.insert(lsp_maps, {
              "gt",
              desc = "Type Definition (" .. lsp_name .. ")",
              buffer = bufnr
            })
          end
          
          if client.server_capabilities.declarationProvider then
            table.insert(lsp_maps, {
              "gD",
              desc = "Declaration (" .. lsp_name .. ")",
              buffer = bufnr
            })
          end
          
          -- Ajouter les descriptions navigation diagnostic avec LSP
          table.insert(lsp_maps, {
            "[d",
            desc = "Prev Diagnostic (" .. lsp_name .. ")",
            buffer = bufnr
          })
          table.insert(lsp_maps, {
            "]d",
            desc = "Next Diagnostic (" .. lsp_name .. ")",
            buffer = bufnr
          })
          
          -- Mettre à jour les descriptions des keymaps code unifiés
          table.insert(lsp_maps, {
            "<leader>ca",
            desc = "Actions (LSP:" .. lsp_name .. " + none-ls)",
            buffer = bufnr
          })
          table.insert(lsp_maps, {
            "<leader>cr", 
            desc = "Rename (" .. lsp_name .. ")",
            buffer = bufnr
          })
          
          -- Ajouter tous les mappings LSP
          if #lsp_maps > 0 then
            wk.add(lsp_maps)
          end
        end, 500)
      end,
    })

    -- ===============================================================
    -- GROUPES PAR FILETYPE AVEC ÉCOSYSTÈME UNIFIÉ
    -- ===============================================================

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(event)
        local ft = event.match
        local bufnr = event.buf
        
        vim.defer_fn(function()
          local ok, wk = pcall(require, "which-key")
          if not ok then return end
          
          -- ===== CONFIGURATION NIX COMPLÈTE =====
          if ft == "nix" then
            wk.add({
              { "<leader>l", group = " 󱄅 Nix (Ecosystem + Tools)", icon = "", buffer = bufnr },
              
              -- === Actions LSP unifiées ===
              { "<leader>lf", desc = "Format (nixpkgs-fmt)", icon = "", buffer = bufnr },
              { "<leader>la", desc = "Actions (nixd + none-ls)", icon = "󰌵", buffer = bufnr },
              { "<leader>lr", desc = "Rename (nixd)", icon = "󰑕", buffer = bufnr },
              { "<leader>ld", desc = "Definition (nixd)", icon = "", buffer = bufnr },
              { "<leader>lh", desc = "Hover (nixd)", icon = "", buffer = bufnr },
              { "<leader>ll", desc = "Lint Info (deadnix+statix)", icon = "", buffer = bufnr },
              
              -- === Outils Nix spécifiques ===
              { "<leader>lb", desc = "Build/Flake", icon = "󰇘", buffer = bufnr },
              { "<leader>lc", desc = "Check/Parse", icon = "", buffer = bufnr },
              { "<leader>le", desc = "Eval Expression", icon = "", buffer = bufnr },
              { "<leader>ls", desc = "Show Flake", icon = "󰙅", buffer = bufnr },
              { "<leader>lD", desc = "Nix Develop", icon = "", buffer = bufnr },
            })
            
          -- ===== CONFIGURATION HASKELL COMPLÈTE =====
          elseif ft == "haskell" then
            -- Détecter le type d'outil Haskell
            local tool_info = "HLS"
            local ht_ok = pcall(require, "haskell-tools")
            if ht_ok then
              tool_info = "haskell-tools"
            end
            
            wk.add({
              -- Groupe principal organisé par catégories
              { "<leader>h", group = " Haskell (" .. tool_info .. " + Ecosystem)", icon = "", buffer = bufnr },
              
              -- === Actions LSP unifiées ===
              { "<leader>hf", desc = "Format (ormolu)", icon = "", buffer = bufnr },
              { "<leader>ha", desc = "Actions (" .. tool_info .. " + none-ls)", icon = "󰌵", buffer = bufnr },
              { "<leader>hR", desc = "Rename (" .. tool_info .. ")", icon = "󰑕", buffer = bufnr },
              { "<leader>hl", desc = "Lint Info (hlint)", icon = "", buffer = bufnr },
              
              -- === Information & Documentation ===
              { "<leader>hi", desc = "Type Info", icon = "", buffer = bufnr },
              { "<leader>hI", desc = "Signature Help", icon = "󰋼", buffer = bufnr },
              { "<leader>hs", desc = "Hoogle Search", icon = "", buffer = bufnr },
              { "<leader>hd", desc = "Hoogle Docs", icon = "󰈙", buffer = bufnr },
              { "<leader>hH", desc = "Hackage Search", icon = "󰏗", buffer = bufnr },
              
              -- === REPL & Execution ===
              { "<leader>hr", desc = "Toggle REPL", icon = "", buffer = bufnr },
              { "<leader>hL", desc = "Load in REPL", icon = "󰈙", buffer = bufnr },
              { "<leader>he", desc = "Execute in REPL", icon = "", buffer = bufnr },
              { "<leader>hc", desc = "Clear REPL", icon = "󰃢", buffer = bufnr },
              
              -- === Build & Project ===
              { "<leader>hb", desc = "Build", icon = "󰇘", buffer = bufnr },
              { "<leader>ht", desc = "Test", icon = "", buffer = bufnr },
              { "<leader>hx", desc = "Run Project", icon = "", buffer = bufnr },
              { "<leader>hC", desc = "Clean Build", icon = "󰃢", buffer = bufnr },
              { "<leader>hq", desc = "Quick Compile", icon = "󰅴", buffer = bufnr },
              { "<leader>hD", desc = "Install Deps", icon = "󰏗", buffer = bufnr },
            })
            
          -- ===== CONFIGURATION LUA =====
          elseif ft == "lua" then
            wk.add({
              { "<leader>l", group = " 󰢱 Lua (Unified)", buffer = bufnr },
              { "<leader>lf", desc = "Format (stylua)", icon = "", buffer = bufnr },
              { "<leader>la", desc = "Actions (lua_ls + none-ls)", icon = "󰌵", buffer = bufnr },
              { "<leader>lr", desc = "Rename (lua_ls)", icon = "󰑕", buffer = bufnr },
            })
            
          end
        end, 500)
      end,
    })

    -- ===============================================================
    -- INTÉGRATIONS ÉCOSYSTÈME LSP - Conform + Lint
    -- ===============================================================

    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          -- Mode insertion - complétion Blink
          mode = "i",
          { "<C-Space>", desc = "Trigger Completion (Blink)", icon = "󰄉" },
          { "<C-x><C-o>", desc = "LSP Completion (Blink)", icon = "" },
        })
        
        -- Info sur l'écosystème unifié disponible via commandes
        wk.add({
          -- Commandes d'information
          { "<leader>ci", desc = "LSP Info (Complete)", icon = "" },
          { "<leader>cI", desc = "Format Info (Conform)", icon = "" },
          
          -- Commandes en mode command
          mode = "c",
          { "LspInfo", desc = "Complete LSP information" },
          { "FormatInfo", desc = "Formatting tools info" }, 
          { "LintInfo", desc = "Linting tools info" },
          { "FormatToggle", desc = "Toggle auto-format" },
          { "LintToggle", desc = "Toggle auto-linting" },
        })
      end
    end, 600)

    -- ===============================================================
    -- DIAGNOSTICS NAVIGATION AMÉLIORÉE
    -- ===============================================================

    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          -- Navigation diagnostics avec indication des sources
          { "[d", desc = "Prev Diagnostic (LSP + Lint)", icon = "" },
          { "]d", desc = "Next Diagnostic (LSP + Lint)", icon = "" },
          { "[D", desc = "Prev Error", icon = "" },
          { "]D", desc = "Next Error", icon = "" },
          
          -- Diagnostic group
          { "<leader>x", group = " 󱖫 Diagnostics (Unified)" },
          { "<leader>xx", desc = "Quickfix List", icon = "" },
          { "<leader>xl", desc = "Location List", icon = "" },
          { "<leader>xd", desc = "Buffer Diagnostics", icon = "" },
          { "<leader>xe", desc = "Line Diagnostics", icon = "" },
        })
      end
    end, 700)

    -- ===============================================================
    -- FONCTIONS UTILITAIRES WHICH-KEY ÉTENDUES
    -- ===============================================================

    -- Fonction pour afficher l'état de l'écosystème LSP complet
    _G.show_lsp_ecosystem_status = function()
      print("=== Complete LSP Ecosystem Status ===")
      print("")
      
      -- État global
      if _G.lsp_unified_state then
        print("🔧 Global State:")
        print("  Auto-format: " .. (_G.lsp_unified_state.auto_format and "✓ enabled" or "✗ disabled"))
        print("  Auto-lint: " .. (_G.lsp_unified_state.auto_lint and "✓ enabled" or "✗ disabled"))
        print("  Format timeout: " .. _G.lsp_unified_state.format_timeout .. "ms")
        print("  Diagnostics: " .. (_G.lsp_unified_state.diagnostics_enabled and "✓ enabled" or "✗ disabled"))
        print("")
      end
      
      -- Buffer actuel
      local buf = vim.api.nvim_get_current_buf()
      local ft = vim.bo.filetype
      print("📄 Current Buffer:")
      print("  File: " .. (vim.api.nvim_buf_get_name(buf) or "[No Name]"))
      print("  Filetype: " .. ft)
      print("")
      
      -- LSP Clients
      local clients = vim.lsp.get_clients({ bufnr = buf })
      print("🔌 LSP Clients (" .. #clients .. "):")
      if #clients > 0 then
        for _, client in ipairs(clients) do
          local caps_count = client.server_capabilities and vim.tbl_count(client.server_capabilities) or 0
          print("  ✓ " .. client.name .. " (" .. caps_count .. " capabilities)")
        end
      else
        print("  ✗ No LSP clients attached")
      end
      print("")
      
      -- Conform formatters
      local conform_ok, conform = pcall(require, "conform")
      if conform_ok then
        local formatters = conform.list_formatters(buf)
        print("🎨 Conform Formatters (" .. #formatters .. "):")
        if #formatters > 0 then
          for _, formatter in ipairs(formatters) do
            local status = formatter.available and "✓" or "✗"
            print("  " .. status .. " " .. formatter.name)
          end
        else
          print("  ✗ No formatters available for " .. ft)
        end
      else
        print("🎨 Conform: ✗ not available")
      end
      print("")
      
      -- nvim-lint
      local lint_ok, lint = pcall(require, "lint")
      if lint_ok then
        local linters = lint.linters_by_ft[ft] or {}
        print("🔍 nvim-lint (" .. #linters .. "):")
        if #linters > 0 then
          for _, linter_name in ipairs(linters) do
            local linter = lint.linters[linter_name]
            if linter and linter.cmd then
              local available = vim.fn.executable(linter.cmd) == 1
              print("  " .. (available and "✓" or "✗") .. " " .. linter_name)
            else
              print("  ? " .. linter_name .. " (config missing)")
            end
          end
        else
          print("  ✗ No linters configured for " .. ft)
        end
      else
        print("🔍 nvim-lint: ✗ not available")
      end
      print("")
      
      -- none-ls
      local null_ls_ok, null_ls = pcall(require, "null-ls")
      if null_ls_ok then
        local sources = null_ls.get_sources({ filetype = ft })
        print("🚀 none-ls (" .. #sources .. " sources for " .. ft .. "):")
        if #sources > 0 then
          local by_method = {}
          for _, source in ipairs(sources) do
            local method = source.method or "unknown"
            by_method[method] = by_method[method] or {}
            table.insert(by_method[method], source.name)
          end
          
          for method, source_names in pairs(by_method) do
            print("  " .. method .. ": " .. table.concat(source_names, ", "))
          end
        else
          print("  ✗ No sources available for " .. ft)
        end
      else
        print("🚀 none-ls: ✗ not available")
      end
      print("")
      
      -- Diagnostics summary
      local diagnostics = vim.diagnostic.get(buf)
      local errors = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })
      local warnings = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.WARN })
      
      print("🩺 Diagnostics Summary:")
      print("  Total: " .. #diagnostics .. " (" .. errors .. " errors, " .. warnings .. " warnings)")
      print("")
      
      -- Commandes utiles
      print("💡 Useful Commands:")
      print("  :LspInfo        - Detailed LSP info")
      print("  :FormatInfo     - Formatting tools info") 
      print("  :LintInfo       - Linting tools info")
      print("  :FormatHealth   - Check all formatters")
      print("  :LintHealth     - Check all linters")
      print("  :NullLsInfo     - none-ls sources info")
      print("")
      print("📋 Quick Actions:")
      print("  <leader>ci      - LSP info")
      print("  <leader>cH      - Format health")
      print("  <leader>ch      - Lint health")
      print("  <leader>cn      - none-ls info")
    end

    -- Commandes pour which-key
    vim.api.nvim_create_user_command("WhichKeyEcosystem", function()
      show_lsp_ecosystem_status()
    end, { desc = "Show LSP ecosystem status" })

    vim.api.nvim_create_user_command("WhichKeyDebug", function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        print("=== Which-key + LSP Ecosystem Debug ===")
        
        -- Test des fonctions globales
        local functions = {
          "_G.unified_code_action",
          "_G.unified_rename", 
          "_G.unified_format",
          "_G.toggle_auto_format",
          "_G.toggle_linting",
          "_G.lsp_info",
          "_G.unified_lsp_restart",
        }
        
        print("Global functions:")
        for _, func_name in ipairs(functions) do
          local func = loadstring("return " .. func_name)
          local available = func and pcall(func) and "✓" or "✗"
          print("  " .. available .. " " .. func_name)
        end
        
        show_lsp_ecosystem_status()
      else
        print("Which-key not available")
      end
    end, { desc = "Debug which-key + LSP ecosystem" })

  '';
}
