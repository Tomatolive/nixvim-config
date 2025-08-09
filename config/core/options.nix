{
  # =====================================================================
  # OPTIONS NEOVIM
  # =====================================================================

  globals.mapleader = " ";

  opts = {
    # Performance
    updatetime = 200;
    timeoutlen = 300;

    # Interface
    number = true;
    relativenumber = true;
    signcolumn = "yes";
    cursorline = true;

    # Recherche
    ignorecase = true;
    smartcase = true;
    hlsearch = true;

    # Édition
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    smartindent = true;
    autoindent = true;

    # Splits
    splitbelow = true;
    splitright = true;

    # Autre
    wrap = false;
    scrolloff = 8;
    sidescrolloff = 8;
    mouse = "a";
    clipboard = "unnamedplus";

    # Sauvegarde et undo
    undofile = true;
    swapfile = false;
    backup = false;

    # Interface terminale
    termguicolors = true;
  };

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
    #   ];
    # };
  };
}
