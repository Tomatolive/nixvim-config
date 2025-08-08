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
      c = [ "cppcheck" ];
      cpp = [ "cppcheck" "cpplint" ];
      markdown = [ "markdownlint" ];
    };

    # Nixvim configure automatiquement les autocommands et tout le reste
  };
}
