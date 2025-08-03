{
  # =====================================================================
  # TREESITTER - Configuration simplifiée
  # NOTE: La configuration principale est dans lang/default.nix
  # Ce fichier ne fait qu'activer le plugin avec configuration de base
  # =====================================================================
  
  plugins = {
    treesitter = {
      enable = true;
      # La configuration détaillée est centralisée dans lang/default.nix
      # pour éviter les redondances et conflits
    };
    
    # Plugin additionnel pour le contexte treesitter
    treesitter-context = {
      enable = true;
      settings = {
        enable = true;
        max_lines = 0; # 0 = pas de limite
        min_window_height = 0;
        line_numbers = true;
        multiline_threshold = 20;
        trim_scope = "outer";
        mode = "cursor";
        separator = null;
      };
    };
  };
}
