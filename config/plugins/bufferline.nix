{
  # =====================================================================
  # BUFFERLINE - Configuration style LazyVim avec toutes les fonctionnalités
  # =====================================================================

  plugins.bufferline = {
    enable = true;

    settings = {
      options = {
        # Commandes de fermeture avec intégration Snacks
        close_command.__raw = ''
          function(n)
            require("snacks").bufdelete(n)
          end
        '';
        right_mouse_command.__raw = ''
          function(n)
            require("snacks").bufdelete(n)
          end
        '';
        left_mouse_command = "buffer %d";
        middle_mouse_command = null;

        # Diagnostics LSP style LazyVim avec icônes personnalisées
        diagnostics = "nvim_lsp";
        diagnostics_update_in_insert = false;
        diagnostics_indicator.__raw = ''
            function(_, _, diag)
            -- Icônes colorées et distinctives
            local icons = {
              Error = " ",
              Warn = " ", 
              Info = " ",
              Hint = " ",
            }
            
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
          end
        '';

        # Apparence style LazyVim
        mode = "buffers";
        numbers = "none";

        indicator = {
          icon = "▎";
          style = "icon";
        };

        buffer_close_icon = "󰅖";
        modified_icon = "●";
        close_icon = "";
        left_trunc_marker = "";
        right_trunc_marker = "";

        max_name_length = 18;
        max_prefix_length = 15;
        truncate_names = true;
        tab_size = 18;

        color_icons = true;
        show_buffer_icons = true;
        show_buffer_close_icons = true;
        show_close_icon = true;
        show_tab_indicators = true;
        show_duplicate_prefix = true;
        persist_buffer_sort = true;

        separator_style = "slant";
        enforce_regular_tabs = false;
        always_show_bufferline = false;

        hover = {
          enabled = true;
          delay = 200;
          reveal = [ "close" ];
        };

        sort_by = "insert_after_current";

        # Offsets style LazyVim
        offsets = [
          {
            filetype = "neo-tree";
            text = "Neo-tree";
            highlight = "Directory";
            text_align = "left";
          }
          {
            filetype = "snacks_layout_box";
          }
        ];

        # Icônes personnalisées style LazyVim
        get_element_icon.__raw = ''
          function(opts)
            -- Utilisation des icônes standard ou personnalisées
            local icons = {
              nix = "󱄅",
              haskell = "󰲒",
              lua = "󰢱",
              python = "",
              javascript = "󰌞",
              typescript = "",
              json = "",
              yaml = "",
              markdown = "",
              rust = "",
              go = "",
              c = "",
              cpp = "",
              html = "",
              css = "",
              scss = "",
              vue = "",
              svelte = "",
              astro = "",
            }
            
            return icons[opts.filetype] or ""
          end
        '';
      };
    };
  };

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE LUA
  # =====================================================================

  extraConfigLua = ''
    -- Configuration bufferline style LazyVim
    vim.defer_fn(function()
      -- Fix bufferline when restoring a session (copié de LazyVim)
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(function()
              local bufferline = require("bufferline")
              bufferline.setup()
            end)
          end)
        end,
      })
    end, 100)
  '';
}
