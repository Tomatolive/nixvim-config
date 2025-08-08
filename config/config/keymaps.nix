{
  # =====================================================================
  # KEYMAPS COMPLETS - Configuration JKLM et organisation par groupes
  # VERSION NETTOYÉE - Nixvim gère le LSP automatiquement
  # =====================================================================

  keymaps = [
    # ===== MOUVEMENT CUSTOM (JKLM au lieu de HJKL) =====
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "j";
      action = "h";
      options.desc = "Move left";
    }
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "k";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        desc = "Move down";
        expr = true;
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<Down>";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        desc = "Move down";
        expr = true;
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "l";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        desc = "Move up";
        expr = true;
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<Up>";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        desc = "Move up";
        expr = true;
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "m";
      action = "l";
      options.desc = "Move right";
    }

    # Remap mark key
    {
      mode = "n";
      key = "§";
      action = "m";
      options.desc = "Set mark";
    }

    # ===== NAVIGATION FENÊTRES (adapté pour JKLM) =====
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>h";
      options.desc = "Go to left window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>j";
      options.desc = "Go to lower window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>k";
      options.desc = "Go to upper window";
    }
    {
      mode = "n";
      key = "<C-m>";
      action = "<C-w>l";
      options.desc = "Go to right window";
    }

    # ===== DÉPLACER LIGNES (adapté pour JKLM) =====
    {
      mode = "n";
      key = "<A-k>";
      action = "<cmd>execute 'move .+' . v:count1<cr>==";
      options.desc = "Move line down";
    }
    {
      mode = "n";
      key = "<A-l>";
      action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==";
      options.desc = "Move line up";
    }
    {
      mode = "i";
      key = "<A-k>";
      action = "<esc><cmd>m .+1<cr>==gi";
      options.desc = "Move line down";
    }
    {
      mode = "i";
      key = "<A-l>";
      action = "<esc><cmd>m .-2<cr>==gi";
      options.desc = "Move line up";
    }
    {
      mode = "v";
      key = "<A-k>";
      action = ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv";
      options.desc = "Move selection down";
    }
    {
      mode = "v";
      key = "<A-l>";
      action = ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv";
      options.desc = "Move selection up";
    }

    # ===== AMÉLIORATIONS DE BASE =====
    {
      mode = "n";
      key = "n";
      action = "nzz";
      options.desc = "Next search result (centered)";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzz";
      options.desc = "Previous search result (centered)";
    }
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<cr>";
      options.desc = "Clear search highlight";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "p";
      action = "<Plug>(YankyPutAfter)";
      options.desc = "Put After";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "P";
      action = "<Plug>(YankyPutBefore)";
      options.desc = "Put Before";
    }

    # ===== MODE INSERTION =====
    {
      mode = "i";
      key = "jj";
      action = "<ESC>";
      options.desc = "Exit insert mode";
    }
    {
      mode = "i";
      key = "<C-d>";
      action = "<ESC>ddi";
      options.desc = "Delete line";
    }
    {
      mode = "i";
      key = "<C-b>";
      action = "<ESC>^i";
      options.desc = "Beginning of line";
    }
    {
      mode = "i";
      key = "<C-e>";
      action = "<End>";
      options.desc = "End of line";
    }

    # ===== NAVIGATION BUFFERS =====
    {
      mode = "n";
      key = "<S-TAB>";
      action = "<cmd>bprevious<cr>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "<TAB>";
      action = "<cmd>bnext<cr>";
      options.desc = "Next buffer";
    }

    # ===== TERMINAL =====
    {
      mode = "t";
      key = "<C-x>";
      action = "<C-\\><C-N>";
      options.desc = "Exit terminal mode";
    }

    # ===== SAUVEGARDE ET QUITTER =====
    {
      mode = "n";
      key = "<C-s>";
      action = "<cmd>w<cr>";
      options.desc = "Save file";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>q<cr>";
      options.desc = "Quit";
    }
    {
      mode = "n";
      key = "<leader>Q";
      action = "<cmd>qa!<cr>";
      options.desc = "Quit all (force)";
    }

    # ===== INDENTATION =====
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options.desc = "Decrease indent";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options.desc = "Increase indent";
    }

    # ===== SÉLECTION =====
    {
      mode = "n";
      key = "<C-a>";
      action = "ggVG";
      options.desc = "Select all";
    }

    # ===== REDIMENSIONNEMENT FENÊTRES =====
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<cr>";
      options.desc = "Increase window height";
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<cr>";
      options.desc = "Decrease window height";
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<cr>";
      options.desc = "Decrease window width";
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<cr>";
      options.desc = "Increase window width";
    }

    # =====================================================================
    # LEADER MAPPINGS - Organisés par fonctionnalité - VERSION SIMPLIFIÉE
    # =====================================================================

    # ===== DROPBAR  =====
    {
      mode = "n";
      key = "<leader><tab>";
      action.__raw = ''
        function()
          require('dropbar.api').pick()
        end
      '';
      options.desc = "Pick Symbol (Interactive)";
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

    # ===== GIT GROUP - <leader>g =====
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>lua Snacks.lazygit()<cr>";
      options.desc = "Lazygit";
    }
    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>Git commit<cr>";
      options.desc = "Git Commit";
    }
    {
      mode = "n";
      key = "<leader>gp";
      action = "<cmd>Git push<cr>";
      options.desc = "Git Push";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Git blame<cr>";
      options.desc = "Git Blame";
    }
    {
      mode = "n";
      key = "<leader>gd";
      action.__raw = ''function() require("snacks").picker.git_diff() end'';
      options.desc = "Git Diff (hunks)";
    }
    {
      mode = "n";
      key = "<leader>gs";
      action.__raw = ''function() require("snacks").picker.git_status() end'';
      options.desc = "Git Status";
    }

    # Git hunks (gitsigns intégré automatiquement par Nixvim)
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ghs";
      action = "<cmd>Gitsigns stage_hunk<CR>";
      options.desc = "Stage Hunk";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ghr";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options.desc = "Reset Hunk";
    }

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

    # ===== CODE GROUP - <leader>c =====
    {
      mode = "n";
      key = "<leader>ca";
      action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
      options.desc = "Code Actions";
    }
    {
      mode = "n";
      key = "<leader>cr";
      action = "<cmd>lua vim.lsp.buf.rename()<cr>";
      options.desc = "Rename Symbol";
    }
    {
      mode = "n";
      key = "<leader>cf";
      action = "<cmd>lua require('conform').format()<cr>";
      options.desc = "Format";
    }
    {
      mode = "n";
      key = "<leader>cd";
      action = "<cmd>lua vim.diagnostic.open_float()<cr>";
      options.desc = "Line Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>cD";
      action = "<cmd>lua vim.diagnostic.setloclist()<cr>";
      options.desc = "Buffer Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>cl";
      action.__raw = ''
        function()
          vim.lsp.codelens.run()
        end
      '';
      options.desc = "Run Code Lens";
    }
    {
      mode = "n";
      key = "<leader>cL";
      action.__raw = ''
        function()
          vim.lsp.codelens.refresh()
        end
      '';
      options.desc = "Refresh Code Lens";
    }

    # ===== DIAGNOSTICS GROUP - <leader>x =====
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>copen<cr>";
      options.desc = "Quickfix List";
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>lopen<cr>";
      options.desc = "Location List";
    }
    # Diagnostics (le plus utile - toujours des résultats)
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
    # Diagnostics buffer courant (toujours utile)
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    # Symboles LSP (utile avec LSP)
    {
      mode = "n";
      key = "<leader>xs";
      action = "<cmd>Trouble symbols toggle<cr>";
      options.desc = "Symbols (Trouble)";
    }

    # ===== TERMINAL GROUP - <leader>t =====
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>lua Snacks.terminal.toggle()<cr>";
      options.desc = "Toggle Terminal";
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

    # =====================================================================
    # NAVIGATION - g, [, ], z prefixes - Nixvim configure automatiquement
    # =====================================================================

    # Navigation diagnostics
    {
      mode = "n";
      key = "[d";
      action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
      options.desc = "Previous Diagnostic";
    }
    {
      mode = "n";
      key = "]d";
      action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
      options.desc = "Next Diagnostic";
    }

    # Navigation buffers
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<cr>";
      options.desc = "Prev Buffer";
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<cr>";
      options.desc = "Next Buffer";
    }

    # Navigation hunks (gitsigns configure automatiquement)
    {
      mode = "n";
      key = "]h";
      action.__raw = ''
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            require("gitsigns").nav_hunk("next")
          end
        end
      '';
      options.desc = "Next Hunk";
    }
    {
      mode = "n";
      key = "[h";
      action.__raw = ''
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            require("gitsigns").nav_hunk("prev")
          end
        end
      '';
      options.desc = "Prev Hunk";
    }

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

    # ===== WHICH-KEY =====
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
  # PAS D'EXTRA CONFIG LUA - Nixvim gère tout automatiquement !
  # =====================================================================
}
