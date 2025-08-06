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
        modes = { insert = true; command = false; terminal = false; };
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
    };
  };

  # Pas d'extraConfigLua complexe - Nixvim gère les intégrations
}
