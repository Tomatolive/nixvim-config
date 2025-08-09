{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION NIX - Avec keymaps locaux
  # =====================================================================

  # LSP - configuration minimale
  plugins.lsp.servers.nixd = {
    enable = true;
    settings = {
      nixpkgs.expr = "import <nixpkgs> { }";
    };
  };

  # Packages
  extraPackages = with pkgs; [
    nixd
  ];

  # =====================================================================
  # AUTOCOMMANDS AVEC KEYMAPS LOCAUX
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "nix" ];
      callback.__raw = ''
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          
          -- Options d'indentation
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.commentstring = "# %s"
          
          -- KEYMAPS LOCAUX - Seulement pour les buffers Nix !
          local opts = { buffer = bufnr, desc = "" }
          
          -- Flake commands (si dans un projet flake)
          opts.desc = "Nix flake check"
          vim.keymap.set("n", "<leader>Nc", function()
            require("snacks").terminal.open("nix flake check", {
              title = "Nix Flake Check",
              size = { width = 0.8, height = 0.6 }
            })
          end, opts)
          
          opts.desc = "Nix flake update"
          vim.keymap.set("n", "<leader>Nu", function()
            require("snacks").terminal.open("nix flake update", {
              title = "Nix Flake Update",
              size = { width = 0.8, height = 0.6 }
            })
          end, opts)
          
          opts.desc = "Nix build"
          vim.keymap.set("n", "<leader>Nb", function()
            require("snacks").terminal.open("nix build", {
              title = "Nix Build",
              size = { width = 0.8, height = 0.6 }
            })
          end, opts)
          
          opts.desc = "Nix develop"
          vim.keymap.set("n", "<leader>Nd", function()
            require("snacks").terminal.open("nix develop", {
              title = "Nix Develop",
              size = { width = 0.8, height = 0.6 }
            })
          end, opts)
          
          opts.desc = "Format with nixpkgs-fmt"
          vim.keymap.set("n", "<leader>Nf", function()
            vim.lsp.buf.format()
          end, opts)
          
          -- Configuration which-key pour ce buffer seulement
          vim.defer_fn(function()
            local ok, wk = pcall(require, "which-key")
            if ok then
              wk.add({
                { "<leader>N", group = "Nix", icon = { icon = "󱄅", color = "blue" }, buffer = bufnr },
              })
            end
          end, 100)
        end
      '';
    }
  ];
}
