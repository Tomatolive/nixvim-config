{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION MARKDOWN - Avec keymaps locaux
  # =====================================================================

  # =====================================================================
  # LSP MARKDOWN
  # =====================================================================
  plugins.lsp.servers.marksman = {
    enable = true;
  };

  # =====================================================================
  # MARKVIEW - Configuration native Nixvim (v25 spec)
  # =====================================================================
  plugins.markview = {
    enable = true;
    settings = {
      # Configuration v25 - tout sous "preview"
      preview = {
        modes = [ "n" ]; # Juste en mode normal
        hybrid_modes = [ "n" ];
        
        # Auto-enable pour markdown
        filetypes = [ "markdown" "quarto" "rmd" ];
        
        # Performance
        debounce = 300;
      };
    };
  };

  # =====================================================================
  # MARKDOWN-PREVIEW - Preview dans le navigateur
  # =====================================================================
  plugins.markdown-preview = {
    enable = true;
    settings = {
      browser = "default";
      echo_preview_url = 1; # ← CORRIGÉ : 1 au lieu de true
      port = "8080";
      theme = "dark";
    };
  };

  # =====================================================================
  # PACKAGES ESSENTIELS
  # =====================================================================
  extraPackages = with pkgs; [
    # LSP
    marksman

    # Formatters
    prettier

    # Linters  
    markdownlint-cli

    # Export
    pandoc
  ];

  # =====================================================================
  # AUTOCOMMANDS MARKDOWN AVEC KEYMAPS LOCAUX
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "markdown" ];
      callback.__raw = ''
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          
          -- Options markdown essentielles
          vim.bo.textwidth = 80
          vim.wo.wrap = true  -- ← CORRIGÉ : window-local option
          vim.wo.linebreak = true  -- ← CORRIGÉ : window-local option
          vim.bo.commentstring = "<!-- %s -->"
          
          -- Spell check
          vim.wo.spell = true  -- ← CORRIGÉ : window-local option
          vim.bo.spelllang = "en,fr"
          
          -- KEYMAPS LOCAUX - Seulement pour les buffers Markdown !
          local opts = { buffer = bufnr, desc = "" }
          
          -- Toggle Markview
          opts.desc = "Toggle Markview"
          vim.keymap.set("n", "<leader>mt", "<cmd>Markview toggle<cr>", opts)
          
          -- Toggle Preview (Browser)
          opts.desc = "Toggle Preview (Browser)"
          vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", opts)
          
          -- Export to HTML (Pandoc)
          opts.desc = "Export to HTML (Pandoc)"
          vim.keymap.set("n", "<leader>me", function()
            local file = vim.api.nvim_buf_get_name(0)
            if file and file ~= "" then
              local output = vim.fn.fnamemodify(file, ":r") .. ".html"
              require("snacks").terminal.open("pandoc " .. vim.fn.shellescape(file) .. " -o " .. vim.fn.shellescape(output), {
                title = "Pandoc Export",
                size = { width = 0.8, height = 0.6 }
              })
            end
          end, opts)
          
          -- Configuration which-key pour ce buffer seulement
          vim.defer_fn(function()
            local ok, wk = pcall(require, "which-key")
            if ok then
              wk.add({
                { "<leader>m", group = " Markdown", buffer = bufnr },
              })
            end
          end, 100)
        end
      '';
    }
  ];
}
