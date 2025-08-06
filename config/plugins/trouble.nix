{
  # =====================================================================  
  # TROUBLE.NVIM - Interface avancée pour diagnostics (OPTIONNEL)
  # =====================================================================

  plugins.trouble = {
    enable = true; # Mettre false si tu n'en veux pas

    settings = {
      # Configuration simple et efficace
      auto_close = true;
      auto_open = false;
      focus = true;

      # Icônes cohérentes avec la config diagnostic
      icons = {
        error = " ";
        warn = " ";
        info = " ";
        hint = "󰌵 ";
      };

      # Modes utiles
      modes = {
        diagnostics = {
          mode = "diagnostics";
          preview = {
            type = "split";
            relative = "win";
            position = "right";
            size = 0.3;
          };
        };
      };
    };
  };

  # Keymaps pour trouble (si activé)
  keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>Trouble loclist toggle<cr>";
      options.desc = "Location List (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>Trouble qflist toggle<cr>";
      options.desc = "Quickfix List (Trouble)";
    }
  ];
}
