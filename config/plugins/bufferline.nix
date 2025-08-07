{
  # =====================================================================
  # BUFFERLINE - Configuration simplifiée (défauts intelligents)
  # =====================================================================

  plugins.bufferline = {
    enable = true;

    settings = {
      options = {
        # ===== INTÉGRATIONS ESSENTIELLES =====

        # Intégration Snacks pour fermeture intelligente
        close_command.__raw = ''
          function(n)
            require("snacks").bufdelete(n)
          end
        '';
        right_mouse_command.__raw = ''
          function(n)
            require("snacks").bufdelete(n)
          end
        '';

        # Diagnostics LSP avec indicateur personnalisé
        diagnostics = "nvim_lsp";
        diagnostics_indicator.__raw = ''
          function(_, _, diag)
            local icons = {
              Error = " ",
              Warn = " ", 
              Info = " ",
              Hint = " ",
            }
            local ret = (diag.error and icons.Error .. diag.error .. " " or "")
              .. (diag.warning and icons.Warn .. diag.warning or "")
            return vim.trim(ret)
          end
        '';

        # ===== STYLE PERSONNEL =====

        always_show_bufferline = false;

        # Offsets pour sidebars
        offsets = [
          {
            filetype = "neo-tree";
            text = "Neo-tree";
            highlight = "Directory";
            text_align = "left";
          }
          {
            filetype = "snacks_layout_box";
          }
        ];

        # ===== VALEURS NON-DÉFAUT UNIQUEMENT =====

        # Tailles personnalisées
        max_name_length = 18;
        tab_size = 18;

        # Hover avec délai personnalisé  
        hover = {
          delay = 200;
          reveal = [ "close" ];
        };
      };
    };
  };
}
