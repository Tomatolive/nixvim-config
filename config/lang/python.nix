{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION PYTHON - Avec keymaps locaux
  # =====================================================================

  plugins = {
    # =====================================================================
    # BASEDPYRIGHT LSP - Configuration minimale
    # =====================================================================
    lsp.servers.basedpyright = {
      enable = true;
      # Défauts excellents, pas de configuration nécessaire
    };

    treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      python
    ];

    conform-nvim.settings.formatters_by_ft = {
      python = [ "black" ];
    };

    lint.lintersByFt = {
      python = [ "ruff" ];
    };
  };

  # =====================================================================
  # PACKAGES ESSENTIELS
  # =====================================================================
  extraPackages = with pkgs; [
    # LSP
    basedpyright

    # Formatter
    black

    # Linter (ruff est plus moderne et rapide que flake8)
    ruff

    # Python lui-même
    python3

    # Utilitaires Python utiles
    python3Packages.pip
  ];

  # =====================================================================
  # AUTOCOMMANDS PYTHON AVEC KEYMAPS LOCAUX
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "python" ];
      callback.__raw = ''
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          
          -- Options Python
          vim.bo.tabstop = 4
          vim.bo.shiftwidth = 4
          vim.bo.expandtab = true
          vim.bo.commentstring = "# %s"
          
          -- KEYMAPS LOCAUX - Seulement pour les buffers Python !
          local opts = { buffer = bufnr, desc = "" }
          
          -- Run script
          opts.desc = "Run Script"
          vim.keymap.set("n", "<leader>Pr", function()
            local file = vim.api.nvim_buf_get_name(0)
            if file and file ~= "" then
              require("snacks").terminal.open("python " .. vim.fn.shellescape(file), {
                title = "Run Python Script",
                size = { width = 0.8, height = 0.6 }
              })
            end
          end, opts)
          
          -- Run in interactive mode
          opts.desc = "Run Interactive"
          vim.keymap.set("n", "<leader>Pi", function()
            local file = vim.api.nvim_buf_get_name(0)
            if file and file ~= "" then
              require("snacks").terminal.open("python -i " .. vim.fn.shellescape(file), {
                title = "Python Interactive",
                size = { width = 0.8, height = 0.6 }
              })
            end
          end, opts)
          
          -- Check with ruff
          opts.desc = "Check (Ruff)"
          vim.keymap.set("n", "<leader>Pc", function()
            local file = vim.api.nvim_buf_get_name(0)
            if file and file ~= "" then
              require("snacks").terminal.open("ruff check " .. vim.fn.shellescape(file), {
                title = "Ruff Analysis",
                size = { width = 0.8, height = 0.6 }
              })
            end
          end, opts)
          
          -- Format with black
          opts.desc = "Format (Black)"
          vim.keymap.set("n", "<leader>Pf", function()
            vim.lsp.buf.format()
          end, opts)
          
          -- Run tests (pytest if available)
          opts.desc = "Run Tests"
          vim.keymap.set("n", "<leader>Pt", function()
            local cwd = vim.fn.getcwd()
            require("snacks").terminal.open("python -m pytest -v", {
              title = "Run Tests",
              size = { width = 0.8, height = 0.6 },
              cwd = cwd
            })
          end, opts)
          
          -- Install requirements
          opts.desc = "Install Requirements"
          vim.keymap.set("n", "<leader>PI", function()
            local cwd = vim.fn.getcwd()
            if vim.fn.filereadable(cwd .. "/requirements.txt") == 1 then
              require("snacks").terminal.open("pip install -r requirements.txt", {
                title = "Install Requirements",
                size = { width = 0.8, height = 0.6 }
              })
            else
              require("snacks").notify("No requirements.txt found", { 
                title = "Python",
                level = "warn"
              })
            end
          end, opts)
          
          -- Start Python REPL
          opts.desc = "Python REPL"
          vim.keymap.set("n", "<leader>PR", function()
            require("snacks").terminal.open("python", {
              title = "Python REPL",
              size = { width = 0.8, height = 0.6 }
            })
          end, opts)
          
          -- Configuration which-key pour ce buffer seulement
          vim.defer_fn(function()
            local ok, wk = pcall(require, "which-key")
            if ok then
              wk.add({
                { "<leader>P", group = "Python", icon = { icon = "", color = "yellow" }, buffer = bufnr },
              })
            end
          end, 100)
        end
      '';
    }
  ];
}
