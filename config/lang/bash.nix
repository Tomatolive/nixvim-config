{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION BASH - Avec keymaps locaux
  # =====================================================================

  plugins = {
    # =====================================================================
    # BASHLS LSP - Configuration minimale
    # =====================================================================
    lsp.servers.bashls = {
      enable = true;
    };

    treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
    ];

    conform-nvim.settings.formatters_by_ft = {
      bash = [ "shfmt" ];
      sh = [ "shfmt" ];
    };

    lint.lintersByFt = {
      bash = [ "shellcheck" ];
      sh = [ "shellcheck" ];
    };
  };

  # =====================================================================
  # PACKAGES ESSENTIELS
  # =====================================================================
  extraPackages = with pkgs; [
    # LSP
    bash-language-server

    # Formatter
    shfmt

    # Linter (le plus important pour bash !)
    shellcheck
  ];

  # =====================================================================
  # AUTOCOMMANDS BASH AVEC KEYMAPS LOCAUX
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "bash" "sh" "zsh" ];
      callback.__raw = ''
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          
          -- Options bash
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.commentstring = "# %s"
          
          -- KEYMAPS LOCAUX - Seulement pour les buffers Bash !
          local opts = { buffer = bufnr, desc = "" }
          
          -- Run script
          opts.desc = "Run Script"
          vim.keymap.set("n", "<leader>Br", function()
            local file = vim.api.nvim_buf_get_name(0)
            if file and file ~= "" then
              require("snacks").terminal.open("bash " .. vim.fn.shellescape(file), {
                title = "Run Bash Script",
                size = { width = 0.8, height = 0.6 }
              })
            end
          end, opts)
          
          -- Check syntax with shellcheck
          opts.desc = "Check Syntax (ShellCheck)"
          vim.keymap.set("n", "<leader>Bc", function()
            local file = vim.api.nvim_buf_get_name(0)
            if file and file ~= "" then
              require("snacks").terminal.open("shellcheck " .. vim.fn.shellescape(file), {
                title = "ShellCheck Analysis",
                size = { width = 0.8, height = 0.6 }
              })
            end
          end, opts)
          
          -- Make executable
          opts.desc = "Make Executable"
          vim.keymap.set("n", "<leader>Bx", function()
            local file = vim.api.nvim_buf_get_name(0)
            if file and file ~= "" then
              vim.fn.system("chmod +x " .. vim.fn.shellescape(file))
              require("snacks").notify("Made executable: " .. vim.fn.fnamemodify(file, ":t"), { 
                title = "Bash",
                icon = ""
              })
            end
          end, opts)
          
          -- Source script
          opts.desc = "Source Script"
          vim.keymap.set("n", "<leader>Bs", function()
            local file = vim.api.nvim_buf_get_name(0)
            if file and file ~= "" then
              require("snacks").terminal.open("source " .. vim.fn.shellescape(file), {
                title = "Source Script",
                size = { width = 0.8, height = 0.6 }
              })
            end
          end, opts)
          
          -- Format with shfmt
          opts.desc = "Format (shfmt)"
          vim.keymap.set("n", "<leader>Bf", function()
            vim.lsp.buf.format()
          end, opts)
          
          -- Configuration which-key pour ce buffer seulement
          vim.defer_fn(function()
            local ok, wk = pcall(require, "which-key")
            if ok then
              wk.add({
                { "<leader>B", group = "Bash", icon = { icon = "", color = "green" }, buffer = bufnr },
              })
            end
          end, 100)
        end
      '';
    }
  ];
}
