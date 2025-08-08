{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION MARKDOWN - Version avec plugins natifs Nixvim
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
  # AUTOCOMMANDS MARKDOWN - CORRIGÉ
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "markdown" ];
      callback.__raw = ''
        function()
          -- Options markdown essentielles
          vim.bo.textwidth = 80
          vim.wo.wrap = true  -- ← CORRIGÉ : window-local option
          vim.wo.linebreak = true  -- ← CORRIGÉ : window-local option
          vim.bo.commentstring = "<!-- %s -->"
          
          -- Spell check
          vim.wo.spell = true  -- ← CORRIGÉ : window-local option
          vim.bo.spelllang = "en,fr"
        end
      '';
    }
  ];
}
