{
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
        WhichKeyNormal = { bg = "#32302F"; };
        WhichKeyBorder = { fg = "#689d6a"; bg = "#32302F"; };
        WhichKeyTitle = { fg = "#689d6a"; bg = "#32302F"; };

        # Noice cmdline
        NoiceCmdlinePopupBorder = {
          fg = "#b8bb26";
        };

        # Blink completion
        BlinkCmpMenu = { bg = "#32302F"; fg = "#ebdbb2"; };
        BlinkCmpMenuBorder = { fg = "#b8bb26"; bg = "#32302F"; };
        BlinkCmpMenuSelection = { bg = "#504945"; fg = "#ebdbb2"; bold = true; };
        BlinkCmpDoc = { bg = "#32302F"; fg = "#ebdbb2"; };
        BlinkCmpDocBorder = { fg = "#b8bb26"; bg = "#32302F"; };
        BlinkCmpSignatureHelp = { bg = "#32302F"; fg = "#ebdbb2"; };
        BlinkCmpSignatureHelpBorder = { fg = "#b8bb26"; bg = "#32302F"; };
        BlinkCmpGhostText = { fg = "#928374"; italic = true; };

        # Dropbar
        WinBar = { bg = "#32302F"; };
      };
    };
  };
}
