{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION HASKELL - Conforme aux recommandations haskell-tools
  # =====================================================================

  # =====================================================================
  # HASKELL-TOOLS.NVIM - Fonctionne "out of the box"
  # =====================================================================
  extraPlugins = with pkgs.vimPlugins; [
    haskell-tools-nvim
  ];

  # =====================================================================
  # ⚠️  PAS DE LSP HLS - haskell-tools gère automatiquement !
  # Conflit si on configure les deux selon les docs officielles
  # =====================================================================
  # plugins.lsp.servers.hls = {
  #   enable = true;  # ← SUPPRIMÉ pour éviter conflits
  # };

  # =====================================================================
  # PACKAGES REQUIS
  # =====================================================================
  extraPackages = with pkgs; [
    # Compilateur Haskell
    ghc
    cabal-install
    stack

    # Language Server (géré automatiquement par haskell-tools)
    haskell-language-server

    # Outils additionnels
    haskellPackages.hoogle
    ghcid
  ];

  # =====================================================================
  # AUTOCOMMANDS MINIMAUX (indentation seulement)
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "haskell" "lhaskell" ];
      callback.__raw = ''
        function()
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.commentstring = "-- %s"
        end
      '';
    }
  ];
  
  extraConfigLua = ''
      local ht = require('haskell-tools')
      local bufnr = vim.api.nvim_get_current_buf()
  '';
}
