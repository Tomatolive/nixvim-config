{
  # =====================================================================
  # KEYMAPS COMPLETS - Configuration JKLM et organisation par groupes
  # VERSION NETTOYÉE - Nixvim gère le LSP automatiquement
  # =====================================================================

  keymaps = [
    # ===== MOUVEMENT CUSTOM (JKLM au lieu de HJKL) =====
    {
      mode = [ "n" "v" "o" ];
      key = "j";
      action = "h";
      options.desc = "Move left";
    }
    {
      mode = [ "n" "v" "o" ];
      key = "k";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        desc = "Move down";
        expr = true;
        silent = true;
      };
    }
    {
      mode = [ "n" "v" ];
      key = "<Down>";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        desc = "Move down";
        expr = true;
        silent = true;
      };
    }
    {
      mode = [ "n" "v" "o" ];
      key = "l";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        desc = "Move up";
        expr = true;
        silent = true;
      };
    }
    {
      mode = [ "n" "v" ];
      key = "<Up>";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        desc = "Move up";
        expr = true;
        silent = true;
      };
    }
    {
      mode = [ "n" "v" "o" ];
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
      key = "<leader>fr";
      action = "<cmd>lua Snacks.picker.recent()<cr>";
      options.desc = "Recent Files";
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
      key = "<leader>gs";
      action = "<cmd>Git<cr>";
      options.desc = "Git Status";
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

    # Git hunks (gitsigns intégré automatiquement par Nixvim)
    {
      mode = [ "n" "v" ];
      key = "<leader>ghs";
      action = "<cmd>Gitsigns stage_hunk<CR>";
      options.desc = "Stage Hunk";
    }
    {
      mode = [ "n" "v" ];
      key = "<leader>ghr";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options.desc = "Reset Hunk";
    }

    # ===== BUFFER GROUP - <leader>b =====
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bdelete<cr>";
      options.desc = "Delete Buffer";
    }
    {
      mode = "n";
      key = "<leader>bs";
      action = "<cmd>w<cr>";
      options.desc = "Save Buffer";
    }

    # ===== CODE GROUP - <leader>c - VERSION SIMPLIFIÉE =====
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
      options.desc = "Rename";
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

    # ===== UI GROUP - <leader>u =====
    {
      mode = "n";
      key = "<leader>ul";
      action = "<cmd>set nu!<cr>";
      options.desc = "Toggle Line Numbers";
    }
    {
      mode = "n";
      key = "<leader>ur";
      action = "<cmd>set rnu!<cr>";
      options.desc = "Toggle Relative Numbers";
    }
    {
      mode = "n";
      key = "<leader>uw";
      action = "<cmd>set wrap!<cr>";
      options.desc = "Toggle Word Wrap";
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
