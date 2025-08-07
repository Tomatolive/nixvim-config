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

        #Bufferline
        BufferlineBufferSelected = { fg = "#689d6a"; bold = true; italic = true; };
        BufferlineSeparator = { fg = "#689d6a"; };
        BufferlineSeparatorSelected = { fg = "#fadb2f"; };
        BufferlineTab = { fg = "#689d6a"; };
        BufferlineTabSelected = { fg = "#689d6a"; bold = true; italic = true; };
        BufferlineTabSeparator = { fg = "#7c6f64"; };
        BufferlineTabSeparatorSelected = { fg = "#7c6f64"; };

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

        # Blink completion
        BlinkCmpMenu = { bg = "#3c3836"; fg = "#ebdbb2"; };
        BlinkCmpMenuBorder = { fg = "#b8bb26"; bg = "#3c3836"; };
        BlinkCmpMenuSelection = { bg = "#504945"; fg = "#ebdbb2"; bold = true; };
        BlinkCmpDoc = { bg = "#3c3836"; fg = "#ebdbb2"; };
        BlinkCmpDocBorder = { fg = "#b8bb26"; bg = "#3c3836"; };
        BlinkCmpSignatureHelp = { bg = "#3c3836"; fg = "#ebdbb2"; };
        BlinkCmpSignatureHelpBorder = { fg = "#b8bb26"; bg = "#3c3836"; };
        BlinkCmpGhostText = { fg = "#928374"; italic = true; };

        # Dropbar
        # DropBarNormal = { fg = "#928374"; bg = "#32302F"; italic = true; };
        # DropBarIconUIIndicator = { fg = "#928374"; bg = "#32302F"; italic = true; };
        # DropBarIconUIIndicatorSelected = { fg = "#928374"; bg = "#32302F"; italic = true; };
        # DropBarIconUIPickerIcon = { fg = "#928374"; bg = "#32302F"; italic = true; };
        # DropBarMenuCurrentContext = { fg = "#928374"; bg = "#32302F"; italic = true; };
        # DropBarMenuNormalFloat = { fg = "#928374"; bg = "#32302F"; italic = true; };
        # DropBarMenuFloatBorder = { fg = "#928374"; bg = "#32302F"; italic = true; };
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

  performance = {
    byteCompileLua = {
      enable = true;
      configs = true; # Déjà true par défaut  
      plugins = true; # Le plus impactant
      nvimRuntime = false; # Gain marginal, complexité++
      luaLib = false; # Idem
    };
  };
}
