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
      
      # Configuration des specs statiques
      spec = [
        { __unkeyed-1 = "<leader>c"; group = "Code"; }
        { __unkeyed-1 = "<leader>x"; group = "Diagnostics"; }
        
        { __unkeyed-1 = "g"; group = "Goto"; }
        { __unkeyed-1 = "["; group = "Previous"; }
        { __unkeyed-1 = "]"; group = "Next"; }
        { __unkeyed-1 = "z"; group = "Fold"; }
      ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>?";
      action.__raw = ''
        function()
          require("which-key").show({ global = false })
        end
      '';
      options.desc = "Buffer Local Keymaps";
    }
  ];

  # =====================================================================
  # AUCUNE CONFIGURATION SUPPLÉMENTAIRE !
  # Les keymaps spécifiques aux langages sont maintenant dans leurs
  # fichiers respectifs avec buffer local, which-key les découvre automatiquement
  # =====================================================================
}
