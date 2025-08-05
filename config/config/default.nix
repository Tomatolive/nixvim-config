{
  imports = [ ./keymaps.nix ];

  # =====================================================================
  # COLORSCHEME - Gruvbox avec transparence
  # =====================================================================
  colorschemes.gruvbox = {
    enable = true;
    settings = {
      transparent_mode = true;
      overrides = {
        # StatusLine (spécialement pour le dashboard)
        StatusLine = { bg = "#32302F"; fg = "#ebdbb2"; };

        # Which-key spécifique
        WhichKeySeparator = { fg = "#fadb2f"; };
        WhichKey = { fg = "#fadb2f"; };
        WhichKeyDesc = { fg = "#689d6a"; };
        WhichKeyGroup = { fg = "#fe8019"; };
        WhichKeyNormal = { bg = "#3c3836"; };
        WhichKeyBorder = { fg = "#689d6a"; bg = "#3c3836"; };
        WhichKeyTitle = { fg = "#689d6a"; bg = "#3c3836"; };

        # Noice cmdline
        NoiceCmdlinePopupBorder = {
          fg = "#b8bb26";
        };
      };
    };
  };

  # =====================================================================
  # LEADER KEY
  # =====================================================================
  globals.mapleader = " ";

  # =====================================================================
  # OPTIONS NEOVIM
  # =====================================================================
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
}
