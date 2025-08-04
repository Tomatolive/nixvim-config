{
  # =====================================================================
  # NOICE.NVIM - Style LazyVim avec popup moderne
  # =====================================================================

  plugins.noice = {
    enable = true;

    settings = {
      # =====================================================================
      # PRESETS LAZYVIM - Configurations exactes LazyVim
      # =====================================================================
      presets = {
        bottom_search = true; # Recherche en bas comme LazyVim
        command_palette = true; # Palette de commandes moderne
        long_message_to_split = true; # Messages longs dans un split
        inc_rename = false; # Pas d'inc-rename (on utilise LSP standard)
        lsp_doc_border = false; # Pas de bordures pour docs LSP (comme LazyVim)
      };

      # =====================================================================
      # CMDLINE - Popup de commande exactement comme LazyVim
      # =====================================================================
      cmdline = {
        enabled = true;
        view = "cmdline_popup"; # Vue popup au lieu de cmdline normale
      };

      # =====================================================================
      # MESSAGES - Style LazyVim exact
      # =====================================================================
      messages = {
        enabled = true;
        view = "notify"; # Utilise les notifications
        view_error = "notify";
        view_warn = "notify";
        view_history = "messages";
        view_search = "virtualtext"; # Recherche en virtual text
      };

      # =====================================================================
      # POPUPMENU - Menu d'autocomplétion LazyVim
      # =====================================================================
      popupmenu = {
        enabled = true;
        backend = "nui"; # Backend moderne
      };

      # =====================================================================
      # NOTIFICATIONS - Désactivées (utilise snacks.notifier)
      # =====================================================================
      notify = {
        enabled = false; # Snacks gère les notifications
      };

      # =====================================================================
      # LSP - Configuration LazyVim exacte
      # =====================================================================
      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };

        hover = {
          enabled = true;
          silent = true;
        };

        signature = {
          enabled = true;
          auto_open = {
            enabled = true;
            trigger = true;
            luasnip = true;
            throttle = 50;
          };
        };

        progress = {
          enabled = true;
          format = "lsp_progress";
          format_done = "lsp_progress_done";
          throttle.__raw = "1000 / 30";
          view = "mini";
        };

        message = {
          enabled = true;
          view = "notify";
        };

        documentation = {
          view = "hover";
          opts = {
            lang = "markdown";
            replace = true;
            render = "plain";
            format = [ "{message}" ];
            win_options = {
              concealcursor = "n";
              conceallevel = 3;
            };
          };
        };
      };

      # =====================================================================
      # VUES PERSONNALISÉES - Style LazyVim exact
      # =====================================================================
      views = {
        # Popup de commande - style LazyVim exact
        cmdline_popup = {
          size = {
            width = 60;
            height = "auto";
          };
          border = {
            style = "rounded";
            padding = [ 0 1 ];
          };
          filter_options = { };
          win_options = {
            winhighlight = "Normal:NoiceCmdlinePopup,FloatBorder:NoiceCmdlinePopupBorder,FloatTitle:NoiceCmdlinePopupTitle,CursorLine:PmenuSel,Search:None";
          };
        };

        # Input pour les prompts - style LazyVim
        cmdline_input = {
          position = {
            row = 5;
            col = "50%";
          };
          size = {
            width = 60;
            height = "auto";
          };
          border = {
            style = "rounded";
            padding = [ 0 1 ];
          };
          win_options = {
            winhighlight = "Normal:NoiceCmdlinePopup,FloatBorder:NoiceCmdlinePopupBorder,FloatTitle:NoiceCmdlinePopupTitle";
          };
        };

        # Menu popup pour l'autocomplétion
        popupmenu = {
          relative = "editor";
          position = {
            row = 8;
            col = "50%";
          };
          size = {
            width = 60;
            height = 10;
          };
          border = {
            style = "rounded";
            padding = [ 0 1 ];
          };
          win_options = {
            winhighlight = "Normal:NoicePopupmenu,FloatBorder:NoicePopupmenuBorder";
          };
        };

        # Documentation hover
        hover = {
          border = {
            style = "rounded";
            padding = [ 0 1 ];
          };
          position = { row = 2; col = 2; };
          size = {
            max_width = 120;
            max_height = 25;
          };
          win_options = {
            winhighlight = "Normal:NoiceHover,FloatBorder:NoiceHoverBorder";
          };
        };

        # Fenêtre de confirmation
        confirm = {
          border = {
            style = "rounded";
            padding = [ 0 1 ];
          };
          position = {
            row = "50%";
            col = "50%";
          };
          size = {
            width = "auto";
            height = "auto";
          };
          win_options = {
            winhighlight = "Normal:NoiceConfirm,FloatBorder:NoiceConfirmBorder";
          };
        };

        # Messages en mini format
        mini = {
          backend = "mini";
          relative = "editor";
          align = "message-right";
          timeout = 2000;
          reverse = true;
          focusable = false;
          position = {
            row = -1;
            col = "100%";
            max_width = 60;
          };
          size = "auto";
          border = {
            style = "none";
          };
          win_options = {
            winblend = 30;
            winhighlight = "Normal:NoiceMini";
          };
        };

        # Split pour les longs messages
        split = {
          backend = "split";
          enter = true;
          relative = "editor";
          position = "bottom";
          size = "20%";
          win_options = {
            winhighlight = "Normal:NoiceSplit,FloatBorder:NoiceSplitBorder";
          };
        };

        # Vue pour les messages d'erreur
        vsplit = {
          backend = "split";
          enter = true;
          relative = "editor";
          position = "right";
          size = "50%";
        };
      };

      # =====================================================================
      # ROUTES - Filtrage et routage des messages LazyVim
      # =====================================================================
      routes = [
        # Filtrer les messages de sauvegarde
        {
          filter = {
            event = "msg_show";
            any = [
              { find = "%d+L, %d+B"; }
              { find = "; after #%d+"; }
              { find = "; before #%d+"; }
              { find = "%d fewer lines"; }
              { find = "%d more lines"; }
            ];
          };
          view = "mini";
        }

        # Rediriger les messages "written" vers mini
        {
          filter = {
            event = "msg_show";
            find = "written";
          };
          view = "mini";
        }

        # Rediriger les messages de recherche
        {
          filter = {
            event = "msg_show";
            find = "search hit BOTTOM";
          };
          view = "mini";
        }
        {
          filter = {
            event = "msg_show";
            find = "search hit TOP";
          };
          view = "mini";
        }

        # Filtrer les messages spam de certains plugins
        {
          filter = {
            event = "notify";
            find = "No information available";
          };
          opts = { skip = true; };
        }

        # Messages d'erreur vers split si trop longs
        {
          filter = {
            event = "msg_show";
            min_height = 5;
          };
          view = "split";
        }

        # Progress LSP vers mini
        {
          filter = {
            event = "lsp";
            kind = "progress";
          };
          opts = {
            replace = true;
            merge = true;
          };
        }
      ];

      # =====================================================================
      # THROTTLE ET OPTIMISATIONS
      # =====================================================================
      throttle = 50;

      # =====================================================================
      # SMART MOVE - Éviter les overlaps
      # =====================================================================
      smart_move = {
        enabled = true;
        excluded_filetypes = [ "cmp_menu" "cmp_docs" "notify" ];
      };

      # =====================================================================
      # SANITY CHECK
      # =====================================================================
      health = {
        checker = false; # Désactiver pour performance
      };

      # =====================================================================
      # FORMAT POUR LSP PROGRESS
      # =====================================================================
      format = {
        lsp_progress = {
          lenght = {
            __unkeyed-1 = 40;
            __unkeyed-2 = 0.4;
          };
          text.__raw = ''
            function(message)
              local content = {}
              if message.progress then
                table.insert(content, message.progress.percentage and (message.progress.percentage .. "%%") or "")
                if message.progress.title then
                  table.insert(content, message.progress.title)
                end
                if message.progress.message then
                  table.insert(content, message.progress.message)
                end
              end
              if message.lsp_server then
                table.insert(content, "[" .. message.lsp_server.name .. "]")
              end
              return table.concat(content, " ")
            end
          '';
        };

        lsp_progress_done = {
          lenght = {
            __unkeyed-1 = 40;
            __unkeyed-2 = 0.4;
          };
          text.__raw = ''
            function(message)
              local content = { "✓" }
              if message.lsp_server then
                table.insert(content, "[" .. message.lsp_server.name .. "]")
              end
              if message.progress and message.progress.title then
                table.insert(content, message.progress.title)
              end
              return table.concat(content, " ")
            end
          '';
        };
      };
    };
  };

  # =====================================================================
  # NUI.NVIM - Requis pour noice
  # =====================================================================
  plugins.nui = {
    enable = true;
  };

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE LUA
  # =====================================================================
  extraConfigLua = ''
    -- ===================================================================
    -- HIGHLIGHTS PERSONNALISÉS POUR NOICE STYLE LAZYVIM
    -- ===================================================================
    
    -- vim.api.nvim_create_autocmd("ColorScheme", {
    --   pattern = "*",
    --   callback = function()
    --     -- Popup de commande - couleurs exactes LazyVim
    --     vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { 
    --       bg = "#3c3836", 
    --       fg = "#ebdbb2" 
    --     })
    --     vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { 
    --       fg = "#fabd2f", 
    --       bg = "NONE" 
    --     })
    --     vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { 
    --       fg = "#fabd2f", 
    --       bg = "NONE", 
    --       bold = true 
    --     })
    --
    --     -- Icon et prompt dans la cmdline
    --     vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { 
    --       fg = "#83a598" 
    --     })
    --
    --     -- Menu popup (autocomplétion)
    --     vim.api.nvim_set_hl(0, "NoicePopupmenu", { 
    --       bg = "#3c3836", 
    --       fg = "#ebdbb2" 
    --     })
    --     vim.api.nvim_set_hl(0, "NoicePopupmenuBorder", { 
    --       fg = "#fabd2f", 
    --       bg = "NONE" 
    --     })
    --     vim.api.nvim_set_hl(0, "NoicePopupmenuSelected", { 
    --       bg = "#504945", 
    --       fg = "#ebdbb2", 
    --       bold = true 
    --     })
    --
    --     -- Documentation hover
    --     vim.api.nvim_set_hl(0, "NoiceHover", { 
    --       bg = "#3c3836", 
    --       fg = "#ebdbb2" 
    --     })
    --     vim.api.nvim_set_hl(0, "NoiceHoverBorder", { 
    --       fg = "#83a598", 
    --       bg = "NONE" 
    --     })
    --
    --     -- Confirmation
    --     vim.api.nvim_set_hl(0, "NoiceConfirm", { 
    --       bg = "#3c3836", 
    --       fg = "#ebdbb2" 
    --     })
    --     vim.api.nvim_set_hl(0, "NoiceConfirmBorder", { 
    --       fg = "#fabd2f", 
    --       bg = "NONE" 
    --     })
    --
    --     -- Mini messages - style LazyVim
    --     vim.api.nvim_set_hl(0, "NoiceMini", { 
    --       bg = "NONE", 
    --       fg = "#928374" 
    --     })
    --
    --     -- Split pour longs messages
    --     vim.api.nvim_set_hl(0, "NoiceSplit", { 
    --       bg = "#282828", 
    --       fg = "#ebdbb2" 
    --     })
    --     vim.api.nvim_set_hl(0, "NoiceSplitBorder", { 
    --       fg = "#fabd2f", 
    --       bg = "NONE" 
    --     })
    --
    --     -- Messages formatés
    --     vim.api.nvim_set_hl(0, "NoiceFormatProgressTodo", { 
    --       fg = "#928374" 
    --     })
    --     vim.api.nvim_set_hl(0, "NoiceFormatProgressDone", { 
    --       fg = "#b8bb26" 
    --     })
    --
    --     -- LSP progress
    --     vim.api.nvim_set_hl(0, "NoiceLspProgressTitle", { 
    --       fg = "#83a598" 
    --     })
    --     vim.api.nvim_set_hl(0, "NoiceLspProgressClient", { 
    --       fg = "#d3869b" 
    --     })
    --     vim.api.nvim_set_hl(0, "NoiceLspProgressSpinner", { 
    --       fg = "#fabd2f" 
    --     })
    --   end,
    -- })
    
    -- Appliquer immédiatement si gruvbox est déjà chargé
    vim.defer_fn(function()
      vim.cmd("doautocmd ColorScheme")
    end, 100)
    
    -- ===================================================================
    -- INTÉGRATIONS PERSONNALISÉES
    -- ===================================================================
    
    -- Intégration avec telescope si disponible
    local ok, telescope = pcall(require, "telescope")
    if ok then
      telescope.load_extension("noice")
    end
    
    -- Fonction pour ouvrir l'historique des messages
    vim.keymap.set("n", "<leader>snh", "<cmd>Noice telescope<cr>", { 
      desc = "Noice Message History" 
    })
    
    -- Fonction pour voir les stats Noice
    vim.keymap.set("n", "<leader>sns", "<cmd>Noice stats<cr>", { 
      desc = "Noice Stats" 
    })
    
    -- Fonction pour déboguer Noice
    _G.debug_noice = function()
      print("=== Noice Debug ===")
      
      local ok, noice = pcall(require, "noice")
      if ok then
        print("Noice loaded: ✓")
        
        -- Stats
        local stats = noice.stats()
        print("Messages processed:", stats.messages or 0)
        print("Views active:", stats.views or 0)
        
        -- Configuration active
        local config = noice.config
        print("Cmdline enabled:", config.cmdline.enabled)
        print("Messages enabled:", config.messages.enabled)
        print("Popupmenu enabled:", config.popupmenu.enabled)
        
      else
        print("Noice not loaded: ✗")
      end
      
      print("Try :Noice to see current status")
    end
    
    -- ===================================================================
    -- COMMANDES PERSONNALISÉES
    -- ===================================================================
    
    vim.api.nvim_create_user_command("NoiceDebug", function()
      debug_noice()
    end, { desc = "Debug Noice configuration" })
    
    vim.api.nvim_create_user_command("NoiceToggle", function()
      vim.cmd("Noice disable")
      vim.defer_fn(function()
        vim.cmd("Noice enable")
        print("Noice reloaded")
      end, 100)
    end, { desc = "Toggle Noice on/off" })
    
    print("Noice LazyVim-style configuration loaded")
  '';
}
