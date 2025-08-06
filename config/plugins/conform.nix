{
  # =====================================================================
  # CONFORM.NVIM - Version simplifiée
  # =====================================================================

  plugins.conform-nvim = {
    enable = true;

    settings = {
      # Formatters par filetype - simple et direct
      formatters_by_ft = {
        nix = [ "nixpkgs_fmt" ];
        haskell = [ "ormolu" ];
        c = [ "clang_format" ];
        cpp = [ "clang_format" ];
      };

      # Format on save - simple
      format_on_save = {
        timeout_ms = 1000;
        lsp_fallback = true; # Fallback vers LSP si conform n'a pas de formatter
      };

      # Pas de configuration custom - Nixvim/conform gèrent tout
    };
  };
}
