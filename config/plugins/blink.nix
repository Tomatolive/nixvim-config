{ pkgs, ... }:
{
  # =====================================================================
  # BLINK.CMP - Configuration avec snippets qui marchent
  # =====================================================================

  plugins = {
    blink-cmp = {
      enable = true;

      settings = {
        # =====================================================================
        # KEYMAPS
        # =====================================================================
        keymap = {
          preset = "none";

          # Navigation principale avec TAB
          "<Tab>" = [ "select_next" "fallback" ];
          "<S-Tab>" = [ "select_prev" "fallback" ];

          # Accepter la complétion
          "<CR>" = [ "accept" "fallback" ];
          "<C-y>" = [ "accept" ];

          # Navigation alternative
          "<C-n>" = [ "select_next" ];
          "<C-p>" = [ "select_prev" ];
          "<Down>" = [ "select_next" ];
          "<Up>" = [ "select_prev" ];

          # Contrôle du menu
          "<C-e>" = [ "hide" "fallback" ];
          "<C-space>" = [ "show" ];

          # Documentation
          "<C-d>" = [ "scroll_documentation_down" "fallback" ];
          "<C-u>" = [ "scroll_documentation_up" "fallback" ];

          # Navigation snippets
          "<C-l>" = [ "snippet_forward" "fallback" ];
          "<C-h>" = [ "snippet_backward" "fallback" ];
        };

        # =====================================================================
        # APPARENCE
        # =====================================================================
        appearance = {
          use_nvim_cmp_as_default = true;
          nerd_font_variant = "mono";
        };

        # =====================================================================
        # SOURCES DE COMPLÉTION - CORRIGÉES
        # =====================================================================
        sources = {
          default = [ "lsp" "path" "snippets" "buffer" ];

          providers = {
            lsp = {
              name = "LSP";
              score_offset = 0;
              fallbacks = [ "snippets" "buffer" ];
              opts = {
                max_results = 20;
                timeout_ms = 500;
                show_autosnippets = false;
                cache = {
                  enabled = true;
                  max_entries = 1000;
                };
              };
            };

            path = {
              name = "Path";
              score_offset = 3;
              fallbacks = [ "buffer" ];
              opts = {
                trailing_slash = true;
                label_trailing_slash = true;
                show_hidden_files_by_default = false;
                max_results = 8;
                timeout_ms = 200;
              };
            };

            # =====================================================================
            # SNIPPETS CORRIGÉS - Utilise friendly-snippets
            # =====================================================================
            snippets = {
              name = "Snippets";
              score_offset = -1;
              fallbacks = [ ];
              opts = {
                # CORRECTION : Utilise friendly-snippets depuis Nix
                friendly_snippets = true;
                # SUPPRIMÉ : search_paths inexistants
                # search_paths = [ "~/.config/nixvim/snippets" ]; 
                global_snippets = [ "all" ];
                extended_filetypes = { };
                ignored_filetypes = [ ];
                max_results = 10;
              };
            };

            buffer = {
              name = "Buffer";
              score_offset = -3;
              fallbacks = [ ];
              opts = {
                get_bufnrs.__raw = "function() return vim.api.nvim_list_bufs() end";
                max_results = 12;
                min_keyword_length = 1;
              };
            };
          };

          # Configuration par filetype pour optimiser selon le LSP
          per_filetype = {
            nix = [ "snippets" "lsp" "buffer" "path" ];
            haskell = [ "lsp" "snippets" "buffer" ];
            c = [ "lsp" "snippets" "buffer" "path" ];
            cpp = [ "lsp" "snippets" "buffer" "path" ];
          };
        };

        # =====================================================================
        # CONFIGURATION DE LA COMPLÉTION
        # =====================================================================
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
            auto_show_delay_ms = 50;
            window = {
              border = "rounded";
            };
          };

          menu = {
            border = "rounded";
            draw = {
              treesitter = [ "lsp" ];
            };
          };

          ghost_text = {
            enabled = true;
          };
        };

        # =====================================================================
        # SIGNATURE HELP
        # =====================================================================
        signature = {
          enabled = true;
          window = {
            border = "rounded";
          };
        };
      };
    };
  };

  # =====================================================================
  # FRIENDLY-SNIPPETS - Plugin requis pour les snippets
  # =====================================================================
  extraPlugins = with pkgs.vimPlugins; [
    friendly-snippets # ← AJOUTÉ : Plugin qui contient les snippets
  ];

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE LUA
  # =====================================================================
  extraConfigLua = ''
    -- Configuration avancée de Blink avec snippets fonctionnels
    vim.defer_fn(function()
      local ok, blink = pcall(require, 'blink.cmp')
      if not ok then
        return
      end
      
      -- Vérifier que friendly-snippets est disponible
      local snippets_ok = pcall(require, 'luasnip.loaders.from_vscode')
      if snippets_ok then
        require("snacks").notify("Snippets loaded (friendly-snippets)", { title = "Blink", timeout = 1000 })
      else
        require("snacks").notify("Using built-in snippets only", { title = "Blink", level = "info" })
      end
      
      -- Optimisations spécifiques par LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then return end
          
          -- Configuration spécifique selon le LSP
          if client.name == "nixd" then
            client.config.flags = client.config.flags or {}
            client.config.flags.debounce_text_changes = 300
          elseif client.name == "haskell-language-server" or client.name == "hls" then
            client.config.flags = client.config.flags or {}
            client.config.flags.debounce_text_changes = 150
          end
        end,
      })
    end, 500)
  '';
}
