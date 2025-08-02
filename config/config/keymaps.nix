{
  # =====================================================================
  # KEYMAPS COMPLETS - En accord avec la configuration which-key
  # =====================================================================
  
  keymaps = [
    # ===== CUSTOM MOVEMENT KEYS (JKLM instead of HJKL) =====
    {
      mode = [ "n" "v" "o" ];
      key = "j";
      action = "h";
      options.desc = "Move left (custom)";
    }
    {
      mode = [ "n" "v" "o" ];
      key = "k";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        desc = "Move down (custom)";
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
        desc = "Move up (custom)";
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
      options.desc = "Move right (custom)";
    }
    
    # Remap mark key
    {
      mode = "n";
      key = "§";
      action = "m";
      options.desc = "Set mark (custom)";
    }
    
    # ===== WINDOW NAVIGATION (adapted for JKLM) =====
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
    
    # ===== MOVE LINES (adapted for JKLM) =====
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
    
    # ===== BASIC IMPROVEMENTS =====
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
    
    # ===== INSERT MODE MAPPINGS =====
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
    
    # ===== BUFFER NAVIGATION =====
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

    # ===== EXPLORER =====
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
    
    # =====================================================================
    # FILE/FIND GROUP - <leader>f
    # =====================================================================
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
    
    # =====================================================================
    # GIT GROUP - <leader>g
    # =====================================================================
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>lua Snacks.lazygit()<cr>";
      options.desc = "Status";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>lua vim.cmd('Git blame')<cr>";
      options.desc = "Blame";
    }
    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd>lua vim.cmd('Gvdiffsplit')<cr>";
      options.desc = "Diff";
    }
    {
      mode = "n";
      key = "<leader>gl";
      action = "<cmd>lua vim.cmd('Git log')<cr>";
      options.desc = "Log";
    }
    {
      mode = "n";
      key = "<leader>gp";
      action = "<cmd>lua vim.cmd('Git push')<cr>";
      options.desc = "Push";
    }
    {
      mode = "n";
      key = "<leader>gP";
      action = "<cmd>lua vim.cmd('Git pull')<cr>";
      options.desc = "Pull";
    }
    {
      mode = "n";
      key = "<leader>gs";
      action = "<cmd>lua vim.cmd('Git add .')<cr>";
      options.desc = "Stage";
    }
    {
      mode = "n";
      key = "<leader>gu";
      action = "<cmd>lua vim.cmd('Git reset')<cr>";
      options.desc = "Unstage";
    }
    {
      mode = "n";
      key = "<leader>gr";
      action = "<cmd>lua vim.cmd('Git reset --hard')<cr>";
      options.desc = "Reset";
    }
    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>lua vim.cmd('Git commit')<cr>";
      options.desc = "Commit";
    }
    
    # =====================================================================
    # BUFFER GROUP - <leader>b
    # =====================================================================
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
      key = "<leader>bf";
      action = "<cmd>lua Snacks.picker.buffers()<cr>";
      options.desc = "Find Buffer";
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
    
    # =====================================================================
    # WINDOWS GROUP - <leader>w
    # =====================================================================
    # {
    #   mode = "n";
    #   key = "<leader>wh";
    #   action = "<C-w>h";
    #   options.desc = "Go Left";
    # }
    # {
    #   mode = "n";
    #   key = "<leader>wj"; 
    #   action = "<C-w>j";
    #   options.desc = "Go Down";
    # }
    # {
    #   mode = "n";
    #   key = "<leader>wk";
    #   action = "<C-w>k";
    #   options.desc = "Go Up";
    # }
    # {
    #   mode = "n";
    #   key = "<leader>wl";
    #   action = "<C-w>l";
    #   options.desc = "Go Right";
    # }
    # {
    #   mode = "n";
    #   key = "<leader>ws";
    #   action = "<cmd>split<cr>";
    #   options.desc = "Split Horizontal";
    # }
    # {
    #   mode = "n";
    #   key = "<leader>wv";
    #   action = "<cmd>vsplit<cr>";
    #   options.desc = "Split Vertical";
    # }
    # {
    #   mode = "n";
    #   key = "<leader>wc";
    #   action = "<C-w>c";
    #   options.desc = "Close Window";
    # }
    # {
    #   mode = "n";
    #   key = "<leader>wo";
    #   action = "<C-w>o";
    #   options.desc = "Only This Window";
    # }
    # {
    #   mode = "n";
    #   key = "<leader>w=";
    #   action = "<C-w>=";
    #   options.desc = "Balance Windows";
    # }
    # {
    #   mode = "n";
    #   key = "<leader>wr";
    #   action = "<C-w>x";
    #   options.desc = "Rotate Windows";
    # }
    
    # =====================================================================
    # CODE GROUP - <leader>c
    # =====================================================================
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
    {
      mode = "n";
      key = "<leader>cd";
      action = "<cmd>lua vim.lsp.buf.definition()<cr>";
      options.desc = "Definition";
    }
    {
      mode = "n";
      key = "<leader>cR";
      action = "<cmd>lua vim.lsp.buf.references()<cr>";
      options.desc = "References";
    }
    {
      mode = "n";
      key = "<leader>ci";
      action = "<cmd>lua vim.lsp.buf.implementation()<cr>";
      options.desc = "Implementation";
    }
    {
      mode = "n";
      key = "<leader>ct";
      action = "<cmd>lua vim.lsp.buf.type_definition()<cr>";
      options.desc = "Type Definition";
    }
    {
      mode = "n";
      key = "<leader>ch";
      action = "<cmd>lua vim.lsp.buf.hover()<cr>";
      options.desc = "Hover";
    }
    {
      mode = "n";
      key = "<leader>cs";
      action = "<cmd>lua vim.lsp.buf.signature_help()<cr>";
      options.desc = "Signature Help";
    }
    
    # =====================================================================
    # UI GROUP - <leader>u
    # =====================================================================
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
      key = "<leader>us";
      action = "<cmd>set laststatus=0<cr>";
      options.desc = "Hide Status Line";
    }
    {
      mode = "n";
      key = "<leader>ut";
      action = "<cmd>set showtabline=0<cr>";
      options.desc = "Hide Tab Line";
    }
    
    # =====================================================================
    # DIAGNOSTICS GROUP - <leader>x
    # =====================================================================
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
      key = "<leader>xt";
      action = "<cmd>TodoTrouble<cr>";
      options.desc = "Todo Comments";
    }
    {
      mode = "n";
      key = "<leader>xw";
      action = "<cmd>lua vim.diagnostic.setqflist()<cr>";
      options.desc = "Workspace Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>xe";
      action = "<cmd>lua vim.diagnostic.open_float()<cr>";
      options.desc = "Show Line Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>xn";
      action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
      options.desc = "Next Diagnostic";
    }
    {
      mode = "n";
      key = "<leader>xp";
      action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
      options.desc = "Previous Diagnostic";
    }
    
    # =====================================================================
    # TERMINAL GROUP - <leader>t
    # =====================================================================
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
    {
      mode = "n";
      key = "<leader>tf";
      action = "<cmd>lua Snacks.terminal.open(nil, {position = 'float'})<cr>";
      options.desc = "Floating Terminal";
    }
    {
      mode = "n";
      key = "<leader>tn";
      action = "<cmd>lua Snacks.terminal.open()<cr>";
      options.desc = "New Terminal";
    }
    {
      mode = "n";
      key = "<leader>tk";
      action = "<cmd>lua vim.cmd('bdelete!')<cr>";
      options.desc = "Kill Terminal";
    }
    
    # =====================================================================
    # NOTIFICATIONS GROUP - <leader>n
    # =====================================================================
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
    {
      mode = "n";
      key = "<leader>nl";
      action = "<cmd>lua Snacks.notifier.show_last()<cr>";
      options.desc = "Last Notification";
    }
    {
      mode = "n";
      key = "<leader>nc";
      action = "<cmd>lua Snacks.notifier.clear_history()<cr>";
      options.desc = "Clear History";
    }
    
    # =====================================================================
    # GOTO NAVIGATION - g prefix
    # =====================================================================
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
      key = "gs";
      action = "<cmd>lua vim.lsp.buf.signature_help()<cr>";
      options.desc = "Signature Help";
    }
    {
      mode = "n";
      key = "gx";
      action = "<cmd>lua vim.ui.open(vim.fn.expand('<cfile>'))<cr>";
      options.desc = "Open with system app";
    }
    {
      mode = "n";
      key = "gf";
      action = "gf";
      options.desc = "Go to File";
    }
    
    # =====================================================================
    # PREVIOUS NAVIGATION - [ prefix
    # =====================================================================
    {
      mode = "n";
      key = "[d";
      action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
      options.desc = "Previous Diagnostic";
    }
    {
      mode = "n";
      key = "[h";
      action = "<cmd>Gitsigns prev_hunk<cr>";
      options.desc = "Previous Hunk";
    }
    {
      mode = "n";
      key = "[q";
      action = "<cmd>cprev<cr>";
      options.desc = "Previous Quickfix";
    }
    {
      mode = "n";
      key = "[l";
      action = "<cmd>lprev<cr>";
      options.desc = "Previous Location";
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprev<cr>";
      options.desc = "Previous Buffer";
    }
    {
      mode = "n";
      key = "[t";
      action = "<cmd>tabprev<cr>";
      options.desc = "Previous Tab";
    }
    {
      mode = "n";
      key = "[e";
      action = "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>";
      options.desc = "Previous Error";
    }
    {
      mode = "n";
      key = "[w";
      action = "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARN})<cr>";
      options.desc = "Previous Warning";
    }
    
    # =====================================================================
    # NEXT NAVIGATION - ] prefix  
    # =====================================================================
    {
      mode = "n";
      key = "]d";
      action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
      options.desc = "Next Diagnostic";
    }
    {
      mode = "n";
      key = "]h";
      action = "<cmd>Gitsigns next_hunk<cr>";
      options.desc = "Next Hunk";
    }
    {
      mode = "n";
      key = "]q";
      action = "<cmd>cnext<cr>";
      options.desc = "Next Quickfix";
    }
    {
      mode = "n";
      key = "]l";
      action = "<cmd>lnext<cr>";
      options.desc = "Next Location";
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<cr>";
      options.desc = "Next Buffer";
    }
    {
      mode = "n";
      key = "]t";
      action = "<cmd>tabnext<cr>";
      options.desc = "Next Tab";
    }
    {
      mode = "n";
      key = "]e";
      action = "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>";
      options.desc = "Next Error";
    }
    {
      mode = "n";
      key = "]w";
      action = "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARN})<cr>";
      options.desc = "Next Warning";
    }
    
    # =====================================================================
    # FOLD OPERATIONS - z prefix
    # =====================================================================
    {
      mode = "n";
      key = "za";
      action = "za";
      options.desc = "Toggle fold";
    }
    {
      mode = "n";
      key = "zc";
      action = "zc";
      options.desc = "Close fold";
    }
    {
      mode = "n";
      key = "zo";
      action = "zo";
      options.desc = "Open fold";
    }
    {
      mode = "n";
      key = "zm";
      action = "zm";
      options.desc = "Close all folds";
    }
    {
      mode = "n";
      key = "zr";
      action = "zr";
      options.desc = "Open all folds";
    }
    {
      mode = "n";
      key = "zf";
      action = "zf";
      options.desc = "Create fold";
    }
    {
      mode = "n";
      key = "zd";
      action = "zd";
      options.desc = "Delete fold";
    }
    {
      mode = "n";
      key = "zE";
      action = "zE";
      options.desc = "Eliminate all folds";
    }
    
    # =====================================================================
    # WHICH-KEY SPECIFIC KEYMAPS
    # =====================================================================
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
    # ADDITIONAL USEFUL KEYMAPS
    # =====================================================================
    
    # Quick save and quit
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
    
    # Better indenting
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
    
    # Clear search highlighting
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<cr>";
      options.desc = "Clear search highlight";
    }
    
    # Select all
    {
      mode = "n";
      key = "<C-a>";
      action = "ggVG";
      options.desc = "Select all";
    }
    
    # Better window resizing
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
  ];
  
  # =====================================================================
  # SUPPRESSION DE KEYMAPS CONFLICTUELS
  # =====================================================================
  
  extraConfigLua = ''
    -- Supprimer les keymaps par défaut qui interfèrent
    local function safe_del_keymap(mode, key)
      pcall(vim.keymap.del, mode, key)
    end
    
    -- Supprimer les keymaps LazyVim par défaut qui interfèrent avec JKLM
    safe_del_keymap({"n", "i", "v"}, "<A-j>")
    safe_del_keymap("n", "<S-h>")
    safe_del_keymap("n", "<S-l>")
    
    -- Création de groupes additionnels pour which-key
    local wk = require("which-key")
    
    -- S'assurer que tous les groupes sont bien définis
    wk.add({
      { "<leader>", group = "Leader" },
      { "<leader>f", group = "Find/File" },
      { "<leader>g", group = "Git" },
      { "<leader>b", group = "Buffer" },
      { "<leader>w", group = "Window" },
      { "<leader>c", group = "Code" },
      { "<leader>u", group = "UI" },
      { "<leader>x", group = "Diagnostics" },  
      { "<leader>t", group = "Terminal" },
      { "<leader>n", group = "Notifications" },
      { "g", group = "Goto" },
      { "[", group = "Previous" },
      { "]", group = "Next" },
      { "z", group = "Fold" },
    })
  '';
}
