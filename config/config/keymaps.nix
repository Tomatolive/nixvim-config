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
      options.desc = "Git Status";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>lua vim.cmd('Git blame')<cr>";
      options.desc = "Git Blame";
    }
    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd>lua vim.cmd('Gvdiffsplit')<cr>";
      options.desc = "Git Diff";
    }
    {
      mode = "n";
      key = "<leader>gl";
      action = "<cmd>lua vim.cmd('Git log')<cr>";
      options.desc = "Git Log";
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
      key = "<leader>bp";
      action = "<cmd>bprevious<cr>";
      options.desc = "Previous Buffer";
    }
    {
      mode = "n";
      key = "<leader>bn";
      action = "<cmd>bnext<cr>";
      options.desc = "Next Buffer";
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
      action = "<cmd>bprev<cr>";
      options.desc = "Previous Buffer";
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<cr>";
      options.desc = "Next Buffer";
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
  '';
}
