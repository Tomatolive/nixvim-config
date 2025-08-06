{
  # =====================================================================
  # TREESITTER - Configuration simplifiée
  # La configuration principale est dans lang/default.nix
  # =====================================================================
  
  plugins = {
    # Plugin de base activé dans lang/default.nix
    treesitter = {
      enable = true;
    };
    
    # Plugin additionnel pour le contexte
    treesitter-context = {
      enable = true;
      settings = {
        enable = true;
        max_lines = 0;
        line_numbers = true;
        trim_scope = "outer";
        mode = "cursor";
      };
    };
  };
}
