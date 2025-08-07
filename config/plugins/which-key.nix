{
  # =====================================================================
  # WHICH-KEY - Configuration avec Haskell conforme
  # =====================================================================

  plugins.which-key = {
    enable = true;

    settings = {
      preset = "helix";
      icons = {
        breadcrumb = "»";
        separator = "➜";
        group = "+";
      };
      win = {
        border = "rounded";
        padding = [ 1 2 ];
      };
      delay = 200;
    };
  };

  # =====================================================================
  # CONFIGURATION SIMPLIFIÉE
  # =====================================================================
  extraConfigLua = ''
    -- Configuration des groupes principaux
    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          { "<leader>b", group = "Buffers" },
          { "<leader>c", group = "Code" },
          { "<leader>f", group = "Find" },
          { "<leader>g", group = "Git" },
          { "<leader>n", group = "Notifications" },
          { "<leader>r", group = "Persistence" },
          { "<leader>s", group = "Snacks" },
          { "<leader>t", group = "Terminal" },
          { "<leader>u", group = "UI" },
          { "<leader>x", group = "Diagnostics" },
          
          -- Navigation
          { "g", group = "󰈮 Goto" },
          { "[", group = "󰒮 Previous" },
          { "]", group = "󰒭 Next" },
        })
      end
    end, 100)
    
    -- Configuration par filetype
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(event)
        local ft = event.match
        local bufnr = event.buf
        
        vim.defer_fn(function()
          local ok, wk = pcall(require, "which-key")
          if not ok then return end
          
          if ft == "nix" then
            wk.add({
              { "<leader>N", group = "󱄅 Nix", buffer = bufnr },
            })
            
          elseif ft == "haskell" then
            -- Configuration Haskell SIMPLIFIÉE - conforme aux docs
            wk.add({
              { "<leader>h", group = "󰲒 Haskell", buffer = bufnr },
              
              -- Keymaps haskell-tools (API officielle)
              { "<leader>hr", desc = "Toggle REPL", icon = "", buffer = bufnr },
              { "<leader>hl", desc = "Load in REPL", icon = "󰈙", buffer = bufnr },
              { "<leader>he", desc = "Evaluate", icon = "", buffer = bufnr },
              { "<leader>hc", desc = "Evaluate All", icon = "󰓃", buffer = bufnr },
              { "<leader>hs", desc = "Hoogle Search", icon = "", buffer = bufnr },
              
              -- Note: LSP standard géré automatiquement par haskell-tools
              -- Plus besoin de keymaps custom - tout est auto-configuré !
            })

          elseif ft == "c" or ft == "cpp" then
            wk.add({
              { "<leader>C", group = "󰙱 C/C++", buffer = bufnr },
            })
          end
        end, 500)
      end,
    })
    
    -- Auto-description LSP (marche avec haskell-tools maintenant)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then return end
        
        local bufnr = event.buf
        local lsp_name = client.name
        
        vim.defer_fn(function()
          local ok, wk = pcall(require, "which-key")
          if not ok then return end
          
          -- Descriptions automatiques selon le LSP attaché
          local lsp_maps = {}
          
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
          
          -- Actions code unifiées
          table.insert(lsp_maps, {
            "<leader>ca",
            desc = "Actions (" .. lsp_name .. ")",
            buffer = bufnr
          })
          table.insert(lsp_maps, {
            "<leader>cr",
            desc = "Rename (" .. lsp_name .. ")", 
            buffer = bufnr
          })
          
          if #lsp_maps > 0 then
            wk.add(lsp_maps)
          end
        end, 300)
      end,
    })
  '';
}
