{
  # =====================================================================
  # KEYMAPS COMPLETS - Configuration JKLM et organisation par groupes
  # Intégré avec l'écosystème LSP unifié (conform + none-ls + nvim-lint)
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

    # ===== CODE GROUP - <leader>c - UNIFIÉ LSP + CONFORM + NONE-LS + LINT =====
    {
      mode = "n";
      key = "<leader>ca";
      action = "<cmd>lua _G.unified_code_action()<cr>";
      options.desc = "Code Actions (Unified)";
    }
    {
      mode = "n";
      key = "<leader>cr";
      action = "<cmd>lua _G.unified_rename()<cr>";
      options.desc = "Rename (Unified)";
    }
    {
      mode = "n";
      key = "<leader>cf";
      action = "<cmd>lua _G.unified_format()<cr>";
      options.desc = "Format (Unified)";
    }
    {
      mode = "n";
      key = "<leader>cF";
      action = "<cmd>lua _G.unified_format({ async = true })<cr>";
      options.desc = "Format Async";
    }
    {
      mode = "n";
      key = "<leader>cC";
      action = "<cmd>lua _G.cycle_formatter()<cr>";
      options.desc = "Cycle Formatter";
    }
    {
      mode = "n";
      key = "<leader>ct";
      action = "<cmd>FormatToggle<cr>";
      options.desc = "Toggle Auto-Format";
    }
    {
      mode = "n";
      key = "<leader>cl";
      action = "<cmd>LintToggle<cr>";
      options.desc = "Toggle Linting";
    }
    {
      mode = "n";
      key = "<leader>cL";
      action = "<cmd>Lint<cr>";
      options.desc = "Lint Now";
    }
    {
      mode = "n";
      key = "<leader>cc";
      action = "<cmd>LintClear<cr>";
      options.desc = "Clear Lint";
    }
    {
      mode = "n";
      key = "<leader>ci";
      action = "<cmd>LspInfo<cr>";
      options.desc = "LSP Info (Unified)";
    }
    {
      mode = "n";
      key = "<leader>cI";
      action = "<cmd>FormatInfo<cr>";
      options.desc = "Format Info";
    }
    {
      mode = "n";
      key = "<leader>cH";
      action = "<cmd>FormatHealth<cr>";
      options.desc = "Format Health";
    }
    {
      mode = "n";
      key = "<leader>ch";
      action = "<cmd>LintHealth<cr>";
      options.desc = "Lint Health";
    }
    {
      mode = "n";
      key = "<leader>cR";
      action = "<cmd>LspRestart<cr>";
      options.desc = "Restart LSP";
    }
    {
      mode = "n";
      key = "<leader>cn";
      action = "<cmd>NullLsInfo<cr>";
      options.desc = "none-ls Info";
    }
    {
      mode = "n";
      key = "<leader>cN";
      action = "<cmd>NullLsToggle<cr>";
      options.desc = "none-ls Toggle";
    }
    {
      mode = "n";
      key = "<leader>cS";
      action = "<cmd>EcosystemStatus<cr>";
      options.desc = "Ecosystem Status";
    }
    {
      mode = "n";
      key = "<leader>cE";
      action = "<cmd>EcosystemHealth<cr>";
      options.desc = "Ecosystem Health";
    }
    {
      mode = "n";
      key = "<leader>cX";
      action = "<cmd>EcosystemReset<cr>";
      options.desc = "Reset Ecosystem";
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

    # ===== UI GROUP - <leader>u - ÉTENDU AVEC ÉCOSYSTÈME LSP =====
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
    {
      mode = "n";
      key = "<leader>ud";
      action = "<cmd>ToggleDiagnostics<cr>";
      options.desc = "Toggle Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>uf";
      action = "<cmd>FormatToggle<cr>";
      options.desc = "Toggle Auto-Format";
    }
    {
      mode = "n";
      key = "<leader>uL";
      action = "<cmd>LintToggle<cr>";
      options.desc = "Toggle Auto-Lint";
    }
    {
      mode = "n";
      key = "<leader>uF";
      action = "<cmd>FormatHealth<cr>";
      options.desc = "Format Health";
    }
    {
      mode = "n";
      key = "<leader>uh";
      action = "<cmd>LintHealth<cr>";
      options.desc = "Lint Health";
    }
    {
      mode = "n";
      key = "<leader>ui";
      action = "<cmd>WhichKeyEcosystem<cr>";
      options.desc = "LSP Ecosystem Status";
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

    # ===== GOTO NAVIGATION - Utilise les fonctions natives =====
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
    {
      mode = "n";
      key = "K";
      action = "<cmd>lua vim.lsp.buf.hover()<cr>";
      options.desc = "Hover Documentation";
    }
    {
      mode = [ "n" "i" ];
      key = "<C-k>";
      action = "<cmd>lua vim.lsp.buf.signature_help()<cr>";
      options.desc = "Signature Help";
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
      key = "[D";
      action = "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>";
      options.desc = "Previous Error";
    }
    {
      mode = "n";
      key = "]D";
      action = "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>";
      options.desc = "Next Error";
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
    {
      mode = "n";
      key = "]H";
      action.__raw = ''
        function()
          require("gitsigns").nav_hunk("last")
        end
      '';
      options.desc = "Last Hunk";
    }
    {
      mode = "n";
      key = "[H";
      action.__raw = ''
        function()
          require("gitsigns").nav_hunk("first")
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
    # KEYMAPS SPÉCIFIQUES AUX LANGAGES (FileType-specific) - ALLÉGÉS
    # =====================================================================

    # ===== KEYMAPS NIX - <leader>l - ALLÉGÉS =====
    {
      mode = "n";
      key = "<leader>lf";
      action = "<cmd>lua _G.unified_format({ quiet = true })<cr>";
      options.desc = "Format Nix (Fast)";
    }
    {
      mode = "n";
      key = "<leader>la";
      action = "<cmd>lua _G.unified_code_action()<cr>";
      options.desc = "Actions (Unified)";
    }
    {
      mode = "n";
      key = "<leader>lr";
      action = "<cmd>lua _G.unified_rename()<cr>";
      options.desc = "Rename (Unified)";
    }
    {
      mode = "n";
      key = "<leader>ld";
      action = "<cmd>lua vim.lsp.buf.definition()<cr>";
      options.desc = "Definition";
    }
    {
      mode = "n";
      key = "<leader>lh";
      action = "<cmd>lua vim.lsp.buf.hover()<cr>";
      options.desc = "Hover";
    }
    {
      mode = "n";
      key = "<leader>ll";
      action = "<cmd>LintInfo<cr>";
      options.desc = "Lint Info";
    }

    # ===== KEYMAPS HASKELL - <leader>h - ALLÉGÉS =====
    {
      mode = "n";
      key = "<leader>hf";
      action = "<cmd>lua _G.unified_format()<cr>";
      options.desc = "Format";
    }
    {
      mode = "n";
      key = "<leader>ha";
      action = "<cmd>lua _G.unified_code_action()<cr>";
      options.desc = "Actions (Unified)";
    }
    {
      mode = "n";
      key = "<leader>hr";
      action = "<cmd>lua _G.unified_rename()<cr>";
      options.desc = "Rename (Unified)";
    }
    {
      mode = "n";
      key = "<leader>hi";
      action = "<cmd>lua vim.lsp.buf.hover()<cr>";
      options.desc = "Type Info";
    }
    {
      mode = "n";
      key = "<leader>hI";
      action = "<cmd>lua vim.lsp.buf.signature_help()<cr>";
      options.desc = "Signature Help";
    }
    {
      mode = "n";
      key = "<leader>hl";
      action = "<cmd>LintInfo<cr>";
      options.desc = "Lint Info";
    }

    # ===== KEYMAPS HASKELL SPÉCIFIQUES - REPL, BUILD, DOCS, RUN =====
    {
      mode = "n";
      key = "<leader>hs";
      action = "<cmd>lua _G.haskell_hoogle_search()<cr>";
      options.desc = "Hoogle Search";
    }
    {
      mode = "n";
      key = "<leader>hd";
      action = "<cmd>lua _G.haskell_docs_search()<cr>";
      options.desc = "Hoogle Docs";
    }
    {
      mode = "n";
      key = "<leader>hH";
      action = "<cmd>lua _G.haskell_hackage_search()<cr>";
      options.desc = "Hackage Search";
    }
    {
      mode = "n";
      key = "<leader>hR";
      action = "<cmd>lua _G.haskell_toggle_repl()<cr>";
      options.desc = "Toggle REPL";
    }
    {
      mode = "n";
      key = "<leader>hL";
      action = "<cmd>lua _G.haskell_load_file()<cr>";
      options.desc = "Load in REPL";
    }
    {
      mode = "v";
      key = "<leader>he";
      action = "<cmd>lua _G.haskell_execute_selection()<cr>";
      options.desc = "Execute Selection";
    }
    {
      mode = "n";
      key = "<leader>he";
      action = "<cmd>lua _G.haskell_execute_line()<cr>";
      options.desc = "Execute Line";
    }
    {
      mode = "n";
      key = "<leader>hc";
      action = "<cmd>lua _G.haskell_clear_repl()<cr>";
      options.desc = "Clear REPL";
    }
    {
      mode = "n";
      key = "<leader>hb";
      action = "<cmd>lua _G.haskell_build_project()<cr>";
      options.desc = "Build";
    }
    {
      mode = "n";
      key = "<leader>ht";
      action = "<cmd>lua _G.haskell_test_project()<cr>";
      options.desc = "Test";
    }
    {
      mode = "n";
      key = "<leader>hr";
      action = "<cmd>lua _G.haskell_run_project()<cr>";
      options.desc = "Run Project";
    }
    {
      mode = "n";
      key = "<leader>hC";
      action = "<cmd>lua _G.haskell_clean_build()<cr>";
      options.desc = "Clean Build";
    }
    {
      mode = "n";
      key = "<leader>hq";
      action = "<cmd>lua _G.haskell_quick_compile()<cr>";
      options.desc = "Quick Compile";
    }
    {
      mode = "n";
      key = "<leader>hD";
      action = "<cmd>lua _G.haskell_install_deps()<cr>";
      options.desc = "Install Deps";
    }

    # ===== KEYMAPS NIX SPÉCIFIQUES - BUILD, CHECK, EVAL, DEVELOP =====
    {
      mode = "n";
      key = "<leader>lb";
      action = "<cmd>lua _G.nix_build_current()<cr>";
      options.desc = "Build/Flake";
    }
    {
      mode = "n";
      key = "<leader>lc";
      action = "<cmd>lua _G.nix_check_current()<cr>";
      options.desc = "Check/Parse";
    }
    {
      mode = "n";
      key = "<leader>le";
      action = "<cmd>lua _G.nix_eval_expression()<cr>";
      options.desc = "Eval Expression";
    }
    {
      mode = "n";
      key = "<leader>ls";
      action = "<cmd>lua _G.nix_show_flake()<cr>";
      options.desc = "Show Flake";
    }
    {
      mode = "n";
      key = "<leader>lD";
      action = "<cmd>lua _G.nix_develop()<cr>";
      options.desc = "Nix Develop";
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
  # SUPPRESSION DE KEYMAPS CONFLICTUELS + LSP
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
          
          -- Supprimer les keymaps LSP par défaut pour éviter les doublons
          safe_del_keymap("n", "<leader>ca") -- On utilise nos versions unifiées
          safe_del_keymap("n", "<leader>cr")
          safe_del_keymap("n", "<leader>cf")
        end, 100)
      end,
    })
    
    -- Fonction globale pour debug keymaps
    _G.debug_keymaps = function()
      print("=== Unified LSP Keymaps ===")
      print("Available global functions:")
      print("  - _G.unified_code_action()")
      print("  - _G.unified_rename()")
      print("  - _G.unified_format(opts)")
      print("  - _G.toggle_auto_format()")
      print("  - _G.toggle_linting()")
      print("  - _G.lsp_info()")
      print("  - _G.unified_lsp_restart()")
      print("")
      print("State:")
      print("  Auto-format: " .. tostring(_G.lsp_unified_state.auto_format))
      print("  Auto-lint: " .. tostring(_G.lsp_unified_state.auto_lint))
    end
    
    print("Unified LSP keymaps loaded")
  '';
}
