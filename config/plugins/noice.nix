{
  # =====================================================================
  # NOICE.NVIM - Interface utilisateur moderne pour Neovim
  # =====================================================================
  
  plugins.noice = {
    enable = true;
    
    settings = {
      # ===================================================================
      # CONFIGURATION DES COMMANDES (cmdline)
      # ===================================================================
      cmdline = {
        enabled = true;
        view = "cmdline_popup";  # ou "cmdline" pour style classique
        
        # Configuration des icônes pour les commandes
        format = {
          cmdline = { 
            pattern = "^:"; 
            icon = " "; 
            lang = "vim"; 
          };
          search_down = { 
            kind = "search"; 
            pattern = "^/"; 
            icon = " "; 
            lang = "regex"; 
          };
          search_up = { 
            kind = "search"; 
            pattern = "^%?"; 
            icon = " "; 
            lang = "regex"; 
          };
          filter = { 
            pattern = "^:%s*!"; 
            icon = " "; 
            lang = "bash"; 
          };
          lua = { 
            pattern = "^:%s*lua%s+"; 
            icon = " "; 
            lang = "lua"; 
          };
          help = { 
            pattern = "^:%s*he?l?p?%s+"; 
            icon = " "; 
          };
          input = { 
            view = "cmdline_input"; 
            icon = "󰥻 "; 
          };
        };
      };
      
      # ===================================================================
      # CONFIGURATION DES MESSAGES
      # ===================================================================
      messages = {
        enabled = true;
        view = "notify";           # Utilise les notifications
        view_error = "notify";     # Erreurs en notifications
        view_warn = "notify";      # Warnings en notifications
        view_history = "messages"; # Historique dans :messages
        view_search = "virtualtext"; # Résultats de recherche en texte virtuel
      };
      
      # ===================================================================
      # CONFIGURATION DU MENU POPUP (autocomplétion)
      # ===================================================================
      popupmenu = {
        enabled = true;
        backend = "nui";  # Utilise nui.nvim pour l'affichage
        
        # Configuration de l'apparence
        kind_icons = {
          # Icônes pour les types d'autocomplétion
          Text = " ";
          Method = "󰆧 ";
          Function = "󰊕 ";
          Constructor = " ";
          Field = "󰇽 ";
          Variable = "󰂡 ";
          Class = "󰠱 ";
          Interface = " ";
          Module = " ";
          Property = "󰜢 ";
          Unit = " ";
          Value = "󰎠 ";
          Enum = " ";
          Keyword = "󰌋 ";
          Snippet = " ";
          Color = "󰏘 ";
          File = "󰈙 ";
          Reference = " ";
          Folder = "󰉋 ";
          EnumMember = " ";
          Constant = "󰏿 ";
          Struct = " ";
          Event = " ";
          Operator = "󰆕 ";
          TypeParameter = "󰅲 ";
        };
      };
      
      # ===================================================================
      # CONFIGURATION DES NOTIFICATIONS (intégration avec snacks)
      # ===================================================================
      notify = {
        enabled = false;  # Désactivé car on utilise snacks.notifier
      };
      
      # ===================================================================
      # CONFIGURATION LSP
      # ===================================================================
      lsp = {
        # Remplace les popups LSP par défaut
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        
        # Configuration de la documentation hover
        hover = {
          enabled = true;
          silent = true;
        };
        
        # Configuration des signatures
        signature = {
          enabled = true;
          auto_open = {
            enabled = true;
            trigger = true;
            luasnip = true;
            throttle = 50;
          };
        };
        
        # Messages de progression LSP
        progress = {
          enabled = true;
          format = "lsp_progress";
          format_done = "lsp_progress_done";
          throttle.__raw = "1000 / 30"; # max 30 messages par seconde
          view = "mini";
        };
        
        # Documentation
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
      
      # ===================================================================
      # PRESETS - Configurations prédéfinies
      # ===================================================================
      presets = {
        bottom_search = true;         # Search count dans le coin
        command_palette = true;       # Command palette style VSCode
        long_message_to_split = true; # Messages longs en split
        inc_rename = false;           # Désactivé si vous n'utilisez pas inc-rename
        lsp_doc_border = false;       # Bordures pour la doc LSP
      };
      
      # ===================================================================
      # CONFIGURATION DES VUES
      # ===================================================================
      views = {
        # Popup pour cmdline
        cmdline_popup = {
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
          filter_options = {};
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder";
          };
        };
        
        # Popup pour les menus
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
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder";
          };
        };
        
        # Vue pour les confirmations
        confirm = {
          backend = "popup";
          relative = "editor";
          position = {
            row = "50%";
            col = "50%";
          };
          size = "auto";
          border = {
            style = "rounded";
            padding = [ 0 1 ];
            text = {
              top = " Confirm ";
            };
          };
          focus_on_open = true;
        };
        
        # Vue pour les messages d'erreur
        split = {
          backend = "split";
          enter = true;
          relative = "editor";
          position = "bottom";
          size = "20%";
          close = {
            keys = [ "q" ];
          };
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder";
          };
        };
        
        # Vue pour hover
        hover = {
          border = {
            style = "rounded";
            padding = [ 0 1 ];
          };
          position = { row = 2; col = 2; };
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder";
          };
        };
        
        # Mini vue pour les messages courts
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
            # col = 0 pour alignement à gauche
          };
          size = "auto";
          border = {
            style = "none";
          };
          win_options = {
            winblend = 30;
          };
        };
      };
      
      # ===================================================================
      # CONFIGURATION DES ROUTES
      # ===================================================================
      routes = [
        # Rediriger les messages de sauvegarde vers mini
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
        
        # Rediriger les messages d'erreur vers une vue séparée
        {
          filter = {
            event = "msg_show";
            kind = "error";
          };
          view = "notify";
          opts = {
            title = "Error";
            level = "error";
            merge = false;
            replace = false;
          };
        }
        
        # Rediriger les warnings vers notifications
        {
          filter = {
            event = "msg_show";
            kind = "warn";
          };
          view = "notify";
          opts = {
            title = "Warning";
            level = "warn";
            merge = false;
            replace = false;
          };
        }
        
        # Messages de recherche en bas
        {
          filter = {
            event = "msg_show";
            kind = "search_count";
          };
          opts = {
            skip = true;
          };
        }
        
        # Cacher les messages "written"
        {
          filter = {
            event = "msg_show";
            find = "written";
          };
          opts = {
            skip = true;
          };
        }
        
        # Cacher certains messages LSP verbeux
        {
          filter = {
            event = "lsp";
            kind = "progress";
            cond.__raw = ''
              function(message)
                local client = vim.tbl_get(message.opts, "progress", "client")
                return client == "ltex"
              end
            '';
          };
          opts = { skip = true; };
        }
      ];
      
      # ===================================================================
      # CONFIGURATION DU FORMATAGE
      # ===================================================================
      format = {
        level = {
          icons = {
            error = "✖";
            warn = "▼";
            info = "●";
            debug = "◆";
            trace = "■";
          };
        };
        
        # Format pour la progression LSP
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
        
        # Format pour la progression LSP terminée
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
      
      # ===================================================================
      # CONFIGURATION DE SANTÉ/DEBUG
      # ===================================================================
      health = {
        checker = false; # Désactiver le checker automatique
      };
      
      # Smart move pour éviter de montrer certains messages
      smart_move = {
        enabled = true;
        excluded_filetypes = [ "cmp_menu" "cmp_docs" "notify" ];
      };
      
      # Throttle pour éviter le spam
      throttle = 50; # ms
    };
  };
  
  # =====================================================================
  # DÉPENDANCES REQUISES
  # =====================================================================
  
  # nui.nvim est requis pour noice
  plugins.nui = {
    enable = true;
  };
  
  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE
  # =====================================================================
  
