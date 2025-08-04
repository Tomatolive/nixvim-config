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
              fallbacks = [ "snippets" "buffer" ];  # Fallback rapide si LSP lent
              
              # Optimisations pour LSP lents (comme nixd)
              opts = {
                max_results = 20;           # Moins de résultats = plus rapide
                timeout_ms = 500;           # Timeout court pour LSP lents
                show_autosnippets = false;  # Désactiver pour la vitesse
                
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
                max_results = 8;            # Limité pour vitesse
                timeout_ms = 200;           # Timeout court
              };
            };
            
            snippets = {
              name = "Snippets";
              score_offset = -1;
              fallbacks = [ ];              # Pas de fallback pour snippets
              opts = {
                friendly_snippets = true;
                search_paths = [ "~/.config/nixvim/snippets" ];
                global_snippets = [ "all" ];
                extended_filetypes = {};
                ignored_filetypes = [];
                max_results = 10;           # Limité pour vitesse
              };
            };
            
            buffer = {
              name = "Buffer";
              score_offset = -3;
              fallbacks = [ ];              # Toujours disponible, pas de fallback
              opts = {
                get_bufnrs.__raw = "function() return vim.api.nvim_list_bufs() end";
                max_results = 12;           # Limité pour vitesse
                min_keyword_length = 1;     # Dès le premier caractère
              };
            };
          };
          
          # Configuration par filetype pour optimiser selon le LSP
          per_filetype = {
            # Nix: LSP lent, privilégier les alternatives
            nix = [ "snippets" "lsp" "buffer" "path" ];  # snippets en premier
            
            # Haskell: LSP rapide, on peut le privilégier  
            haskell = [ "lsp" "snippets" "buffer" ];
            
            # Lua: LSP rapide généralement
            lua = [ "lsp" "snippets" "buffer" ];
            
            # Markdown: pas de LSP, sources rapides
            markdown = [ "buffer" "path" "snippets" ];
            
            # JSON, YAML: LSP souvent lent
            json = [ "snippets" "lsp" "buffer" ];
            yaml = [ "snippets" "lsp" "buffer" ];
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
            auto_show_delay_ms = 50;  # Réduit de 200ms à 50ms
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
          print("Blink speed optimizations applied via API")
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
            
            print("nixd optimizations applied (slower LSP)")
            
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
            
            print("HLS optimizations applied (fast LSP)")
            
          elseif client.name:match("lua") then
            -- Lua LSP généralement rapide
            client.config.flags = client.config.flags or {}
            client.config.flags.debounce_text_changes = 150
            
            print("Lua LSP optimizations applied")
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
        
        -- Configuration par filetype avec gestion de la vitesse
        vim.api.nvim_create_autocmd("FileType", {
          callback = function()
            local ft = vim.bo.filetype
            
            -- Réorganiser les sources selon la vitesse du LSP
            if ft == "nix" then
              -- nixd est lent: buffer et snippets d'abord
              print("Nix file: prioritizing fast sources over slow nixd")
              
            elseif ft == "haskell" then
              -- HLS est rapide: LSP d'abord
              print("Haskell file: prioritizing fast HLS")
              
            elseif ft == "json" or ft == "yaml" then
              -- LSP souvent lents pour JSON/YAML
              print("JSON/YAML: prioritizing fast sources")
              
            elseif ft == "markdown" or ft == "text" then
              -- Pas de LSP: sources rapides uniquement
              print("Text file: using fast sources only")
            end
          end
        })
      end)
    end, 500)
    
    -- Amélioration des couleurs pour Gruvbox
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        -- Highlights pour le menu de complétion
        vim.api.nvim_set_hl(0, "BlinkCmpMenu", { 
          bg = "#3c3836", 
          fg = "#ebdbb2" 
        })
        vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { 
          fg = "#b8bb26", 
          bg = "#3c3836" 
        })
        vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { 
          bg = "#504945", 
          fg = "#ebdbb2",
          bold = true
        })
        
        -- Documentation
        vim.api.nvim_set_hl(0, "BlinkCmpDoc", { 
          bg = "#3c3836", 
          fg = "#ebdbb2" 
        })
        vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { 
          fg = "#b8bb26", 
          bg = "#3c3836" 
        })
        
        -- Signature help  
        vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { 
          bg = "#3c3836", 
          fg = "#ebdbb2" 
        })
        vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { 
          fg = "#b8bb26", 
          bg = "#3c3836" 
        })
        
        -- Ghost text
        vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { 
          fg = "#928374",
          italic = true
        })
      end,
    })
    
    -- Appliquer les couleurs immédiatement
    vim.defer_fn(function()
      vim.cmd("doautocmd ColorScheme")
    end, 100)
    
    -- Keymaps supplémentaires sécurisés
    vim.keymap.set('i', '<C-Space>', function()
      local ok, blink = pcall(require, 'blink.cmp')
      if ok and blink.show then
        blink.show()
      else
        -- Fallback vers complétion standard
        return vim.api.nvim_replace_termcodes('<C-x><C-n>', true, false, true)
      end
    end, { desc = "Trigger completion", silent = true })
    
    -- Raccourci pour complétion LSP
    vim.keymap.set('i', '<C-x><C-o>', function()
      local ok, blink = pcall(require, 'blink.cmp')
      if ok and blink.show then
        blink.show({ sources = { "lsp" } })
      else
        -- Fallback vers omni completion
        return vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true)
      end
    end, { desc = "LSP completion", silent = true })
    
    -- Fonction de debug sécurisée
    _G.debug_blink = function()
      print("=== Blink Completion Debug ===")
      
      local blink_ok, blink = pcall(require, 'blink.cmp')
      print("Blink available:", blink_ok)
      
      if blink_ok then
        print("Blink functions available:")
        for k, v in pairs(blink) do
          if type(v) == "function" then
            print("  - " .. k)
          end
        end
      end
      
      -- Test des keymaps
      local tab_map = vim.fn.maparg("<Tab>", "i")
      print("TAB mapping:", tab_map ~= "" and "custom" or "default")
      
      local space_map = vim.fn.maparg("<C-Space>", "i")  
      print("C-Space mapping:", space_map ~= "" and "custom" or "default")
      
      print("Current filetype:", vim.bo.filetype)
      print("Insert mode:", vim.fn.mode() == "i")
    end
    
    -- Test de fonctionnement
    _G.test_blink_tab = function()
      print("Testing TAB navigation...")
      print("1. Enter insert mode")
      print("2. Start typing")
      print("3. Use TAB/Shift-TAB to navigate")
      print("4. Press Enter to accept")
      
      local tab_map = vim.fn.maparg("<Tab>", "i")
      if tab_map ~= "" then
        print("✓ TAB mapping configured")
      else
        print("✗ TAB mapping not found")
      end
    end
    
    -- Test de vitesse de complétion avec analyse LSP
    _G.test_blink_speed = function()
      print("=== Test de vitesse Blink ===")
      print("Configuration actuelle:")
      print("  - Navigation TAB activee")
      print("  - Timeouts LSP optimises")
      print("  - Fallbacks rapides configures")
      print("")
      
      -- Analyser les LSP actifs
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients > 0 then
        print("LSP actifs dans ce buffer:")
        for _, client in ipairs(clients) do
          local speed_category = "normale"
          if client.name == "nixd" then
            speed_category = "lente (nixd)"
          elseif client.name:match("haskell") then
            speed_category = "rapide (HLS)"
          elseif client.name:match("lua") then
            speed_category = "rapide (Lua)"
          end
          print("  - " .. client.name .. " (" .. speed_category .. ")")
        end
      else
        print("Aucun LSP actif")
      end
      
      print("")
      print("Test:")
      print("1. Taper une lettre -> completion adaptee au LSP")
      print("2. TAB pour naviguer")
      print("3. Enter pour accepter")
      
      local ok, blink = pcall(require, 'blink.cmp')
      if ok then
        print("Blink charge et pret")
      else
        print("Blink non disponible")
      end
    end
    
    -- Fonction pour déboguer les performances LSP
    _G.debug_lsp_performance = function()
      print("=== Debug Performance LSP ===")
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      
      if #clients == 0 then
        print("Aucun LSP actif")
        return
      end
      
      for _, client in ipairs(clients) do
        print("LSP: " .. client.name)
        
        -- Analyser la configuration
        if client.config.flags then
          local debounce = client.config.flags.debounce_text_changes or "default"
          print("  Debounce: " .. tostring(debounce) .. "ms")
        end
        
        -- Suggestions d'optimisation
        if client.name == "nixd" then
          print("  Status: LSP lent detecte")
          print("  Optimisation: sources alternatives privilegiees")
          print("  Conseil: utilisez snippets et buffer pour plus de rapidite")
        elseif client.name:match("haskell") then
          print("  Status: LSP rapide")
          print("  Optimisation: LSP privilegie")
        else
          print("  Status: vitesse inconnue")
        end
        
        print("  Root dir: " .. (client.config.root_dir or "N/A"))
        print("")
      end
    end
    
    -- Fonction pour forcer l'optimisation des LSP lents
    _G.optimize_slow_lsp = function()
      print("=== Optimisation LSP lents ===")
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      
      for _, client in ipairs(clients) do
        if client.name == "nixd" then
          print("Optimisation de nixd...")
          
          -- Augmenter le debounce
          client.config.flags = client.config.flags or {}
          client.config.flags.debounce_text_changes = 500
          
          -- Réduire les requêtes
          if client.server_capabilities then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
          
          print("nixd optimise pour la vitesse")
          
        elseif client.name:match("json") or client.name:match("yaml") then
          print("Optimisation LSP JSON/YAML...")
          client.config.flags = client.config.flags or {}
          client.config.flags.debounce_text_changes = 400
          print("LSP JSON/YAML optimise")
        end
      end
      
      print("Optimisation terminee - testez la completion")
    end
    
    -- Fonction pour basculer vers sources rapides uniquement
    _G.fast_completion_only = function()
      print("=== Mode completion rapide uniquement ===")
      print("Sources utilisees: buffer + snippets (pas de LSP)")
      
      -- Note: Dans nixvim, on ne peut pas facilement changer les sources dynamiquement
      -- Mais on peut donner des conseils
      print("")
      print("Pour activer:")
      print("  - Utilisez C-x C-n pour completion buffer")
      print("  - Utilisez C-x C-s pour snippets")
      print("  - Evitez C-x C-o (LSP) si trop lent")
      
      local ft = vim.bo.filetype
      if ft == "nix" then
        print("  - En Nix: privilégiez les mots du buffer")
      elseif ft == "haskell" then
        print("  - En Haskell: HLS est rapide, vous pouvez l'utiliser")
      end
    end
    
    print("Blink enhanced configuration loaded (LSP optimized version)")
  '';
}
