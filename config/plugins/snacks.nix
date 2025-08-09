{
  plugins = {
    # =====================================================================
    # SNACKS.NVIM - Configuration SIMPLIFIÉE (50% moins de code)
    # =====================================================================
    snacks = {
      enable = true;

      settings = {
        # =====================================================================
        # MODULES ESSENTIELS SEULEMENT - Configuration ultra-simple
        # =====================================================================

        # Core functionality (toujours nécessaires)
        bigfile.enabled = true;
        quickfile.enabled = true;
        picker.enabled = true;
        dashboard.enabled = true;
        notifier.enabled = true;
        terminal.enabled = true;
        bufdelete.enabled = true;
        explorer.enabled = true;

        # UI enhancements (avec défauts excellents)
        indent.enabled = true;
        scope.enabled = true;
        statuscolumn.enabled = true;
        input.enabled = true;
        scroll.enabled = true;

        # Git & Utils (configuration native)
        git.enabled = true;
        gitbrowse.enabled = true;
        lazygit.enabled = true;
        rename.enabled = true;
        toggle.enabled = true;

        # Productivité (défauts parfaits)
        scratch.enabled = true;
        zen.enabled = true;
        profiler.enabled = true;

        # Fonctionnalités optionnelles (contrôlées par toggles)
        animate.enabled = true;
        dim.enabled = true;
        words.enabled = true;

        # =====================================================================
        # CONFIGURATION DASHBOARD - GARDÉE (excellente et personnalisée)
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
                icon = " ";
                key = "f";
                desc = "Find File";
                action = ":lua Snacks.dashboard.pick('files')";
              }
              {
                icon = " ";
                key = "n";
                desc = "New File";
                action = ":ene | startinsert";
              }
              {
                icon = " ";
                key = "g";
                desc = "Find Text";
                action = ":lua Snacks.dashboard.pick('live_grep')";
              }
              {
                icon = " ";
                key = "r";
                desc = "Recent Files";
                action = ":lua Snacks.dashboard.pick('oldfiles')";
              }
              {
                icon = " ";
                key = "s";
                desc = "Sessions";
                action.__raw = "function() require('persistence').select() end";
              }
              {
                icon = " ";
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
        # STYLES GLOBAUX SIMPLIFIÉS - Une seule ligne !
        # =====================================================================
        styles._global.border = "rounded";

        # =====================================================================
        # CONFIGURATIONS SPÉCIFIQUES MINIMALES
        # =====================================================================

        # Picker - juste le fix essentiel
        picker.sources.explorer = {
          follow_file = false; # Désactive le file watching problématique
          watch = false; # Désactiver tous les watchers
        };

        # Scratch - format par défaut
        scratch.ft = "markdown";
      };

      # =====================================================================
      # TOGGLES COMPLETS - GARDÉS (excellente fonctionnalité)
      # =====================================================================
      luaConfig.post = ''
        -- UI toggles
        Snacks.toggle.option("number", { name = "Line Numbers" }):map("<leader>ul")
        Snacks.toggle.option("relativenumber", { name = "Relative Numbers" }):map("<leader>ur") 
        Snacks.toggle.option("wrap", { name = "Word Wrap" }):map("<leader>uw")
        Snacks.toggle.option("spell", { name = "Spell Check" }):map("<leader>us")
        Snacks.toggle.option("conceallevel", { off = 0, on = 2, name = "Conceal Level" }):map("<leader>uc")
        Snacks.toggle.option("signcolumn", { off = "no", on = "yes", name = "Sign Column" }):map("<leader>uG")
        Snacks.toggle.option("list", { name = "List Chars" }):map("<leader>uL")

        -- Feature toggles
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.zen():map("<leader>uz")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle.scroll():map("<leader>uS")
        Snacks.toggle.words():map("<leader>uW")
        Snacks.toggle.animate():map("<leader>ua")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
      '';
    };

    telescope.enable = true;
  };

  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "<leader>b"; group = "Buffers"; }
    { __unkeyed-1 = "<leader>f"; group = "Find/File"; }
    { __unkeyed-1 = "<leader>n"; group = "Notifications"; }
    { __unkeyed-1 = "<leader>s"; group = "Search"; }
    { __unkeyed-1 = "<leader>t"; group = "Terminal"; }
    { __unkeyed-1 = "<leader>u"; group = "UI"; }
  ];

  keymaps = [
    # ===== BUFFER GROUP - <leader>b =====
    {
      mode = "n";
      key = "<leader>bd";
      action.__raw = ''
        function()
          require("snacks").bufdelete()
        end
      '';
      options.desc = "Delete Buffer (smart)";
    }
    {
      mode = "n";
      key = "<leader>bs";
      action.__raw = ''
        function()
          require("snacks").scratch()
        end
      '';
      options.desc = "Scratch Buffer";
    }
    {
      mode = "n";
      key = "<leader>bS";
      action.__raw = ''
        function()
          require("snacks").scratch.select()
        end
      '';
      options.desc = "Select Scratch Buffer";
    }

    # ===== EXPLORATEUR =====
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>lua Snacks.explorer()<cr>";
      options.desc = "Explorer";
    }

    # ===== FIND/FILE GROUP - <leader>f =====
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>lua Snacks.picker.files()<cr>";
      options.desc = "Find Files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>lua Snacks.picker.grep()<cr>";
      options.desc = "Find Text (Grep)";
    }
    {
      mode = "n";
      key = "<leader>fn";
      action = "<cmd>ene | startinsert<cr>";
      options.desc = "New File";
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = "<cmd>lua Snacks.picker.recent()<cr>";
      options.desc = "Recent Files";
    }
    {
      mode = "n";
      key = "<leader>fR";
      action.__raw = ''
        function()
          require("snacks").rename.rename_file()
        end
      '';
      options.desc = "Rename File";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>lua Snacks.picker.buffers()<cr>";
      options.desc = "Find Buffers";
    }
    {
      mode = "n";
      key = "<leader>fc";
      action = "<cmd>lua Snacks.picker.command_history()<cr>";
      options.desc = "Command History";
    }

    # ===== NOTIFICATIONS GROUP - <leader>n =====
    {
      mode = "n";
      key = "<leader>nh";
      action = "<cmd>lua Snacks.notifier.show_history()<cr>";
      options.desc = "Show History";
    }
    {
      mode = "n";
      key = "<leader>nd";
      action = "<cmd>lua Snacks.notifier.hide()<cr>";
      options.desc = "Dismiss All";
    }

    # ===== SEARCH GROUP - <leader>s =====
    # Buffer and Grep
    {
      mode = "n";
      key = "<leader>sb";
      action.__raw = ''function() require("snacks").picker.lines() end'';
      options.desc = "Buffer Lines";
    }
    {
      mode = "n";
      key = "<leader>sB";
      action.__raw = ''function() require("snacks").picker.grep_buffers() end'';
      options.desc = "Grep Open Buffers";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>sw";
      action.__raw = ''function() require("lazyvim.util").pick("grep_word")() end'';
      options.desc = "Visual selection or word (Root Dir)";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>sW";
      action.__raw = ''function() require("lazyvim.util").pick("grep_word", { root = false })() end'';
      options.desc = "Visual selection or word (cwd)";
    }

    # Search operations
    {
      mode = "n";
      key = "<leader>s\"";
      action.__raw = ''function() require("snacks").picker.registers() end'';
      options.desc = "Registers";
    }
    {
      mode = "n";
      key = "<leader>s/";
      action.__raw = ''function() require("snacks").picker.search_history() end'';
      options.desc = "Search History";
    }
    {
      mode = "n";
      key = "<leader>sc";
      action.__raw = ''function() require("snacks").picker.command_history() end'';
      options.desc = "Command History";
    }
    {
      mode = "n";
      key = "<leader>sC";
      action.__raw = ''function() require("snacks").picker.commands() end'';
      options.desc = "Commands";
    }
    {
      mode = "n";
      key = "<leader>sd";
      action.__raw = ''function() require("snacks").picker.diagnostics() end'';
      options.desc = "Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>sD";
      action.__raw = ''function() require("snacks").picker.diagnostics_buffer() end'';
      options.desc = "Buffer Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>sh";
      action.__raw = ''function() require("snacks").picker.help() end'';
      options.desc = "Help Pages";
    }
    {
      mode = "n";
      key = "<leader>sH";
      action.__raw = ''function() require("snacks").picker.highlights() end'';
      options.desc = "Highlights";
    }
    {
      mode = "n";
      key = "<leader>si";
      action.__raw = ''function() require("snacks").picker.icons() end'';
      options.desc = "Icons";
    }
    {
      mode = "n";
      key = "<leader>sj";
      action.__raw = ''function() require("snacks").picker.jumps() end'';
      options.desc = "Jumps";
    }
    {
      mode = "n";
      key = "<leader>sk";
      action.__raw = ''function() require("snacks").picker.keymaps() end'';
      options.desc = "Keymaps";
    }
    {
      mode = "n";
      key = "<leader>sl";
      action.__raw = ''function() require("snacks").picker.loclist() end'';
      options.desc = "Location List";
    }
    {
      mode = "n";
      key = "<leader>sM";
      action.__raw = ''function() require("snacks").picker.man() end'';
      options.desc = "Man Pages";
    }
    {
      mode = "n";
      key = "<leader>sm";
      action.__raw = ''function() require("snacks").picker.marks() end'';
      options.desc = "Marks";
    }
    {
      mode = "n";
      key = "<leader>sR";
      action.__raw = ''function() require("snacks").picker.resume() end'';
      options.desc = "Resume";
    }
    {
      mode = "n";
      key = "<leader>su";
      action.__raw = ''function() require("snacks").picker.undo() end'';
      options.desc = "Undotree";
    }

    # ===== TERMINAL GROUP - <leader>t =====
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>lua Snacks.terminal.toggle()<cr>";
      options.desc = "Toggle Terminal";
    }
  ];
}
