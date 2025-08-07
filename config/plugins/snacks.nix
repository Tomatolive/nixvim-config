{
  plugins = {
    # =====================================================================
    # SNACKS.NVIM - Configuration minimaliste (excellents défauts)
    # =====================================================================
    snacks = {
      enable = true;

      settings = {
        # La plupart des modules ont d'excellents défauts
        bigfile.enabled = true;
        explorer.enabled = true;
        indent.enabled = true;
        input.enabled = true;
        notifier.enabled = true;
        quickfile.enabled = true;
        scope.enabled = true;
        scroll.enabled = true;
        statuscolumn.enabled = true;
        words.enabled = true;
        terminal.enabled = true;
        gitbrowse.enabled = true;
        lazygit.enabled = true;

        dashboard = {
          enabled = true;
          preset =
            {
              header = ["
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
                { icon = " "; key = "n"; desc = "New File"; action = ":ene | startinsert"; }
                { icon = " "; key = "g"; desc = "Find Text"; action = ":lua Snacks.dashboard.pick('live_grep')"; }
                { icon = " "; key = "r"; desc = "Recent Files"; action = ":lua Snacks.dashboard.pick('oldfiles')"; }
                { icon = " "; key = "s"; desc = "Sessions"; action.__raw = "function() require('persistence').select() end"; }
                { icon = " "; key = "q"; desc = "Quit"; action = ":qa"; }
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

        # Seuls quelques ajustements nécessaires
        picker = {
          enabled = true;
          sources = {
            explorer = {
              follow_file = false; # Désactive le file watching problématique
              watch = false; # Désactiver tous les watchers
            };
          };
        };

        # Modules utiles supplémentaires
        bufdelete.enabled = true; # Suppression intelligente buffers (garde fenêtres)
        rename.enabled = true; # LSP rename amélioré (support neo-tree/mini.files)
        git.enabled = true; # Fonctions git diverses utiles
        toggle.enabled = true; # Toggle options rapidement

        # Modules optionnels (à activer selon préférence)
        dim.enabled = false; # Dim inactive code (comme Twilight) - peut ralentir
        scratch.enabled = false; # Scratch buffers - pas essentiel
        zen.enabled = false; # Mode zen - conflit potentiel avec autres plugins

        # Modules non recommandés
        # animate.enabled = false;   # Animations - problèmes performance
        # image.enabled = false;     # Affichage images - pas toujours utile
        # layout.enabled = false;    # Système complexe - pas essentiel
        # profiler.enabled = false;  # Debug uniquement
        # debug.enabled = false;     # Utilities debug
        # win - utilisé en interne

        # Juste les bordures pour cohérence
        styles = {
          notification.border = "rounded";
          input.border = "rounded";
          terminal.border = "rounded";
        };
      };
    };

    # Telescope déjà configuré ailleurs, juste s'assurer qu'il est activé
    telescope.enable = true;
  };
}
