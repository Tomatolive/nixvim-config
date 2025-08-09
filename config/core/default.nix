{
  imports = [ ./colorscheme.nix ./keymaps.nix ./options.nix ];

  performance = {
    byteCompileLua = {
      enable = true;
      configs = true; # Déjà true par défaut  
      plugins = true; # Le plus impactant
      nvimRuntime = false; # Gain marginal, complexité++
      luaLib = false; # Idem
    };

    # Permet de combiner les plugins pour réduire l'espace disque
    # combinePlugins = {
    #   enable = true;
    #   standalonePlugins = [
    #     "friendly-snippets"  # ← OBLIGATOIRE sinon blink ne voit pas les snippets
    #     "nvim-treesitter"    # Évite les problèmes de grammaires
    #   ];
    # };
  };
}
