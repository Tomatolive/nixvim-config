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
          notify = true;   # Notifier quand un fichier est considéré comme gros
          size = 1048576;  # 1MB en bytes
          setup.__raw= ''
      function(ctx)
        -- Disable line numbers and relative line numbers
        vim.cmd("setlocal nonumber norelativenumber")

        -- Syntax highlighting
        vim.schedule(function()
          vim.bo[ctx.buf].syntax = ctx.ft
        end)

        -- Disable matchparen
        vim.cmd("let g:loaded_matchparen = 1")

        -- Disable cursor line and column
        vim.cmd("setlocal nocursorline nocursorcolumn")

        -- Disable folding
        vim.cmd("setlocal nofoldenable")

        -- Disable sign column
        vim.cmd("setlocal signcolumn=no")

        -- Disable swap file and undo file
        vim.cmd("setlocal noswapfile noundofile")

        -- Disable mini animate
        vim.b.minianimate_disable = true
      end
    '';
        };
        
        # =================================================================
        # Module DASHBOARD - Écran d'accueil personnalisable
        # =================================================================
        dashboard = { 
          enabled = true;
          width = 60;
          row = null;  # centré verticalement
          col = null;  # centré horizontalement
          pane_gap = 4;
          autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
          
          # Sections du dashboard
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
        # Module INDENT - Guides d'indentation améliorés
        # =================================================================
        indent = { 
          enabled = true;
          animate = {
            enabled = false;  # Désactiver les animations pour de meilleures performances
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
            # char = {
            #   corner_top = "┌";
            #   corner_bottom = "└"; 
            #   horizontal = "─";
            #   vertical = "│";
            #   arrow = ">";
            # };
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
        # Module NOTIFIER - Système de notifications moderne
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
          level = 1;  # vim.log.levels.INFO
          icons = {
            error = " ";
            warn = " ";
            info = " ";
            debug = " ";
            trace = " ";
          };
          style = "compact";  # "compact", "fancy", "minimal"
          top_down = true;
          date_format = "%R";
        };
        
        # =================================================================
        # Module PICKER - Fuzzy finder moderne et rapide
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
          
          # Configuration de l'explorateur de fichiers
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
          spamming = 10;  # threshold pour ignorer les événements de défilement répétés
          # Vous pouvez mapper vos propres touches
          # keys = {
          #   ["<C-u>"] = { "scroll"; args = [ "-0.5" ]; };
          #   ["<C-d>"] = { "scroll"; args = [ "0.5" ]; };
          # };
        };
        
        # =================================================================
        # Module STATUSCOLUMN - Colonne de statut moderne
        # =================================================================
        statuscolumn = { 
          enabled = true;
          left = [ "mark" "sign" ];      # priorité des signes à gauche (haut vers bas)
          right = [ "fold" "git" ];      # priorité des signes à droite (haut vers bas)
          folds = {
            open = false;     # montrer les icônes de fold ouvert
            git_hl = false;   # utiliser la coloration Git pour les icônes de fold
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
        # Modules additionnels (désactivés par défaut)
        # =================================================================
        
        # Terminal intégré
        terminal = { enabled = true; };
        
        # Intégration Git
        gitbrowse = { enabled = true; };
        lazygit = { enabled = true; };
        
        # Mode Zen pour l'écriture
        zen = { enabled = false; };
        
        # Profiler de performance
        profiler = { enabled = false; };
        
        # Scratch buffer
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
  };
  
  # # =====================================================================
  # # KEYMAPS pour Snacks.nvim
  # # =====================================================================
  # keymaps = [
  #   # ===== PICKER / FUZZY FINDER =====
  #   {
  #     mode = "n";
  #     key = "<leader><space>";
  #     action = "<cmd>lua Snacks.picker.smart()<cr>";
  #     options.desc = "Smart Find Files";
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>ff";
  #     action = "<cmd>lua Snacks.picker.files()<cr>";
  #     options.desc = "Find Files";
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>fg";
  #     action = "<cmd>lua Snacks.picker.grep()<cr>";
  #     options.desc = "Find Text (Grep)";
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>fb";
  #     action = "<cmd>lua Snacks.picker.buffers()<cr>";
  #     options.desc = "Find Buffers";
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>fr";
  #     action = "<cmd>lua Snacks.picker.recent()<cr>";
  #     options.desc = "Recent Files";
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>fc";
  #     action = "<cmd>lua Snacks.picker.command_history()<cr>";
  #     options.desc = "Command History";
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>fs";
  #     action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
  #     options.desc = "LSP Symbols";
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>fS";
  #     action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>";
  #     options.desc = "LSP Workspace Symbols";
  #   }
  #
  #   # ===== EXPLORER =====
  #   {
  #     mode = "n";
  #     key = "<leader>e";
  #     action = "<cmd>lua Snacks.explorer()<cr>";
  #     options.desc = "Explorer";
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>E";
  #     action = "<cmd>lua Snacks.explorer({ focus = 'files' })<cr>";
  #     options.desc = "Explorer (Focus Files)";
  #   }
  #
  #   # ===== NOTIFICATIONS =====
  #   {
  #     mode = "n";
  #     key = "<leader>un";
  #     action = "<cmd>lua Snacks.notifier.hide()<cr>";
  #     options.desc = "Dismiss All Notifications";
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>nh";
  #     action = "<cmd>lua Snacks.notifier.show_history()<cr>";
  #     options.desc = "Notification History";
  #   }
  #
  #   # ===== LSP INTEGRATION =====
  #   {
  #     mode = "n";
  #     key = "gd";
  #     action = "<cmd>lua Snacks.picker.lsp_definitions()<cr>";
  #     options.desc = "Goto Definition";
  #   }
  #   {
  #     mode = "n";
  #     key = "gr";
  #     action = "<cmd>lua Snacks.picker.lsp_references()<cr>";
  #     options.desc = "Goto References";
  #   }
  #   {
  #     mode = "n";
  #     key = "gI";
  #     action = "<cmd>lua Snacks.picker.lsp_implementations()<cr>";
  #     options.desc = "Goto Implementation";
  #   }
  #   {
  #     mode = "n";
  #     key = "gy";
  #     action = "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>";
  #     options.desc = "Goto Type Definition";
  #   }
  #
  #   # ===== WORDS (navigation des mots identiques) =====
  #   {
  #     mode = "n";
  #     key = "]]";
  #     action = "<cmd>lua Snacks.words.jump(vim.v.count1)<cr>";
  #     options.desc = "Next Reference";
  #   }
  #   {
  #     mode = "n";
  #     key = "[[";
  #     action = "<cmd>lua Snacks.words.jump(-vim.v.count1)<cr>";
  #     options.desc = "Prev Reference"; 
  #   }
  #
  #   # ===== SCROLL NAVIGATION =====
  #   {
  #     mode = [ "n" "x" ];
  #     key = "<C-f>";
  #     action = "<cmd>lua Snacks.scroll.animate('scroll', { '0.5', 'false' })<cr>";
  #     options.desc = "Scroll Down";
  #   }
  #   {
  #     mode = [ "n" "x" ];
  #     key = "<C-b>";
  #     action = "<cmd>lua Snacks.scroll.animate('scroll', { '-0.5', 'false' })<cr>";
  #     options.desc = "Scroll Up";
  #   }
  # ];
  #
  # plugins.which-key.enable = true;
  
  # =====================================================================
  # CONFIGURATION GLOBALE NEOVIM RECOMMANDÉE
  # =====================================================================
  opts = {
    # Performance
    updatetime = 200;
    timeoutlen = 300;
    
    # Interface
    number = true;
    relativenumber = true;
    signcolumn = "yes";
    
    # Recherche
    ignorecase = true;
    smartcase = true;
    
    # Tabs et indentation
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    smartindent = true;
    
    # Splits
    splitbelow = true;
    splitright = true;
    
    # Autre
    wrap = false;
    scrolloff = 8;
    sidescrolloff = 8;
    mouse = "a";
    clipboard = "unnamedplus";
  };
}
