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

    -- Couleurs LazyVim style (adapté pour gruvbox)
    local function setup_which_key_lazyvim_colors()
      -- Couleurs inspirées de LazyVim mais adaptées pour gruvbox
      local colors = {
        bg = "#3c3836",      -- gruvbox dark1
        fg = "#ebdbb2",      -- gruvbox light1
        border = "#b8bb26",  -- gruvbox bright green
        title = "#fe8019",   -- gruvbox bright orange
        desc = "#8ec07c",    -- gruvbox bright aqua
        key = "#83a598",     -- gruvbox bright blue
        group = "#d3869b",   -- gruvbox bright purple
        separator = "#928374", -- gruvbox gray
        icon = "#fabd2f",    -- gruvbox bright yellow
        cyan = "#8ec07c",    -- pour les icônes cyan
        green = "#b8bb26",   -- pour les icônes green
      }
      
      -- Highlights which-key style LazyVim
      vim.api.nvim_set_hl(0, "WhichKey", { 
        fg = colors.key, 
        bold = true 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyGroup", { 
        fg = colors.group 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyDesc", { 
        fg = colors.desc 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeySeparator", { 
        fg = colors.separator 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyNormal", { 
        bg = colors.bg,
        fg = colors.fg
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyBorder", { 
        fg = colors.border,
        bg = colors.bg
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyTitle", { 
        fg = colors.title,
        bg = colors.bg,
        bold = true 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyIcon", { 
        fg = colors.icon 
      })
      
      -- Couleurs pour les icônes spécifiques LazyVim
      vim.api.nvim_set_hl(0, "WhichKeyIconCyan", { 
        fg = colors.cyan 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyIconGreen", { 
        fg = colors.green 
      })
    end

    -- Appliquer les couleurs immédiatement
    setup_which_key_lazyvim_colors()

    -- Appliquer les couleurs après le chargement du colorscheme
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "gruvbox*",
      callback = function()
        vim.defer_fn(setup_which_key_lazyvim_colors, 50)
      end,
    })

    -- ===============================================================
    -- CONFIGURATION IMMÉDIATE DES GROUPES (fix du timing)
    -- ===============================================================

    -- Configuration immédiate des groupes principaux
    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        -- Groupes principaux avec titres (ajoutés immédiatement)
        wk.add({
          { "<leader>f", group = "󰈞 File & Find" },
          { "<leader>g", group = "󰊢 Git" },
          { "<leader>b", group = "󰓩 Buffers" },
          { "<leader>c", group = "󰘦 Code" },
          { "<leader>u", group = "󰙵 UI" },
          { "<leader>x", group = "󱖫 Diagnostics" },
          { "<leader>t", group = "󰆍 Terminal" },
          { "<leader>n", group = "󰂚 Notifications" },
          { "<leader>q", group = "󰗼 Quit" },
          { "<leader>s", group = "󰍉 Search" },
          { "<leader><tab>", group = "󰓩 Tabs" },
          { "<leader>l", group = "󰅘 Language" },
          
          -- Navigation avec titres
          { "g", group = "󰈮 Goto" },
          { "[", group = "󰒮 Previous" },
          { "]", group = "󰒭 Next" },
          { "z", group = "󰗘 Fold" },
          
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
        print("Which-key: Main groups configured")
      else
        print("Which-key: Failed to load")
      end
    end, 100)

    -- Configuration supplémentaire via VeryLazy pour s'assurer que c'est bien chargé
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        vim.defer_fn(function()
          local ok, wk = pcall(require, "which-key")
          if ok then
            -- Re-ajouter les groupes pour s'assurer qu'ils sont là
            wk.add({
              { "<leader>f", group = "󰈞 File & Find" },
              { "<leader>g", group = "󰊢 Git" },
              { "<leader>b", group = "󰓩 Buffers" },
              { "<leader>c", group = "󰘦 Code" },
              { "<leader>u", group = "󰙵 UI" },
              { "<leader>x", group = "󱖫 Diagnostics" },
              { "<leader>t", group = "󰆍 Terminal" },
              { "<leader>n", group = "󰂚 Notifications" },
            })
            print("Which-key: Groups reinforced via VeryLazy")
          end
        end, 200)
      end,
    })

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
          
          if #lsp_maps > 0 then
            wk.add(lsp_maps)
            print("Which-key: Added " .. lsp_name .. " mappings")
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
              { "<leader>l", group = "󱄅 Nix", buffer = bufnr },
            })
            print("Which-key: Added Nix group")
          elseif ft == "haskell" then
            wk.add({
              { "<leader>h", group = "󰲒 Haskell", buffer = bufnr },
            })
            print("Which-key: Added Haskell group")
          elseif ft == "lua" then
            wk.add({
              { "<leader>l", group = "󰢱 Lua", buffer = bufnr },
            })
            print("Which-key: Added Lua group")
          end
        end, 200)
      end,
    })

    -- ===============================================================
    -- DEBUG FONCTION
    -- ===============================================================

    _G.debug_which_key = function()
      print("=== Which-Key Debug ===")
      print("Filetype:", vim.bo.filetype)
      
      local ok, wk = pcall(require, "which-key")
      if ok then
        print("Which-key loaded: ✓")
        
        -- Tester manuellement l'ajout d'un groupe
        wk.add({
          { "<leader>T", group = "🧪 Test Group" },
        })
        print("Added test group - try <leader>T")
      else
        print("Which-key not loaded: ✗")
      end
      
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      print("LSP clients:", #clients)
      for _, client in ipairs(clients) do
        print("  - " .. client.name)
      end
    end

    -- Tester immédiatement
    vim.defer_fn(function()
      print("Which-key config loaded, testing...")
      debug_which_key()
    end, 2000)
  '';
}
