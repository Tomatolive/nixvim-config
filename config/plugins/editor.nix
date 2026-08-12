{ pkgs, ... }:
{
  # =====================================================================
  # PLUGINS EDITEUR - Configuration minimaliste
  # =====================================================================

  plugins = {

    smear-cursor = {
      enable = true;
      settings = {
        # Transparent background : couleur de fallback gruvbox
        transparent_bg_fallback_color = "#32302F";
        # Couleur du curseur (gruvbox fg)
        cursor_color = "#ebdbb2";

        # Activer l'animation en mode insert
        smear_insert_mode = true;

        # Ces options permettent l'option "Smooth cursor without smear"
        stiffness = 0.5;
        trailing_stiffness = 0.5;
        matrix_pixel_threshold = 0.5;
      };
    };

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
      settings = {
        # skipInsignificantPunctuation = true; # ignore ;, :, etc.
      };
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
    # TODO-COMMENTS - Highlight et gestion TODO/FIXME (Folke)
    # =================================================================
    todo-comments = {
      enable = true;
      # Défauts excellents : TODO, FIXME, HACK, WARN, PERF, NOTE avec couleurs
      # Pas de configuration nécessaire !
    };

    # =================================================================
    # AUTO-SAVE - Sauvegarde automatique intelligente
    # =================================================================
    auto-save = {
      enable = true;
      settings = {
        # Configuration conservatrice et sûre
        enabled = true;
        # noautocmd = true; # évite le formattage auto à chaque retour en mode normal

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
        debounce_delay = 135;
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

    precognition = {
      enable = false;
      settings.showBlankVirtLine = false;
    };

    flash.enable = true;

    hex.enable = true;
  };

  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "<leader>r"; group = "Persistence"; icon = { icon = ""; color = "blue"; }; }
    { __unkeyed-1 = "<leader>l"; group = "LanguageTool"; icon = { icon = " "; color = "green"; }; }
  ];

  # =====================================================================
  # DÉPENDANCES REQUISES
  # =====================================================================
  extraPlugins = with pkgs.vimPlugins; [
    plenary-nvim # Requis pour todo-comments.nvim

    (pkgs.vimUtils.buildVimPlugin {
      name = "languagetool-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "liba2k";
        repo = "languagetool.nvim";
        rev = "5a24ae8847b10d55eeaf53bed7444b3dddeec887";
        hash = "sha256-BkJUNBb8gTCzOAzL1/EI18lhKkzvLUtk8GujbDC3eKo=";
      };
    })
  ];

  extraPackages = with pkgs; [
    xxd # Pour hex
  ];

  keymaps = [
    {
      mode = [ "n" "x" ];
      key = "p";
      action = "<Plug>(YankyPutAfter)";
      options.desc = "Put After";
    }
    {
      mode = [ "n" "x" ];
      key = "P";
      action = "<Plug>(YankyPutBefore)";
      options.desc = "Put Before";
    }

    {
      mode = [ "n" "x" "o" ];
      key = "s";
      action.__raw = ''function() require("flash").jump() end'';
      options.desc = "Flash Jump";
    }
    {
      mode = [ "n" "x" "o" ];
      key = "S";
      action.__raw = ''function() require("flash").treesitter() end'';
      options.desc = "Flash Treesitter";
    }
    {
      mode = "o";
      key = "r";
      action.__raw = ''function() require("flash").remote() end'';
      options.desc = "Remote Flash";
    }
    {
      mode = [ "o" "x" ];
      key = "R";
      action.__raw = ''function() require("flash").treesitter_search() end'';
      options.desc = "Treesitter Search";
    }
    {
      mode = "c";
      key = "<c-s>";
      action.__raw = ''function() require("flash").toggle() end'';
      options.desc = "Toggle Flash Search";
    }
    {
      mode = [ "n" "x" "o" ];
      key = "<c-space>";
      action.__raw = ''
        function()
          require("flash").treesitter({
            actions = { ["<c-space>"] = "next", ["<BS>"] = "prev" }
          })
        end
      '';
      options.desc = "Treesitter incremental selection";
    }

    # ===== LANGUAGE GROUP - <leader>l =====
    {
      mode = "n";
      key = "<leader>lc";
      action = "<cmd>LTCheck<cr>";
      options.desc = "LT: Check line";
    }
    {
      mode = "v";
      key = "<leader>lc";
      action = ":LTCheck<cr>";
      options.desc = "LT: Check selection";
    }
    {
      mode = "n";
      key = "<leader>lb";
      action = "<cmd>LTCheckBuffer<cr>";
      options.desc = "LT: Check buffer";
    }
    {
      mode = "n";
      key = "<leader>lf";
      action = "<cmd>LTFix<cr>";
      options.desc = "LT: Show fixes";
    }
    {
      mode = "n";
      key = "<leader>lx";
      action = "<cmd>LTClear<cr>";
      options.desc = "LT: Clear diagnostics";
    }

    # ===== PASTE GROUP - <leader>p =====
    {
      mode = "n";
      key = "<leader>p";
      action = "<cmd>YankyRingHistory<cr>";
      options.desc = "Yank History";
    }

    # ===== PERSISTENCE/SESSION GROUP - <leader>r =====
    {
      mode = "n";
      key = "<leader>rs";
      action.__raw = ''function() require("persistence").load() end'';
      options.desc = "Restore Session";
    }
    {
      mode = "n";
      key = "<leader>rS";
      action.__raw = ''function() require("persistence").select() end'';
      options.desc = "Select Session";
    }
    {
      mode = "n";
      key = "<leader>rl";
      action.__raw = ''function() require("persistence").load({ last = true }) end'';
      options.desc = "Last Session";
    }
    {
      mode = "n";
      key = "<leader>rd";
      action.__raw = ''function() require("persistence").stop() end'';
      options.desc = "Don't Save Session";
    }

    # =====================================================================
    # NAVIGATION - g, [, ], z prefixes - Nixvim configure automatiquement
    # =====================================================================

    # Navigation dans l'historique
    {
      mode = "n";
      key = "[y";
      action = "<Plug>(YankyCycleForward)";
      options.desc = "Cycle Forward Yank";
    }
    {
      mode = "n";
      key = "]y";
      action = "<Plug>(YankyCycleBackward)";
      options.desc = "Cycle Backward Yank";
    }

    # Navigation TODO
    {
      mode = "n";
      key = "]t";
      action.__raw = ''function() require("todo-comments").jump_next() end'';
      options.desc = "Next Todo Comment";
    }
    {
      mode = "n";
      key = "[t";
      action.__raw = ''function() require("todo-comments").jump_prev() end'';
      options.desc = "Previous Todo Comment";
    }
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

    require("languagetool").setup({
      server_url = "https://languagetool.hexasec.io/tombdfapr1ShEQVfT0i4K6xN0tCUqTMinoC4L0x",
      language = "auto",
      severity = {
        typographical = vim.diagnostic.severity.HINT,
        grammar = vim.diagnostic.severity.WARN,
        misspelling = vim.diagnostic.severity.ERROR,
        style = vim.diagnostic.severity.INFO,
        default = vim.diagnostic.severity.WARN,
      },
    })
  '';
}
