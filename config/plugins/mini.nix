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
      };

      # Auto-pairing simple
      pairs = {
        modes = {
          insert = true;
          command = false;
          terminal = false;
        };
        silent = true; # Évite les conflits avec noice
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
        silent = true; # Évite les conflits avec noice
      };

      # Commentaires
      comment = {
        mappings = {
          comment = "gc";
          comment_line = "gcc";
          comment_visual = "gc";
        };
        silent = true; # Évite les conflits avec noice
      };

      # Mise en évidence de patterns
      hipatterns = {
        highlighters = {
          hex_color = {
            __raw = ''require('mini.hipatterns').gen_highlighter.hex_color()'';
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
    };
  };

  # Pas d'extraConfigLua complexe - Nixvim gère les intégrations
}
