{
  plugins = {
    blink-cmp = {
      enable = true;
      
      settings = {
        # Keymaps - utilise le preset par défaut (Tab/S-Tab pour naviguer, Enter pour accepter)
        keymap = {
          preset = "default";
          # Keymaps personnalisées (optionnel)
          # ["<C-space>"] = [ "show" "show_documentation" "hide_documentation" ];
          # ["<C-e>"] = [ "hide" "fallback" ];
        };
        
        # Apparence et interface
        appearance = {
          use_nvim_cmp_as_default = true;
          nerd_font_variant = "mono";  # "normal" ou "mono"
        };
        
        # Sources de complétion
        sources = {
          default = [ "lsp" "path" "snippets" "buffer" ];
          
          # Configuration des providers
          providers = {
            lsp = {
              name = "LSP";
              score_offset = 0;
              fallbacks = [];
            };
            path = {
              score_offset = 3;
              fallbacks = [ "buffer" ];
              opts = {
                trailing_slash = true;
                label_trailing_slash = true;
                show_hidden_files_by_default = false;
              };
            };
            snippets = {
              score_offset = -1;
              opts = {
                friendly_snippets = true;
                search_paths = [ "~/.config/nixvim/snippets" ];
                global_snippets = [ "all" ];
                extended_filetypes = {};
                ignored_filetypes = {};
              };
            };
            buffer = {
              score_offset = -3;
              opts = {
                max_items = 20;
                get_bufnrs.__raw = "function() return vim.api.nvim_list_bufs() end";
              };
            };
          };
        };
        
        # Configuration de la complétion
        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
              default_brackets = [ "(" ")" ];
            };
            create_undo_point = true;
          };
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 200;
          };
          menu = {
            border = "rounded";
            draw = {
              treesitter = [ "lsp" ];
            };
          };
        };
        
        # Signature help
        signature = {
          enabled = true;
          window = {
            border = "rounded";
          };
        };
      };
    };
  };
}
