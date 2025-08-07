{ pkgs, ... }:
{
  # =====================================================================
  # PLUGINS EDITEUR - Configuration minimaliste
  # =====================================================================

  plugins = {
    # =================================================================
    # BETTER-ESCAPE - Sortie fluide du mode insertion
    # =================================================================
    better-escape = {
      enable = true;
      # Défauts excellents : "jk" avec timeout intelligent
      # Pas de configuration nécessaire !
    };

    # =================================================================
    # LASTPLACE - Retour à la dernière position d'édition
    # =================================================================
    lastplace = {
      enable = true;
      # Plugin "zero config" - fonctionne immédiatement
      # Pas de configuration nécessaire !
    };

    # =================================================================
    # YANKY - Amélioration des fonctions yank/paste
    # =================================================================
    yanky = {
      enable = true;
      settings = {
        # Juste l'essentiel pour une meilleure UX
        highlight = {
          on_put = true;
          on_yank = true;
          timer = 150;
        };

        # Garde l'historique simple (pas de SQLite)
        ring = {
          history_length = 100;
          storage = "shada"; # Plus simple que SQLite
        };
      };
    };

    # =================================================================
    # SPIDER - Navigation améliorée par mots (w, e, b)
    # =================================================================
    spider = {
      enable = true;
      # Configuration minimale recommandée
      keymaps = {
        motions = {
          w = "w";
          e = "e";
          b = "b";
          ge = "ge";
        };
      };
    };

    # =================================================================
    # AUTO-SAVE - Sauvegarde automatique intelligente
    # =================================================================
    auto-save = {
      enable = true;
      settings = {
        # Configuration conservatrice et sûre
        enabled = true;
        noautocmd = true;

        # Déclencheurs intelligents
        trigger_events = {
          immediate_save = [
            "BufLeave"
            "FocusLost"
          ];
          defer_save = [
            "InsertLeave"
            "TextChanged"
          ];
          cancel_deferred_save = [ "InsertEnter" ];
        };

        # Conditions de sécurité
        conditions = {
          exists = true;
          filename_is_not = [ ];
          filetype_is_not = [ "oil" ]; # Évite conflit avec explorateurs
          modifiable = true;
        };

        # Pas trop agressif
        debounce_delay = 1000;
      };
    };

    # =================================================================
    # PERSISTENCE - Gestion de sessions simple (Folke)
    # =================================================================
    persistence = {
      enable = true;
      # Défauts parfaits : sauvegarde dans ~/.local/state/nvim/sessions
      # Pas de configuration nécessaire !
    };

    # =================================================================
    # TODO-COMMENTS - Highlight et gestion TODO/FIXME (Folke)
    # =================================================================
    todo-comments = {
      enable = true;
      # Défauts excellents : TODO, FIXME, HACK, WARN, PERF, NOTE avec couleurs
      # Pas de configuration nécessaire !
    };
  };

  # =====================================================================
  # DÉPENDANCES REQUISES
  # =====================================================================
  extraPlugins = with pkgs.vimPlugins; [
    plenary-nvim # Requis pour todo-comments.nvim
  ];

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE MINIMALE
  # =====================================================================
  extraConfigLua = ''
    -- Auto-save : notification discrète uniquement si erreur
    vim.api.nvim_create_autocmd("User", {
      pattern = "AutoSaveWritePre",
      callback = function()
        -- Validation silencieuse avant sauvegarde
        if vim.bo.readonly or not vim.bo.modifiable then
          require("auto-save").off()  
        end
      end,
    })

    -- Yanky : intégration telescope si disponible
    pcall(function()
      require("telescope").load_extension("yank_history")
    end)
  '';
}