extraConfigLua = ''
    -- Configuration minimale pour noice avec gruvbox (intégration automatique)
    local function setup_noice_transparency()
      -- Seuls les ajustements de transparence nécessaires
      -- Les couleurs gruvbox sont automatiquement appliquées via colorschemes.gruvbox.enable = true
      
      -- Assurer la transparence pour les mini messages
      vim.api.nvim_set_hl(0, "NoiceMini", { 
        bg = "NONE", 
        fg = nil,  -- Hérite de gruvbox automatiquement
        italic = true
      })
      
      -- Override de couleurs spécifiques
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { 
        fg = "#b8bb26",  -- Gruvbox bright_green (votre override)
        bg = "NONE" 
      })
      
      -- Optionnel: autres ajustements pour une meilleure visibilité en transparent
      vim.api.nvim_set_hl(0, "NoicePopupmenuBorder", { 
        fg = nil,  -- Hérite de gruvbox
        bg = "NONE" 
      })
    end
    
    -- Appliquer les ajustements de transparence après le chargement du colorscheme
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "gruvbox*",
      callback = function()
        setup_noice_transparency()
      end,
    })
    
    -- Appliquer au démarrage
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.defer_fn(function()
          setup_noice_transparency()
        end, 100)
      end,
    })
    
    -- Configuration de l'intégration avec telescope si disponible
    local ok, telescope = pcall(require, "telescope")
    if ok then
      telescope.load_extension("noice")
    end
    
    -- Fonction utilitaire pour vérifier si noice est actif
    _G.noice_enabled = function()
      local ok, noice = pcall(require, "noice")
      return ok and noice.api.status.command.has()
    end
    
    -- Auto-commandes pour des intégrations spéciales
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy", 
      callback = function()
        -- Intégration avec lualine si disponible
        local ok, lualine = pcall(require, "lualine")
        if ok then
          -- On peut ajouter noice status à lualine ici si souhaité
        end
      end,
    })
  '';
}
