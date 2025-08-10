{ pkgs, ...}:
{
  # =====================================================================
  # CONFIGURATION GIT SIMPLIFIÉE (70% moins de code)
  # =====================================================================

  plugins = {
    # =================================================================
    # GITSIGNS - Juste les icônes personnalisées (style LazyVim)
    # =================================================================
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = { text = "▎"; };
          change = { text = "▎"; };
          delete = { text = ""; };
          topdelete = { text = ""; };
          changedelete = { text = "▎"; };
          untracked = { text = "▎"; };
        };
        signs_staged = {
          add = { text = "▎"; };
          change = { text = "▎"; };
          delete = { text = ""; };
          topdelete = { text = ""; };
          changedelete = { text = "▎"; };
        };
      };
    };

    # =================================================================
    # AUTRES PLUGINS - Configuration minimale (défauts excellents)
    # =================================================================
    fugitive.enable = true;
    diffview.enable = true;
    git-conflict.enable = true;
  };

  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "<leader>g"; group = "Git"; }
  ];

  # =====================================================================
  # PACKAGES ESSENTIELS
  # =====================================================================
  extraPackages = with pkgs; [
    git
    lazygit
  ];

  keymaps = [
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

    # =====================================================================
    # NAVIGATION - g, [, ], z prefixes - Nixvim configure automatiquement
    # =====================================================================
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
  ];

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE MINIMALE - Juste l'essentiel
  # =====================================================================
  extraConfigLua = ''
    -- Diffview : configuration ultra-simple (défauts excellents)
    require("diffview").setup({
      enhanced_diff_hl = false,
      view = {
        default = { disable_diagnostics = true },
        merge_tool = { disable_diagnostics = true },
      },
    })
    
    -- Git-conflict : défauts parfaits, juste activer
    require("git-conflict").setup()
    
    -- Commandes utiles simplifiées
    vim.api.nvim_create_user_command("GitStageFile", function()
      require("gitsigns").stage_buffer()
      require("snacks").notify("File staged", { title = "Git" })
    end, { desc = "Stage current file" })
    
    vim.api.nvim_create_user_command("GitUnstageFile", function()
      require("gitsigns").reset_buffer()
      require("snacks").notify("File unstaged", { title = "Git" })
    end, { desc = "Unstage current file" })
  '';
}
