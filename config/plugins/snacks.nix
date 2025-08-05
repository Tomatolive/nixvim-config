{
  plugins = {
    # =====================================================================
    # Configuration de snacks.nvim - Collection de plugins QoL
    # =====================================================================
    snacks = {
      enable = true;

      settings = {
        # =================================================================
        # Module BIGFILE - Optimisations pour les gros fichiers
        # =================================================================
        bigfile = {
          enabled = true;
          notify = true;
          size = 1048576; # 1MB
          setup.__raw = ''
            function(ctx)
              vim.cmd("setlocal nonumber norelativenumber")
              vim.schedule(function()
                vim.bo[ctx.buf].syntax = ctx.ft
              end)
              vim.cmd("let g:loaded_matchparen = 1")
              vim.cmd("setlocal nocursorline nocursorcolumn")
              vim.cmd("setlocal nofoldenable")
              vim.cmd("setlocal signcolumn=no")
              vim.cmd("setlocal noswapfile noundofile")
              vim.b.minianimate_disable = true
            end
          '';
        };

        # =================================================================
        # Module DASHBOARD - Écran d'accueil
        # =================================================================
        dashboard = {
          enabled = true;
          width = 60;
          row = null;
          col = null;
          pane_gap = 4;
          autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

          sections = [
            { section = "header"; }
            { section = "keys"; gap = 1; padding = 1; }
            {
              section = "recent_files";
              icon = " ";
              title = "Recent Files";
              indent = 2;
              padding = 1;
            }
            {
              section = "projects";
              icon = " ";
              title = "Projects";
              indent = 2;
              padding = 1;
            }
          ];

          preset = {
            keys = [
              { icon = " "; key = "f"; desc = "Find File"; action = ":lua Snacks.picker.files()"; }
              { icon = " "; key = "n"; desc = "New File"; action = ":ene | startinsert"; }
              { icon = " "; key = "g"; desc = "Find Text"; action = ":lua Snacks.picker.grep()"; }
              { icon = " "; key = "r"; desc = "Recent Files"; action = ":lua Snacks.picker.recent()"; }
              { icon = " "; key = "c"; desc = "Config"; action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})"; }
              { icon = " "; key = "s"; desc = "Restore Session"; section = "session"; }
              { icon = " "; key = "q"; desc = "Quit"; action = ":qa"; }
            ];
          };
        };

        # =================================================================
        # Module INDENT - Guides d'indentation
        # =================================================================
        indent = {
          enabled = true;
          animate = {
            enabled = false;
          };
          char = "│";
          blank = " ";
          priority = 200;
          scope = {
            enabled = true;
            char = "│";
            underline = false;
            only_current = false;
          };
          chunk = {
            enabled = false;
          };
        };

        # =================================================================
        # Module INPUT - Amélioration de vim.ui.input
        # =================================================================
        input = {
          enabled = true;
          icon = " ";
          icon_pos = "left";
          prompt_pos = "title";
          win = {
            style = "input";
            border = "rounded";
          };
          expand = true;
        };

        # =================================================================
        # Module NOTIFIER - Système de notifications
        # =================================================================
        notifier = {
          enabled = true;
          timeout = 3000;
          width = {
            min = 40;
            max = 0.4;
          };
          height = {
            min = 1;
            max = 0.6;
          };
          margin = {
            top = 0;
            right = 1;
            bottom = 0;
            left = 0;
          };
          padding = true;
          sort = [ "level" "added" ];
          level = 1;
          icons = {
            error = " ";
            warn = " ";
            info = " ";
            debug = " ";
            trace = " ";
          };
          style = "compact";
          top_down = true;
          date_format = "%R";
        };

        # =================================================================
        # Module PICKER - Fuzzy finder
        # =================================================================
        picker = {
          enabled = true;
          icons = {
            git = {
              added = " ";
              changed = " ";
              conflict = " ";
              deleted = " ";
              ignored = " ";
              renamed = " ";
              unmerged = " ";
              untracked = "?";
            };
            kinds = {
              Array = " ";
              Boolean = "󰨙 ";
              Class = " ";
              Constant = "󰏿 ";
              Constructor = " ";
              Enum = " ";
              Field = " ";
              File = " ";
              Folder = " ";
              Function = "󰊕 ";
              Interface = " ";
              Keyword = "󰻾 ";
              Method = "󰊕 ";
              Module = " ";
              Property = " ";
              Snippet = "󱄽 ";
              String = " ";
              Variable = "󰀫 ";
            };
          };

          sources = {
            explorer = {
              auto_close = false;
              hidden = true;
              git_status = true;
              git_status_open = false;
              git_untracked = true;
              follow_file = true;
              focus = "list";
              jump = { close = false; };
              layout = {
                preset = "sidebar";
                preview = false;
              };
            };
          };
        };

        # =================================================================
        # Module QUICKFILE - Ouverture rapide de fichiers
        # =================================================================
        quickfile = {
          enabled = true;
        };

        # =================================================================
        # Module SCOPE - Mise en évidence du scope actuel
        # =================================================================
        scope = {
          enabled = true;
          min_size = 2;
          max_size = 20;
          edge = false;
          siblings = true;
          treesitter = {
            blocks = [
              "function_item"
              "function_definition"
              "method_definition"
              "class_definition"
              "if_statement"
              "for_statement"
              "while_statement"
              "with_statement"
              "try_statement"
            ];
          };
        };

        # =================================================================
        # Module SCROLL - Défilement fluide
        # =================================================================
        scroll = {
          enabled = true;
          animate = {
            duration = { step = 15; total = 250; };
            easing = "linear";
          };
          spamming = 10;
        };

        # =================================================================
        # Module STATUSCOLUMN - Colonne de statut moderne
        # =================================================================
        statuscolumn = {
          enabled = true;
          left = [ "mark" "sign" ];
          right = [ "fold" "git" ];
          folds = {
            open = false;
            git_hl = false;
          };
          git = {
            patterns = [ "GitSign" "MiniDiffSign" ];
          };
        };

        # =================================================================
        # Module WORDS - Mise en évidence des mots sous le curseur
        # =================================================================
        words = {
          enabled = true;
          debounce = 200;
          notify_jump = false;
          notify_end = true;
          foldopen = true;
          jumplist = true;
          modes = [ "n" "i" "c" ];
        };

        # =================================================================
        # Modules additionnels
        # =================================================================
        terminal = { enabled = true; };
        gitbrowse = { enabled = true; };
        lazygit = { enabled = true; };
        zen = { enabled = false; };
        profiler = { enabled = false; };
        scratch = { enabled = false; };

        # =================================================================
        # Styles personnalisés
        # =================================================================
        styles = {
          notification = {
            wo = { wrap = true; };
            border = "rounded";
          };
          input = {
            border = "rounded";
          };
          terminal = {
            bo = { filetype = "snacks_terminal"; };
            wo = { winbar = "%{b:snacks_terminal.id}: %{b:term_title}"; };
          };
        };
      };
    };

    telescope.enable = true;
  };
}
