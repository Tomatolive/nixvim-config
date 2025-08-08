{
  # =====================================================================
  # WHICH-KEY - Configuration simple sans autocommands
  # =====================================================================

  plugins.which-key = {
    enable = true;

    settings = {
      preset = "helix";
      icons = {
        breadcrumb = "»";
        separator = "➜";
        group = "+";
      };
      win = {
        border = "rounded";
        padding = [ 1 2 ];
      };
      delay = 200;
      
      # Configuration des specs statiques SEULEMENT pour les groupes principaux
      spec = [
        { __unkeyed-1 = "<leader>b"; group = "Buffers"; }
        { __unkeyed-1 = "<leader>c"; group = "Code"; }
        { __unkeyed-1 = "<leader>f"; group = "Find/File"; }
        { __unkeyed-1 = "<leader>g"; group = "Git"; }
        { __unkeyed-1 = "<leader>n"; group = "Notifications"; }
        { __unkeyed-1 = "<leader>r"; group = "Persistence"; }
        { __unkeyed-1 = "<leader>s"; group = "Search"; }
        { __unkeyed-1 = "<leader>t"; group = "Terminal"; }
        { __unkeyed-1 = "<leader>u"; group = "UI"; }
        { __unkeyed-1 = "<leader>x"; group = "Diagnostics"; }
        
        # Navigation
        { __unkeyed-1 = "g"; group = "󰈮 Goto"; }
        { __unkeyed-1 = "["; group = "󰒮 Previous"; }
        { __unkeyed-1 = "]"; group = "󰒭 Next"; }
      ];
    };
  };

  # =====================================================================
  # AUCUNE CONFIGURATION SUPPLÉMENTAIRE !
  # Les keymaps spécifiques aux langages sont maintenant dans leurs
  # fichiers respectifs avec buffer local, which-key les découvre automatiquement
  # =====================================================================
}
