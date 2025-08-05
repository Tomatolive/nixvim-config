{
  # =====================================================================
  # KEYMAPS COMPLETS - Configuration JKLM et organisation par groupes
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

    # Déplacer buffers
    {
      mode = "n";
      key = "[B";
      action = "<cmd>BufferLineMovePrev<cr>";
      options.desc = "Move buffer prev";
    }
    {
      mode = "n";
      key = "]B";
      action = "<cmd>BufferLineMoveNext<cr>";
      options.desc = "Move buffer next";
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
    # LEADER MAPPINGS - Organisés par fonctionnalité
    # =====================================================================

    # ===== EXPLORATEUR =====
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>lua Snacks.explorer()<cr>";
      options.desc = "Explorer";
    }
    {
      mode = "n";
      key = "<leader>E";
      action = "<cmd>lua Snacks.explorer({ focus = 'files' })<cr>";
      options.desc = "Explorer (Focus Files)";
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
    {
      mode = "n";
      key = "<leader>fs";
      action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
      options.desc = "LSP Symbols";
    }
    {
      mode = "n";
      key = "<leader>fS";
      action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>";
      options.desc = "LSP Workspace Symbols";
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
      key = "<leader>gG";
      action = "<cmd>lua Snacks.lazygit({cwd = vim.uv.cwd()})<cr>";
      options.desc = "Lazygit (cwd)";
    }
    {
      mode = "n";
      key = "<leader>gf";
      action = "<cmd>lua Snacks.lazygit.log_file()<cr>";
      options.desc = "Lazygit Current File History";
    }
    {
      mode = "n";
      key = "<leader>gl";
      action = "<cmd>lua Snacks.lazygit.log()<cr>";
      options.desc = "Lazygit Log";
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
      key = "<leader>gP";
      action = "<cmd>Git pull<cr>";
      options.desc = "Git Pull";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Git blame<cr>";
      options.desc = "Git Blame";
    }
    {
      mode = "n";
      key = "<leader>gB";
      action.__raw = ''
        function()
          require("gitsigns").toggle_current_line_blame()
        end
      '';
      options.desc = "Toggle Git Blame Line";
    }
    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd>DiffviewOpen<cr>";
      options.desc = "DiffView Open";
    }
    {
      mode = "n";
      key = "<leader>gD";
      action = "<cmd>DiffviewClose<cr>";
      options.desc = "DiffView Close";
    }
    {
      mode = "n";
      key = "<leader>gh";
      action = "<cmd>DiffviewFileHistory<cr>";
      options.desc = "File History";
    }
    {
      mode = "n";
      key = "<leader>gH";
      action = "<cmd>DiffviewFileHistory %<cr>";
      options.desc = "Current File History";
    }

    # Actions hunks
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
    {
      mode = "n";
      key = "<leader>ghS";
      action.__raw = ''
        require("gitsigns").stage_buffer
      '';
      options.desc = "Stage Buffer";
    }
    {
      mode = "n";
      key = "<leader>ghu";
      action.__raw = ''
        require("gitsigns").undo_stage_hunk
      '';
      options.desc = "Undo Stage Buffer";
    }
    {
      mode = "n";
      key = "<leader>ghR";
      action.__raw = ''
        require("gitsigns").reset_buffer
      '';
      options.desc = "Reset Buffer";
    }
    {
      mode = "n";
      key = "<leader>ghp";
      action.__raw = ''
        require("gitsigns").preview_hunk_inline
      '';
      options.desc = "Preview Hunk Inline";
    }
    {
      mode = "n";
      key = "<leader>ghP";
      action.__raw = ''
        require("gitsigns").preview_hunk
      '';
      options.desc = "Preview Hunk";
    }

    # Blame
    {
      mode = "n";
      key = "<leader>ghb";
      action.__raw = ''
        function()
          require("gitsigns").blame_line({ full = true })
        end
      '';
      options.desc = "Blame Line";
    }
    {
      mode = "n";
      key = "<leader>ghB";
      action.__raw = ''
        function()
          require("gitsigns").blame_line()
        end
      '';
      options.desc = "Blame Buffer";
    }

    # Diff
    {
      mode = "n";
      key = "<leader>ghd";
      action.__raw = ''
        require("gitsigns").diffthis
      '';
      options.desc = "Diff This";
    }
    {
      mode = "n";
      key = "<leader>ghD";
      action.__raw = ''
        function()
          require("gitsigns").diffthis("~")
        end
      '';
      options.desc = "Diff This ~";
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
      key = "<leader>bD";
      action = "<cmd>%bdelete|edit#|bdelete#<cr>";
      options.desc = "Delete All Buffers";
    }
    {
      mode = "n";
      key = "<leader>bl";
      action = "<cmd>lua Snacks.picker.buffers()<cr>";
      options.desc = "List Buffers";
    }
    {
      mode = "n";
      key = "<leader>bs";
      action = "<cmd>w<cr>";
      options.desc = "Save Buffer";
    }
    {
      mode = "n";
      key = "<leader>br";
      action = "<cmd>e!<cr>";
      options.desc = "Reload Buffer";
    }

    # ===== CODE GROUP - <leader>c =====
    {
      mode = "n";
      key = "<leader>ca";
      action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
      options.desc = "Code Action";
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
      action = "<cmd>lua vim.lsp.buf.format()<cr>";
      options.desc = "Format";
    }

    # ===== UI GROUP - <leader>u =====
    {
      mode = "n";
      key = "<leader>uG";
      action.__raw = ''
        function()
          local gs = require("gitsigns")
          local config = require("gitsigns.config").config
          local current = config.signcolumn
          gs.toggle_signs(not current)
          require("snacks").notify(
            "Git signs " .. (not current and "enabled" or "disabled"), 
            { title = "Git Signs" }
          )
        end
      '';
      options.desc = "Toggle Git Signs";
    }
    {
      mode = "n";
      key = "<leader>un";
      action = "<cmd>lua Snacks.notifier.hide()<cr>";
      options.desc = "Dismiss Notifications";
    }
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
    {
      mode = "n";
      key = "<leader>xd";
      action = "<cmd>lua vim.diagnostic.setloclist()<cr>";
      options.desc = "Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>xe";
      action = "<cmd>lua vim.diagnostic.open_float()<cr>";
      options.desc = "Show Line Diagnostics";
    }

    # ===== TERMINAL GROUP - <leader>t =====
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>lua Snacks.terminal.toggle()<cr>";
      options.desc = "Toggle Terminal";
    }
    {
      mode = "n";
      key = "<leader>th";
      action = "<cmd>lua Snacks.terminal.open(nil, {position = 'bottom'})<cr>";
      options.desc = "Horizontal Terminal";
    }
    {
      mode = "n";
      key = "<leader>tv";
      action = "<cmd>lua Snacks.terminal.open(nil, {position = 'right'})<cr>";
      options.desc = "Vertical Terminal";
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

    # ===== SEARCH GROUP - <leader>s (pour Snacks/Noice) =====
    {
      mode = "n";
      key = "<leader>snh";
      action = "<cmd>Noice telescope<cr>";
      options.desc = "Noice Message History";
    }
    {
      mode = "n";
      key = "<leader>sns";
      action = "<cmd>Noice stats<cr>";
      options.desc = "Noice Stats";
    }

    # =====================================================================
    # NAVIGATION - g, [, ], z prefixes
    # =====================================================================

    # ===== GOTO NAVIGATION =====
    {
      mode = "n";
      key = "gd";
      action = "<cmd>lua Snacks.picker.lsp_definitions()<cr>";
      options.desc = "Goto Definition";
    }
    {
      mode = "n";
      key = "gD";
      action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
      options.desc = "Goto Declaration";
    }
    {
      mode = "n";
      key = "gr";
      action = "<cmd>lua Snacks.picker.lsp_references()<cr>";
      options.desc = "Goto References";
    }
    {
      mode = "n";
      key = "gi";
      action = "<cmd>lua Snacks.picker.lsp_implementations()<cr>";
      options.desc = "Goto Implementation";
    }
    {
      mode = "n";
      key = "gt";
      action = "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>";
      options.desc = "Goto Type Definition";
    }
    {
      mode = "n";
      key = "gh";
      action = "<cmd>lua vim.lsp.buf.hover()<cr>";
      options.desc = "Hover Documentation";
    }

    # ===== NAVIGATION PRÉCÉDENT/SUIVANT =====
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
    {
      mode = "n";
      key = "[b";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options.desc = "Prev Buffer";
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>BufferLineCycleNext<cr>";
      options.desc = "Next Buffer";
    }
    {
      mode = "n";
      key = "]h";
      action.__raw = ''
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
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
            gs.nav_hunk("prev")
          end
        end
      '';
      options.desc = "Prev Hunk";
    }
    {
      mode = "n";
      key = "]H";
      action.__raw = ''
        function()
          gs.nav_hunk("last")
        end
      '';
      options.desc = "Last Hunk";
    }
    {
      mode = "n";
      key = "[H";
      action.__raw = ''
        function()
          gs.nav_hunk("first")
        end
      '';
      options.desc = "First Hunk";
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
    {
      mode = "n";
      key = "<leader>K";
      action.__raw = ''
        function()
          require("which-key").show({ global = true })
        end
      '';
      options.desc = "Show All Keymaps";
    }

    # =====================================================================
    # KEYMAPS SPÉCIFIQUES AUX LANGAGES (FileType-specific)
    # =====================================================================

    # ===== KEYMAPS NIX - <leader>l =====
    {
      mode = "n";
      key = "<leader>lf";
      action.__raw = ''
        function()
          if vim.bo.filetype == "nix" then
            require('conform').format({ 
              async = true, 
              timeout_ms = 2000,
              lsp_fallback = false
            })
          end
        end
      '';
      options.desc = "Format Nix (Fast)";
    }
    {
      mode = "n";
      key = "<leader>lR";
      action.__raw = ''
        function()
          if vim.bo.filetype == "nix" then
            vim.lsp.buf.rename()
          end
        end
      '';
      options.desc = "Rename (Nix)";
    }
    {
      mode = "n";
      key = "<leader>ld";
      action.__raw = ''
        function()
          if vim.bo.filetype == "nix" then
            vim.lsp.buf.definition({ timeout_ms = 2000 })
          end
        end
      '';
      options.desc = "Definition (Fast)";
    }
    {
      mode = "n";
      key = "<leader>lh";
      action.__raw = ''
        function()
          if vim.bo.filetype == "nix" then
            vim.lsp.buf.hover()
          end
        end
      '';
      options.desc = "Hover (Nix)";
    }
    {
      mode = "n";
      key = "<leader>la";
      action.__raw = ''
        function()
          if vim.bo.filetype == "nix" then
            vim.lsp.buf.code_action({ timeout_ms = 1000 })
          end
        end
      '';
      options.desc = "Actions (Fast)";
    }
    {
      mode = "n";
      key = "<leader>ls";
      action.__raw = ''
        function()
          if vim.bo.filetype == "nix" then
            print("Basculement vers completion rapide (buffer + snippets)")
          end
        end
      '';
      options.desc = "Speed Mode";
    }

    # ===== KEYMAPS HASKELL - <leader>h =====
    {
      mode = "n";
      key = "<leader>hi";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            vim.lsp.buf.hover()
          end
        end
      '';
      options.desc = "Type Info";
    }
    {
      mode = "n";
      key = "<leader>hI";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            vim.lsp.buf.signature_help()
          end
        end
      '';
      options.desc = "Signature Help";
    }
    {
      mode = "n";
      key = "<leader>hs";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            haskell_hoogle_search()
          end
        end
      '';
      options.desc = "Hoogle Search";
    }
    {
      mode = "n";
      key = "<leader>hd";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            haskell_hoogle_search()
          end
        end
      '';
      options.desc = "Hoogle Docs";
    }
    {
      mode = "n";
      key = "<leader>hr";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            haskell_toggle_repl()
          end
        end
      '';
      options.desc = "Toggle REPL";
    }
    {
      mode = "n";
      key = "<leader>hl";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            haskell_load_file()
          end
        end
      '';
      options.desc = "Load in REPL";
    }
    {
      mode = "v";
      key = "<leader>he";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            haskell_execute_selection()
          end
        end
      '';
      options.desc = "Execute Selection";
    }
    {
      mode = "n";
      key = "<leader>he";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            haskell_execute_line()
          end
        end
      '';
      options.desc = "Execute Line";
    }
    {
      mode = "n";
      key = "<leader>hc";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            haskell_clear_repl()
          end
        end
      '';
      options.desc = "Clear REPL";
    }
    {
      mode = "n";
      key = "<leader>hb";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            haskell_build_project()
          end
        end
      '';
      options.desc = "Build";
    }
    {
      mode = "n";
      key = "<leader>ht";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            haskell_test_project()
          end
        end
      '';
      options.desc = "Test";
    }
    {
      mode = "n";
      key = "<leader>hC";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            haskell_clean_build()
          end
        end
      '';
      options.desc = "Clean Build";
    }
    {
      mode = "n";
      key = "<leader>hq";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            haskell_quick_compile()
          end
        end
      '';
      options.desc = "Quick Compile";
    }
    {
      mode = "n";
      key = "<leader>hf";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            require('conform').format({ async = true, lsp_fallback = true })
          end
        end
      '';
      options.desc = "Format";
    }
    {
      mode = "n";
      key = "<leader>hE";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            vim.diagnostic.setloclist()
          end
        end
      '';
      options.desc = "Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>hR";
      action.__raw = ''
        function()
          if vim.bo.filetype == "haskell" then
            haskell_restart_lsp()
          end
        end
      '';
      options.desc = "Restart LSP";
    }

    # =====================================================================
    # KEYMAPS BLINK COMPLETION
    # =====================================================================
    {
      mode = "i";
      key = "<C-Space>";
      action.__raw = ''
        function()
          local ok, blink = pcall(require, 'blink.cmp')
          if ok and blink.show then
            blink.show()
          else
            return vim.api.nvim_replace_termcodes('<C-x><C-n>', true, false, true)
          end
        end
      '';
      options = {
        desc = "Trigger completion";
        silent = true;
      };
    }
    {
      mode = "i";
      key = "<C-x><C-o>";
      action.__raw = ''
        function()
          local ok, blink = pcall(require, 'blink.cmp')
          if ok and blink.show then
            blink.show({ sources = { "lsp" } })
          else
            return vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true)
          end
        end
      '';
      options = {
        desc = "LSP completion";
        silent = true;
      };
    }
  ];

  # =====================================================================
  # SUPPRESSION DE KEYMAPS CONFLICTUELS
  # =====================================================================

  extraConfigLua = ''
    -- Supprimer les keymaps par défaut qui interfèrent avec JKLM
    local function safe_del_keymap(mode, key)
      pcall(vim.keymap.del, mode, key)
    end
    
    -- Attendre que tous les plugins soient chargés
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.defer_fn(function()
          -- Supprimer les keymaps LazyVim par défaut qui interfèrent
          safe_del_keymap({"n", "i", "v"}, "<A-j>")
          safe_del_keymap("n", "<S-h>")
          safe_del_keymap("n", "<S-l>")
        end, 100)
      end,
    })
    
    print("All keymaps loaded centrally")
  '';
}
