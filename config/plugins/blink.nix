{
  plugins = {
    blink-cmp = {
      enable = true;

      settings = {
        # =====================================================================
        # KEYMAPS PERSONNALISÉS - Navigation avec TAB
        # =====================================================================
        keymap = {
          # Configuration manuelle des keymaps
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

          # Snippets
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
        # SOURCES DE COMPLÉTION
        # =====================================================================
        sources = {
          default = [ "lsp" "path" "snippets" "buffer" ];

          providers = {
            lsp = {
              name = "LSP";
              score_offset = 0;
              fallbacks = [ "snippets" "buffer" ]; # Fallback rapide si LSP lent

              # Optimisations pour LSP lents (comme nixd)
              opts = {
                max_results = 20; # Moins de résultats = plus rapide
                timeout_ms = 500; # Timeout court pour LSP lents
                show_autosnippets = false; # Désactiver pour la vitesse

                # Cache plus agressif
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
                max_results = 8; # Limité pour vitesse
                timeout_ms = 200; # Timeout court
              };
            };

            snippets = {
              name = "Snippets";
              score_offset = -1;
              fallbacks = [ ]; # Pas de fallback pour snippets
              opts = {
                friendly_snippets = true;
                search_paths = [ "~/.config/nixvim/snippets" ];
                global_snippets = [ "all" ];
                extended_filetypes = { };
                ignored_filetypes = [ ];
                max_results = 10; # Limité pour vitesse
              };
            };

            buffer = {
              name = "Buffer";
              score_offset = -3;
              fallbacks = [ ]; # Toujours disponible, pas de fallback
              opts = {
                get_bufnrs.__raw = "function() return vim.api.nvim_list_bufs() end";
                max_results = 12; # Limité pour vitesse
                min_keyword_length = 1; # Dès le premier caractère
              };
            };
          };

          # Configuration par filetype pour optimiser selon le LSP
          per_filetype = {
            # Nix: LSP lent, privilégier les alternatives
            nix = [ "snippets" "lsp" "buffer" "path" ]; # snippets en premier

            # Haskell: LSP rapide, on peut le privilégier  
            haskell = [ "lsp" "snippets" "buffer" ];
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
            auto_show_delay_ms = 50; # Réduit de 200ms à 50ms
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
        # SIGNATURE HELP RAPIDE
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
  # CONFIGURATION SUPPLÉMENTAIRE LUA
  # =====================================================================
  extraConfigLua = ''
    -- Configuration avancée de Blink avec optimisations LSP
    vim.defer_fn(function()
      local ok, blink = pcall(require, 'blink.cmp')
      if not ok then
        print("Blink not available yet, will retry...")
        return
      end
      
      -- Configuration de vitesse via API Lua (plus compatible)
      pcall(function()
        -- Essayer de configurer les délais via l'API si disponible
        if blink.config and blink.config.update then
          blink.config.update({
            completion = {
              documentation = {
                auto_show_delay_ms = 50,
              },
              trigger = {
                show_delay_ms = 0,
                hide_delay_ms = 50,
              }
            },
            signature = {
              enabled = true,
              trigger = {
                show_delay_ms = 50,
                hide_delay_ms = 1000,
              }
            }
          })
        end
      end)
      
      -- Optimisations spécifiques par LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then return end
          
          -- Configuration spécifique selon le LSP
          if client.name == "nixd" then
            -- nixd est lent, optimiser
            client.config.flags = client.config.flags or {}
            client.config.flags.debounce_text_changes = 300  -- Plus de debounce
            
            -- Pour nixd, privilégier d'autres sources au début
            pcall(function()
              if blink.setup then
                blink.setup({
                  sources = {
                    per_filetype = {
                      nix = { "buffer", "snippets", "lsp", "path" }  -- LSP en 3e position
                    }
                  }
                })
              end
            end)
            
          elseif client.name == "haskell-language-server" or client.name == "hls" then
            -- HLS est rapide, configuration standard
            client.config.flags = client.config.flags or {}
            client.config.flags.debounce_text_changes = 150  -- Moins de debounce
            
            
          elseif client.name:match("lua") then
            -- Lua LSP généralement rapide
            client.config.flags = client.config.flags or {}
            client.config.flags.debounce_text_changes = 150
            
          end
        end,
      })
      
      -- Configuration étendue des sources
      pcall(function()
        -- Buffer optimisé pour tous les filetypes
        local buffer_config = {
          get_bufnrs = function()
            local bufs = {}
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buftype") == "" then
                -- Filtrer les buffers trop grands (lents à traiter)
                local line_count = vim.api.nvim_buf_line_count(buf)
                if line_count < 5000 then  -- Ignorer les gros fichiers
                  table.insert(bufs, buf)
                end
              end
            end
            return bufs
          end,
          max_results = 12,
          min_keyword_length = 1,
        }
      end)
    end, 500)
  '';
}
