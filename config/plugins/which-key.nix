{
  # =====================================================================
  # WHICH-KEY - Configuration dans le style LazyVim
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
  # NOTE: Les keymaps which-key sont définis dans config/config/keymaps.nix
  # pour éviter les redondances et conflits
  # =====================================================================

  # =====================================================================
  # CONFIGURATION LUA STYLE LAZYVIM
  # =====================================================================

  extraConfigLua = ''
    -- Configuration LazyVim style pour which-key

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
    -- LSP INTÉGRATION SIMPLIFIÉE
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
          
          if client.server_capabilities.hoverProvider then
            table.insert(lsp_maps, {
              "K",
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
        end, 1000)
      end,
    })

    -- ===============================================================
    -- GROUPES PAR FILETYPE
    -- ===============================================================

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(event)
        local ft = event.match
        local bufnr = event.buf
        
        vim.defer_fn(function()
          local ok, wk = pcall(require, "which-key")
          if not ok then return end
          
          -- Groupes spécialisés
          if ft == "nix" then
            wk.add({
              { "<leader>l", group = " 󱄅 Nix", buffer = bufnr },
            })
          elseif ft == "haskell" then
            wk.add({
              { "<leader>h", group = " 󰲒 Haskell", buffer = bufnr },
            })
          elseif ft == "lua" then
            wk.add({
              { "<leader>l", group = " 󰢱 Lua", buffer = bufnr },
            })
          end
        end, 200)
      end,
    })
  '';
}
