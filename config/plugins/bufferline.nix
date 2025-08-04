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
  # KEYMAPS BUFFERLINE - Style LazyVim exact
  # =====================================================================

  keymaps = [
    # Pin/Unpin buffer
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLineTogglePin<cr>";
      options.desc = "Toggle Pin";
    }

    # Fermer buffers non-pinned
    {
      mode = "n";
      key = "<leader>bP";
      action = "<cmd>BufferLineGroupClose ungrouped<cr>";
      options.desc = "Delete Non-Pinned Buffers";
    }

    # Fermer buffers à droite
    {
      mode = "n";
      key = "<leader>br";
      action = "<cmd>BufferLineCloseRight<cr>";
      options.desc = "Delete Buffers to the Right";
    }

    # Fermer buffers à gauche
    {
      mode = "n";
      key = "<leader>bl";
      action = "<cmd>BufferLineCloseLeft<cr>";
      options.desc = "Delete Buffers to the Left";
    }

    # Navigation avec Shift-h/l (adapté pour JKLM)
    # Note: Garde Shift-h/l pour bufferline même avec JKLM
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options.desc = "Prev Buffer";
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>BufferLineCycleNext<cr>";
      options.desc = "Next Buffer";
    }

    # Navigation alternative avec [ ]
    {
      mode = "n";
      key = "[b";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options.desc = "Prev Buffer";
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>BufferLineCycleNext<cr>";
      options.desc = "Next Buffer";
    }

    # Déplacer buffers
    {
      mode = "n";
      key = "[B";
      action = "<cmd>BufferLineMovePrev<cr>";
      options.desc = "Move buffer prev";
    }
    {
      mode = "n";
      key = "]B";
      action = "<cmd>BufferLineMoveNext<cr>";
      options.desc = "Move buffer next";
    }
  ];

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

      -- Couleurs personnalisées pour gruvbox
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "gruvbox*",
        callback = function()
          -- Couleurs bufferline adaptées pour gruvbox
          vim.api.nvim_set_hl(0, "BufferLineFill", { 
            bg = "#1d2021" 
          })
          vim.api.nvim_set_hl(0, "BufferLineBackground", { 
            fg = "#928374", 
            bg = "#32302f" 
          })
          vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { 
            fg = "#ebdbb2", 
            bg = "#3c3836",
            bold = true,
            italic = false
          })
          vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { 
            fg = "#a89984", 
            bg = "#32302f" 
          })
          
          -- Indicateurs
          vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", { 
            fg = "#83a598", 
            bg = "#3c3836" 
          })
          vim.api.nvim_set_hl(0, "BufferLineModified", { 
            fg = "#fabd2f", 
            bg = "#32302f" 
          })
          vim.api.nvim_set_hl(0, "BufferLineModifiedSelected", { 
            fg = "#fabd2f", 
            bg = "#3c3836" 
          })
          
          -- Diagnostics détaillés avec couleurs
          vim.api.nvim_set_hl(0, "BufferLineError", { 
            fg = "#fb4934", 
            bg = "#32302f" 
          })
          vim.api.nvim_set_hl(0, "BufferLineErrorSelected", { 
            fg = "#fb4934", 
            bg = "#3c3836" 
          })
          vim.api.nvim_set_hl(0, "BufferLineErrorDiagnostic", { 
            fg = "#fb4934", 
            bg = "#32302f",
            bold = true
          })
          vim.api.nvim_set_hl(0, "BufferLineErrorDiagnosticSelected", { 
            fg = "#fb4934", 
            bg = "#3c3836",
            bold = true
          })
          
          vim.api.nvim_set_hl(0, "BufferLineWarning", { 
            fg = "#fabd2f", 
            bg = "#32302f" 
          })
          vim.api.nvim_set_hl(0, "BufferLineWarningSelected", { 
            fg = "#fabd2f", 
            bg = "#3c3836" 
          })
          vim.api.nvim_set_hl(0, "BufferLineWarningDiagnostic", { 
            fg = "#fabd2f", 
            bg = "#32302f",
            bold = true
          })
          vim.api.nvim_set_hl(0, "BufferLineWarningDiagnosticSelected", { 
            fg = "#fabd2f", 
            bg = "#3c3836",
            bold = true
          })
          
          vim.api.nvim_set_hl(0, "BufferLineInfo", { 
            fg = "#83a598", 
            bg = "#32302f" 
          })
          vim.api.nvim_set_hl(0, "BufferLineInfoSelected", { 
            fg = "#83a598", 
            bg = "#3c3836" 
          })
          vim.api.nvim_set_hl(0, "BufferLineInfoDiagnostic", { 
            fg = "#83a598", 
            bg = "#32302f",
            bold = true
          })
          vim.api.nvim_set_hl(0, "BufferLineInfoDiagnosticSelected", { 
            fg = "#83a598", 
            bg = "#3c3836",
            bold = true
          })
          
          vim.api.nvim_set_hl(0, "BufferLineHint", { 
            fg = "#8ec07c", 
            bg = "#32302f" 
          })
          vim.api.nvim_set_hl(0, "BufferLineHintSelected", { 
            fg = "#8ec07c", 
            bg = "#3c3836" 
          })
          vim.api.nvim_set_hl(0, "BufferLineHintDiagnostic", { 
            fg = "#8ec07c", 
            bg = "#32302f",
            bold = true
          })
          vim.api.nvim_set_hl(0, "BufferLineHintDiagnosticSelected", { 
            fg = "#8ec07c", 
            bg = "#3c3836",
            bold = true
          })
          
          -- Séparateurs
          vim.api.nvim_set_hl(0, "BufferLineSeparator", { 
            fg = "#1d2021", 
            bg = "#32302f" 
          })
          vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { 
            fg = "#1d2021", 
            bg = "#3c3836" 
          })
          
          -- Tabs (pour les tabs si utilisées)
          vim.api.nvim_set_hl(0, "BufferLineTab", { 
            fg = "#928374", 
            bg = "#32302f" 
          })
          vim.api.nvim_set_hl(0, "BufferLineTabSelected", { 
            fg = "#ebdbb2", 
            bg = "#3c3836",
            bold = true
          })
          
          -- Close button
          vim.api.nvim_set_hl(0, "BufferLineCloseButton", { 
            fg = "#928374", 
            bg = "#32302f" 
          })
          vim.api.nvim_set_hl(0, "BufferLineCloseButtonSelected", { 
            fg = "#fb4934", 
            bg = "#3c3836" 
          })
          
          -- Pick (pour buffer pick)
          vim.api.nvim_set_hl(0, "BufferLinePick", { 
            fg = "#fb4934", 
            bg = "#32302f",
            bold = true
          })
          vim.api.nvim_set_hl(0, "BufferLinePickSelected", { 
            fg = "#fb4934", 
            bg = "#3c3836",
            bold = true
          })
        end,
      })

      -- Appliquer immédiatement
      vim.cmd("doautocmd ColorScheme")

      -- Intégration which-key pour les nouveaux keymaps
      vim.defer_fn(function()
        local ok, wk = pcall(require, "which-key")
        if ok then
          wk.add({
            { "<leader>b", group = "󰓩 Buffers" },
            { "<leader>bp", desc = "Toggle Pin", icon = "󰐃" },
            { "<leader>bP", desc = "Delete Non-Pinned", icon = "󰅖" },
            { "<leader>br", desc = "Delete Right", icon = "󰅂" },
            { "<leader>bl", desc = "Delete Left", icon = "󰅀" },
            
            -- Navigation
            { "[b", desc = "Prev Buffer", icon = "󰒮" },
            { "]b", desc = "Next Buffer", icon = "󰒭" },
            { "[B", desc = "Move Prev", icon = "󰁍" },
            { "]B", desc = "Move Next", icon = "󰁔" },
            { "<S-h>", desc = "Prev Buffer", icon = "󰒮" },
            { "<S-l>", desc = "Next Buffer", icon = "󰒭" },
          })
          print("Bufferline: which-key mappings added")
        end
      end, 200)

      print("Bufferline LazyVim-style configuration loaded")
    end, 100)

    -- Fonctions de debug et utilitaires
    _G.debug_bufferline = function()
      print("=== Bufferline Debug ===")
      
      local ok, bufferline = pcall(require, "bufferline")
      if ok then
        print("Bufferline loaded: ✓")
        
        -- Informations sur les buffers
        local buffers = vim.fn.filter(vim.fn.range(1, vim.fn.bufnr('$')), 'buflisted(v:val)')
        print("Buffers listed:", #buffers)
        
        -- Diagnostics dans les buffers
        for _, bufnr in ipairs(buffers) do
          local diagnostics = vim.diagnostic.get(bufnr)
          if #diagnostics > 0 then
            local name = vim.api.nvim_buf_get_name(bufnr)
            local filename = vim.fn.fnamemodify(name, ':t')
            print("  " .. filename .. ": " .. #diagnostics .. " diagnostics")
          end
        end
        
      else
        print("Bufferline not loaded: ✗")
      end
      
      print("Try Shift-h/l for navigation, <leader>bp for pinning")
    end

    -- Commandes personnalisées
    vim.api.nvim_create_user_command("BufferlineDebug", function()
      debug_bufferline()
    end, { desc = "Debug bufferline configuration" })

    vim.api.nvim_create_user_command("BufferlineDiagnostics", function()
      debug_bufferline_diagnostics()
    end, { desc = "Debug bufferline diagnostics display" })

    vim.api.nvim_create_user_command("ListBuffers", function()
      list_buffers()
    end, { desc = "List all buffers with their status" })
      
  '';
}
