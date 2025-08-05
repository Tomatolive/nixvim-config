{
  # =====================================================================
  # WHICH-KEY - Configuration dans le style LazyVim COMPLÈTE
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
  # CONFIGURATION LUA STYLE LAZYVIM AVEC TOUTES LES INTÉGRATIONS
  # =====================================================================

  extraConfigLua = ''
    -- Configuration LazyVim style pour which-key avec toutes les intégrations

    -- ===============================================================
    -- CONFIGURATION IMMÉDIATE DES GROUPES (fix du timing)
    -- ===============================================================

    -- Configuration immédiate des groupes principaux
    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        -- Groupes principaux avec titres (ajoutés immédiatement)
        wk.add({
          { "<leader>f", group = " 󰈞 File & Find" },
          { "<leader>g", group = " 󰊢 Git" },
          { "<leader>b", group = " 󰓩 Buffers" },
          { "<leader>c", group = " 󰘦 Code" },
          { "<leader>u", group = " 󰙵 UI" },
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
    -- INTÉGRATION MINI.SURROUND
    -- ===============================================================

    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          -- Mini.surround group
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
    end, 300)

    -- ===============================================================
    -- LSP INTÉGRATION GLOBALE
    -- ===============================================================

    -- Autocommand pour LSP attach
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
          
          -- Ajouter descriptions LSP aux keymaps existants
          local lsp_maps = {}
          
          if client.server_capabilities.codeActionProvider then
            table.insert(lsp_maps, {
              "<leader>ca",
              desc = "Code Actions (" .. lsp_name .. ")",
              buffer = bufnr
            })
          end
          
          if client.server_capabilities.renameProvider then
            table.insert(lsp_maps, {
              "<leader>cr",
              desc = "Rename (" .. lsp_name .. ")",
              buffer = bufnr
            })
          end
          
          if client.server_capabilities.documentFormattingProvider then
            table.insert(lsp_maps, {
              "<leader>cf",
              desc = "Format (" .. lsp_name .. ")",
              buffer = bufnr
            })
          end
          
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
          
          -- Ajouter les mappings LSP
          if #lsp_maps > 0 then
            wk.add(lsp_maps)
          end
        end, 1000)
      end,
    })

    -- ===============================================================
    -- GROUPES PAR FILETYPE (intégrés depuis les différents fichiers)
    -- ===============================================================

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(event)
        local ft = event.match
        local bufnr = event.buf
        
        vim.defer_fn(function()
          local ok, wk = pcall(require, "which-key")
          if not ok then return end
          
          -- ===== CONFIGURATION NIX =====
          if ft == "nix" then
            wk.add({
              { "<leader>l", group = " 󱄅 Nix (Optimized)", icon = " ", buffer = bufnr },
              { "<leader>lf", desc = "Format (Fast)", icon = " ", buffer = bufnr },
              { "<leader>ld", desc = "Definition (Fast)", icon = " ", buffer = bufnr },
              { "<leader>lh", desc = "Hover Info", icon = " ", buffer = bufnr },
              { "<leader>la", desc = "Actions (Fast)", icon = "󰌵 ", buffer = bufnr },
              { "<leader>lR", desc = "Rename", icon = "󰑕 ", buffer = bufnr },
              { "<leader>ls", desc = "Speed Mode", icon = "󰓅 ", buffer = bufnr },
            })
            
          -- ===== CONFIGURATION HASKELL =====
          elseif ft == "haskell" then
            -- Détecter si haskell-tools est disponible
            local tool_name = "standard"
            local ht_ok = pcall(require, "haskell-tools")
            if ht_ok then
              tool_name = "haskell-tools"
            end
            
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
            })
            
          -- ===== CONFIGURATION LUA =====
          elseif ft == "lua" then
            wk.add({
              { "<leader>l", group = " 󰢱 Lua", buffer = bufnr },
            })
            
          end
        end, 500)
      end,
    })

    -- ===============================================================
    -- INTÉGRATIONS SPÉCIALISÉES
    -- ===============================================================

    -- Git hunks navigation
    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          -- Git hunks sous-groupe
          { "<leader>gh", group = " 󰊢 Git Hunks" },
          { "<leader>ghs", desc = "Stage Hunk", icon = " " },
          { "<leader>ghr", desc = "Reset Hunk", icon = "󰜉 " },
          { "<leader>ghS", desc = "Stage Buffer", icon = " " },
          { "<leader>ghu", desc = "Undo Stage", icon = "󰕌 " },
          { "<leader>ghR", desc = "Reset Buffer", icon = "󰜉 " },
          { "<leader>ghp", desc = "Preview Inline", icon = "󰈈 " },
          { "<leader>ghP", desc = "Preview Hunk", icon = "󰈈 " },
          { "<leader>ghb", desc = "Blame Line", icon = "󰊢 " },
          { "<leader>ghB", desc = "Blame Buffer", icon = "󰊢 " },
          { "<leader>ghd", desc = "Diff This", icon = "󰈙 " },
          { "<leader>ghD", desc = "Diff This ~", icon = "󰈙 " },
        })
      end
    end, 400)

    -- Noice intégration
    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          -- Noice sous-groupe  
          { "<leader>sn", group = " 󰂚 Noice" },
          { "<leader>snh", desc = "Message History", icon = "󰄉 " },
          { "<leader>sns", desc = "Stats", icon = "󰄉 " },
        })
      end
    end, 500)

    -- Blink completion info (sans keymaps, juste pour info)
    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        -- Info sur les keymaps Blink (pas de vrais keymaps, juste documentation)
        wk.add({
          -- Mode insertion - juste pour documentation
          mode = "i",
          { "<C-Space>", desc = "Trigger Completion (Blink)" },
          { "<C-x><C-o>", desc = "LSP Completion (Blink)" },
        })
      end
    end, 600)

    -- ===============================================================
    -- FONCTIONS UTILITAIRES WHICH-KEY
    -- ===============================================================

    -- Commande pour afficher toutes les intégrations
    vim.api.nvim_create_user_command("WhichKeyIntegrations", function()
      show_which_key_integrations()
    end, { desc = "Show all which-key integrations" })

    -- Commande pour déboguer
    vim.api.nvim_create_user_command("WhichKeyDebug", function()
      debug_which_key_integration()
    end, { desc = "Debug which-key integration" })

  '';
}
