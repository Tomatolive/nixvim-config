{
  imports = [ ./keymaps.nix ];
  colorschemes.gruvbox = {
    enable = true;
    settings = {
      transparent_mode = true;
      overrides = {
        NormalFloat = {
          bg = "#3c3836"; # Fond gruvbox pour TOUS les popups flottants
          fg = "#ebdbb2"; # (which-key, autocomplétion, diagnostics, etc.)
        };
        FloatBorder = {
          fg = "#b8bb26"; # Bordures vertes pour tous les popups
          bg = "#3c3836"; # Fond cohérent
        };
        FloatTitle = {
          fg = "#fe8019"; # Titres orange
          bg = "#3c3836"; # Fond cohérent
          bold = true;
        };
        NoiceCmdlinePopupBorder = {
          fg = "#b8bb26";
          bg = "#3c3836";
        };
      };
    };
  };
  globals.mapleader = " ";
}
