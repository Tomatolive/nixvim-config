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
