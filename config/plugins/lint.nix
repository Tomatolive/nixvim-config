{
  # =====================================================================
  # NVIM-LINT - Version simplifiée
  # =====================================================================

  plugins.lint = {
    enable = true;

    # Configuration simple - juste les linters par filetype
    lintersByFt = {
      nix = [ "deadnix" "statix" ];
      haskell = [ "hlint" ];
    };

    # Nixvim configure automatiquement les autocommands et tout le reste
  };
}
