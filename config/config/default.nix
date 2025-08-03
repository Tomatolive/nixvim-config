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
        # Popups et fenêtres flottantes
        NormalFloat = {
          bg = "#3c3836";
          fg = "#ebdbb2";
        };
        FloatBorder = {
          fg = "#b8bb26";
          bg = "#3c3836";
        };
        FloatTitle = {
          fg = "#fe8019";
          bg = "#3c3836";
          bold = true;
        };
        
        # Which-key spécifique
        WhichKeyNormal = {
          bg = "#3c3836";
          fg = "#ebdbb2";
        };
        WhichKeyBorder = {
          fg = "#b8bb26";
          bg = "#3c3836";
        };
        
        # Noice cmdline
        NoiceCmdlinePopupBorder = {
          fg = "#b8bb26";
          bg = "#3c3836";
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
