{
  # =====================================================================  
  # TROUBLE.NVIM - Configuration minimale et fonctionnelle
  # =====================================================================

  plugins.trouble = {
    enable = true;

    settings = {
      # Configuration ultra-simple (défauts intelligents)
      focus = true;

      # Icônes cohérentes avec diagnostics
      icons = {
        error = " ";
        warn = " ";
        info = " ";
        hint = "󰌵 ";
      };
    };
  };
}
