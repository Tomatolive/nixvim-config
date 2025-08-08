{
  plugins = {
    # =====================================================================
    # SNACKS.NVIM - Configuration COMPLÈTE avec TOUS les modules activés
    # =====================================================================
    snacks = {
      enable = true;

      settings = {
        # =====================================================================
        # MODULES PRINCIPAUX - Configuration conservative (conflits résolus)
        # =====================================================================

        # Performance & Files
        bigfile.enabled = true; # Gestion intelligente des gros fichiers
        quickfile.enabled = true; # Ouverture rapide des fichiers fréquents

        # UI & Navigation
        explorer.enabled = true; # Explorateur de fichiers moderne
        picker.enabled = true; # Système de picker unifié
        dashboard.enabled = true; # Dashboard d'accueil

        # Édition - Configuration conservative pour éviter conflits
        indent.enabled = true; # Guides d'indentation (animations désactivées)
        scope.enabled = true; # Mise en évidence du scope actuel
        statuscolumn.enabled = true; # Colonne de statut améliorée

        # Interface utilisateur
        input.enabled = true; # Inputs améliorés avec popup
        notifier.enabled = true; # Système de notifications moderne

        # Navigation & Scroll
        scroll.enabled = true; # Scroll fluide

        # Git intégration
        gitbrowse.enabled = true; # Navigation Git dans le navigateur
        lazygit.enabled = true; # Interface Lazygit intégrée
        git.enabled = true; # Utilitaires Git divers

        # Terminal & Utils
        terminal.enabled = true; # Terminal flottant intégré
        toggle.enabled = true; # Système de toggle unifié

        # Utilities
        bufdelete.enabled = true; # Suppression intelligente de buffers
        rename.enabled = true; # Renommage de fichiers amélioré

        # =====================================================================
        # MODULES AVANCÉS - Configuration conservative
        # =====================================================================

        # Productivité (safe)
        scratch.enabled = true; # Buffers temporaires/scratch
        zen.enabled = true; # Mode zen/focus

        # Développement & Debug
        profiler.enabled = true; # Profiler de performance Neovim

        # =====================================================================
        # MODULES DÉSACTIVÉS → Maintenant avec toggles !
        # =====================================================================

        # RÉACTIVÉS : Maintenant contrôlés par les toggles
        animate.enabled = true; # Toggle: <leader>uA
        dim.enabled = true; # Toggle: <leader>sd
        words.enabled = true; # Toggle: <leader>uw (si pas de conflit)

        # Toujours désactivés (pas de toggle utile)
        image.enabled = false; # Pas essentiel
        layout.enabled = false; # Trop complexe

        # =====================================================================
        # CONFIGURATION DASHBOARD EXISTANTE
        # =====================================================================
        dashboard = {
          preset = {
            header = [
              "
I use                                                                
 ██████   █████                   █████   █████  ███                  
░░██████ ░░███                   ░░███   ░░███  ░░░                   
 ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   
 ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  
 ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  
 ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  
 █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ 
░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  
                                                                  btw 
"
            ];
            keys = [
              {
                icon = " ";
                key = "f";
                desc = "Find File";
                action = ":lua Snacks.dashboard.pick('files')";
              }
              {
                icon = " ";
                key = "n";
                desc = "New File";
                action = ":ene | startinsert";
              }
              {
                icon = " ";
                key = "g";
                desc = "Find Text";
                action = ":lua Snacks.dashboard.pick('live_grep')";
              }
              {
                icon = " ";
                key = "r";
                desc = "Recent Files";
                action = ":lua Snacks.dashboard.pick('oldfiles')";
              }
              {
                icon = " ";
                key = "s";
                desc = "Sessions";
                action.__raw = "function() require('persistence').select() end";
              }
              {
                icon = " ";
                key = "q";
                desc = "Quit";
                action = ":qa";
              }
            ];
          };
          sections = [
            { section = "header"; }
            {
              section = "keys";
              gap = 1;
              padding = 1;
            }
            {
              section = "recent_files";
              icon = " ";
              title = "Recent Files";
              padding = 1;
            }
            {
              section = "projects";
              icon = " ";
              title = "Projects";
              padding = 1;
            }
          ];
        };

        # =====================================================================
        # CONFIGURATION PICKER OPTIMISÉE
        # =====================================================================
        picker = {
          sources = {
            explorer = {
              follow_file = false; # Désactive le file watching problématique
              watch = false; # Désactiver tous les watchers
            };
          };
        };

        # =====================================================================
        # CONFIGURATION STYLES COHÉRENTS (modules actifs uniquement)
        # =====================================================================
        styles = {
          notification.border = "rounded";
          input.border = "rounded";
          terminal.border = "rounded";
          zen.border = "rounded";
          scratch.border = "rounded";
          profiler.border = "rounded";
        };

        # =====================================================================
        # CONFIGURATIONS SPÉCIFIQUES - Simplifiées (toggles gèrent le reste)
        # =====================================================================

        # Scroll - configuration conservative
        scroll = {
          animate = {
            duration = {
              step = 10;
              total = 150;
            }; # Plus rapide
            easing = "linear"; # Plus simple
          };
        };

        # Scratch - format markdown par défaut
        scratch = {
          name = "scratch";
          ft = "markdown";
        };

        # Zen - configuration simple
        zen = {
          toggles = {
            dim = true; # Intégration avec dim (maintenant réactivé)
            git_signs = false;
            mini_diff = false;
          };
          zoom = {
            width = 120;
            height = 1;
          };
        };
      };

      luaConfig.post = ''
        Snacks.toggle.option("number", { name = "Line Numbers" }):map("<leader>ul")
        Snacks.toggle.option("relativenumber", { name = "Relative Numbers" }):map("<leader>ur") 
        Snacks.toggle.option("wrap", { name = "Word Wrap" }):map("<leader>uw")
        Snacks.toggle.indent():map("<leader>ug")  -- Toggle indent animations
        Snacks.toggle.zen():map("<leader>uz")     -- Toggle zen mode
        Snacks.toggle.dim():map("<leader>uD")     -- Toggle dim
        Snacks.toggle.option("spell", { name = "Spell Check" }):map("<leader>us")
        Snacks.toggle.diagnostics():map("<leader>ud")  -- Toggle diagnostics
        Snacks.toggle.option("conceallevel", { 
          off = 0, 
          on = 2, 
          name = "Conceal Level" 
        }):map("<leader>uc")
        Snacks.toggle.scroll():map("<leader>uS")      -- Toggle smooth scroll
        Snacks.toggle.words():map("<leader>uW")       -- Toggle word highlights (pas de conflit)
        Snacks.toggle.animate():map("<leader>ua")     -- Toggle animations globales
        Snacks.toggle.option("signcolumn", {
          off = "no",
          on = "yes", 
          name = "Sign Column"
        }):map("<leader>uG")
        Snacks.toggle.option("list", { name = "List Chars" }):map("<leader>uL")
        Snacks.toggle.treesitter():map("<leader>uT")  -- Toggle treesitter
        Snacks.toggle.inlay_hints():map("<leader>uh")
      '';
    };

    # Telescope déjà configuré ailleurs, juste s'assurer qu'il est activé
    telescope.enable = true;
  };
}
