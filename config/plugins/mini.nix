{
  # =====================================================================
  # MINI.NVIM - Configuration simplifiée
  # =====================================================================

  plugins.mini = {
    enable = true;
    mockDevIcons = true;
    modules = {
      # Icons de base
      icons = { };

      # Text objects améliorés
      ai = {
        n_lines = 500;
        custom_textobjects.__raw = ''
          {
            f = require('mini.ai').gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
            c = require('mini.ai').gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }),
            C = require('mini.ai').gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
            o = require('mini.ai').gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
            L = require('mini.ai').gen_spec.treesitter({ a = "@loop.outer", i = "@loop.inner" }),
          }
        '';
      };

      # Auto-pairing simple
      pairs = {
        modes = {
          insert = true;
          command = false;
          terminal = false;
        };
        # silent = true; # Évite les conflits avec noice
      };

      # Surround simple
      surround = {
        mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
        };
        # silent = true; # Évite les conflits avec noice
      };

      # Commentaires
      comment = {
        mappings = {
          comment = "gc";
          comment_line = "gcc";
          comment_visual = "gc";
        };
        # silent = true; # Évite les conflits avec noice
      };

      # Mise en évidence de patterns
      hipatterns = {
        highlighters = {
          hex_color = {
            __raw = ''require('mini.hipatterns').gen_highlighter.hex_color()'';
          };
          # Couleurs courtes (#rgb)
          shorthand = {
            pattern = "()#%x%x%x()%f[^%x%w]";
            group.__raw = ''
              function(_, _, data)
                local match = data.full_match
                local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
                return require('mini.hipatterns').compute_hex_color_group("#" .. r .. r .. g .. g .. b .. b, "bg")
              end
            '';
          };
        };
      };

      # Déplacement de lignes/blocs amélioré
      move = {
        mappings = {
          # Déplacements avec Alt (cohérent avec vos keymaps existants)
          left = "<A-j>"; # Gauche (indent)
          right = "<A-m>"; # Droite (dedent)
          down = "<A-k>"; # Bas (garde cohérence)
          up = "<A-l>"; # Haut (garde cohérence)

          # En mode visual
          line_left = "<A-j>";
          line_right = "<A-m>";
          line_down = "<A-k>";
          line_up = "<A-l>";
        };
      };

      # Navigation f/F/t/T améliorée (complémentaire à spider)
      jump = {
        mappings = {
          forward = "f";
          backward = "F";
          forward_till = "t";
          backward_till = "T";
          repeat_jump = ";";
        };
      };

      # Split/join intelligent
      splitjoin = {
        mappings = {
          toggle = "gS"; # Split ↔ join arguments/listes
        };
      };

      # Navigation avec [ et ] pour différents objets
      bracketed = {

        # Désactive les mappings
        buffer = { suffix = ""; }; # Désactive [b ]b (tu as déjà ça)
        diagnostic = { suffix = ""; }; # Désactive [d ]d (tu as déjà ça)
        yank = { suffix = ""; }; # Désactive [y ]y (tu as yanky)
        location = { suffix = ""; }; # Désactive [l ]l (défaut neovim)  
        quickfix = { suffix = ""; }; # Désactive [q ]q (défaut neovim)
        file = { suffix = ""; }; # Désactive [f ]f (pas franchement utile)
        indent = { suffix = ""; }; # Désactive [i ]i (pas franchement utile)
        treesitter = { suffix = ""; }; # Désactive [n ]n (pas franchement utile)

        # Active les autres mappings utiles
        comment = { suffix = "c"; }; # [c ]c pour les commentaires
        conflict = { suffix = "x"; }; # [x ]x pour les conflits git
        jump = { suffix = "j"; }; # [j ]j pour la jump list
        oldfile = { suffix = "o"; }; # [o ]o pour les fichiers récents
        undo = { suffix = "u"; }; # [u ]u pour l'undo tree
        window = { suffix = "w"; }; # [w ]w pour les fenêtres
      };
    };
  };

  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "gs"; group = "Surround"; }
    { __unkeyed-1 = "gp"; group = "Peek/Preview"; }

    # Textobjects mini.ai
    { __unkeyed-1 = "af"; desc = "around function"; mode = [ "x" "o" ]; }
    { __unkeyed-1 = "if"; desc = "inner function"; mode = [ "x" "o" ]; }
    { __unkeyed-1 = "ac"; desc = "around comment"; mode = [ "x" "o" ]; }
    { __unkeyed-1 = "ic"; desc = "inner comment"; mode = [ "x" "o" ]; }
    { __unkeyed-1 = "aC"; desc = "around class"; mode = [ "x" "o" ]; }
    { __unkeyed-1 = "iC"; desc = "inner class"; mode = [ "x" "o" ]; }
    { __unkeyed-1 = "ao"; desc = "around conditional"; mode = [ "x" "o" ]; }
    { __unkeyed-1 = "io"; desc = "inner conditional"; mode = [ "x" "o" ]; }
    { __unkeyed-1 = "aL"; desc = "around loop"; mode = [ "x" "o" ]; }
    { __unkeyed-1 = "iL"; desc = "inner loop"; mode = [ "x" "o" ]; }
  ];

}
