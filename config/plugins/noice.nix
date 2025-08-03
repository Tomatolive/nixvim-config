{
  # =====================================================================
  # NOICE.NVIM - Interface utilisateur moderne pour Neovim
  # =====================================================================
  
  plugins.noice = {
    enable = true;
    
    settings = {
      # Configuration des commandes (cmdline)
      cmdline = {
        enabled = true;
        view = "cmdline_popup";
        
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
      
      # Configuration des messages
      messages = {
        enabled = true;
        view = "notify";
        view_error = "notify";
        view_warn = "notify";
        view_history = "messages";
        view_search = "virtualtext";
      };
      
      # Configuration du menu popup
      popupmenu = {
        enabled = true;
        backend = "nui";
      };
      
      # Notifications désactivées (utilise snacks.notifier)
      notify = {
        enabled = false;
      };
      
      # Configuration LSP
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
      
      # Presets
      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = false;
        lsp_doc_border = false;
      };
      
      # Configuration des vues
      views = {
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
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder";
          };
        };
        
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
      
      # Routes simplifiées
      routes = [
        # Messages de sauvegarde vers mini
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
      ];
      
      # Format pour la progression LSP
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
      
      health = {
        checker = false;
      };
      
      smart_move = {
        enabled = true;
        excluded_filetypes = [ "cmp_menu" "cmp_docs" "notify" ];
      };
      
      throttle = 50;
    };
  };
  
  # nui.nvim est requis pour noice
  plugins.nui = {
    enable = true;
  };
  
  extraConfigLua = ''
    -- Intégration avec telescope si disponible
    local ok, telescope = pcall(require, "telescope")
    if ok then
      telescope.load_extension("noice")
    end
  '';
}
