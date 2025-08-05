{
  # =====================================================================
  # CONFIGURATION GIT - Version corrigée compatible noice
  # =====================================================================

  plugins = {
    # =================================================================
    # GITSIGNS - Configuration exacte LazyVim
    # =================================================================
    gitsigns = {
      enable = true;

      settings = {
        # Icônes exactement comme LazyVim
        signs = {
          add = { text = "▎"; };
          change = { text = "▎"; };
          delete = { text = ""; };
          topdelete = { text = ""; };
          changedelete = { text = "▎"; };
          untracked = { text = "▎"; };
        };

        signs_staged = {
          add = { text = "▎"; };
          change = { text = "▎"; };
          delete = { text = ""; };
          topdelete = { text = ""; };
          changedelete = { text = "▎"; };
        };

        # Configuration simplifiée - pas de messages debug
        signcolumn = true;
        numhl = false;
        linehl = false;
        word_diff = false;
        watch_gitdir = {
          interval = 1000;
          follow_files = true;
        };
        auto_attach = true;
        attach_to_untracked = false;
        current_line_blame = false;
        current_line_blame_opts = {
          virt_text = true;
          virt_text_pos = "eol";
          delay = 1000;
          ignore_whitespace = false;
        };
        sign_priority = 6;
        update_debounce = 100;
        max_file_length = 40000;
        preview_config = {
          border = "rounded";
          style = "minimal";
          relative = "cursor";
          row = 0;
          col = 1;
        };
      };
    };

    # =================================================================
    # FUGITIVE - Commandes Git avancées
    # =================================================================
    fugitive = {
      enable = true;
    };

    # =================================================================
    # DIFFVIEW - Configuration minimale pour éviter conflits noice
    # =================================================================
    diffview = {
      enable = true;
    };

    # =================================================================
    # GIT-CONFLICT - Configuration minimale
    # =================================================================
    git-conflict = {
      enable = true;
    };
  };

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE LUA - VERSION SIMPLIFIÉE
  # =====================================================================

  extraConfigLua = ''
    -- ===================================================================
    -- CONFIGURATION GITSIGNS AVEC KEYMAPS STYLE LAZYVIM - VERSION MINIMALE
    -- ===================================================================
    
    -- Setup gitsigns on_attach (une seule fois, sans messages debug)
    require('gitsigns').setup({
      on_attach = function(buffer)
        local gs = require('gitsigns')
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
        end
        
        -- Navigation hunks (style LazyVim exact)
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        
        -- Actions hunks
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghP", gs.preview_hunk, "Preview Hunk")
        
        -- Blame
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        
        -- Diff
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        
        -- Text objects
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    })
    
    -- ===================================================================
    -- CONFIGURATION DIFFVIEW - COMPATIBLE NOICE
    -- ===================================================================
    
    require("diffview").setup({
      diff_binaries = false,
      enhanced_diff_hl = false,
      use_icons = true,
      show_help_hints = true,
      watch_index = true,
      
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
          winbar_info = false,
        },
        merge_tool = {
          layout = "diff3_horizontal", 
          disable_diagnostics = true,
          winbar_info = false,
        },
        file_history = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
          winbar_info = false,
        },
      },
      
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
        },
      },
      
      file_history_panel = {
        win_config = {
          position = "bottom",
          height = 16,
        },
      },
      
      -- Configuration spéciale pour éviter conflits avec noice
      hooks = {
        diff_buf_read = function(bufnr)
          -- Désactiver noice temporairement pour diffview
          pcall(vim.api.nvim_buf_set_option, bufnr, 'bufhidden', 'wipe')
        end,
      },
    })
    
    -- ===================================================================
    -- CONFIGURATION GIT-CONFLICT
    -- ===================================================================
    
    require("git-conflict").setup({
      default_mappings = {
        ours = "co",
        theirs = "ct",
        none = "c0", 
        both = "cb",
        next = "]x",
        prev = "[x",
      },
      default_commands = true,
      disable_diagnostics = false,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    })
    
    -- ===================================================================
    -- HIGHLIGHTS GITSIGNS POUR GRUVBOX
    -- ===================================================================
    
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        -- Signs dans la gutter
        vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#b8bb26", bg = "NONE" })
        vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#fabd2f", bg = "NONE" })
        vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#fb4934", bg = "NONE" })
        vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = "#fb4934", bg = "NONE" })
        vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = "#fe8019", bg = "NONE" })
        vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#83a598", bg = "NONE" })
        
        -- Current line blame
        vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { 
          fg = "#928374", 
          italic = true,
          bg = "NONE" 
        })
      end,
    })
    
    -- ===================================================================
    -- WHICH-KEY INTÉGRATION
    -- ===================================================================
    
    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          { "<leader>g", group = "󰊢 Git" },
          { "<leader>gh", group = " Git Hunks" },
          { "<leader>gg", desc = "Lazygit", icon = " " },
          { "<leader>gs", desc = "Status", icon = " " },
          { "<leader>gc", desc = "Commit", icon = " " },
          { "<leader>gp", desc = "Push", icon = " " },
          { "<leader>gP", desc = "Pull", icon = " " },
          { "<leader>gb", desc = "Blame", icon = " " },
          { "<leader>gd", desc = "Diff View", icon = " " },
          { "<leader>gh", desc = "File History", icon = " " },
          { "<leader>uG", desc = "Toggle Git Signs", icon = " " },
          
          -- Navigation
          { "[h", desc = "Prev Hunk", icon = " " },
          { "]h", desc = "Next Hunk", icon = " " },
          { "[x", desc = "Prev Conflict", icon = " " },
          { "]x", desc = "Next Conflict", icon = " " },
          
          -- Conflits
          { "co", desc = "Choose Ours", icon = " " },
          { "ct", desc = "Choose Theirs", icon = " " },
          { "cb", desc = "Choose Both", icon = " " },
          { "c0", desc = "Choose None", icon = " " },
        })
      end
    end, 500)
    
    -- ===================================================================
    -- COMMANDES UTILES (SANS MESSAGES DEBUG)
    -- ===================================================================
    
    vim.api.nvim_create_user_command("GitFileHistory", function()
      local file = vim.api.nvim_buf_get_name(0)
      if file and file ~= "" then
        vim.cmd("DiffviewFileHistory " .. vim.fn.shellescape(file))
      end
    end, { desc = "Show git history for current file" })
    
    vim.api.nvim_create_user_command("GitStageFile", function()
      require("gitsigns").stage_buffer()
      require("snacks").notify("File staged", { title = "Git" })
    end, { desc = "Stage current file" })
    
    vim.api.nvim_create_user_command("GitUnstageFile", function()
      require("gitsigns").reset_buffer()
      require("snacks").notify("File unstaged", { title = "Git" })
    end, { desc = "Unstage current file" })
    
    -- Configuration FileType pour Git sans messages
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "fugitive", "git", "gitcommit", "gitrebase" },
      callback = function()
        vim.opt_local.wrap = false
        vim.opt_local.spell = false
      end,
    })
  '';
}
