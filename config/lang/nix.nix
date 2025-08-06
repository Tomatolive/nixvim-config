{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION NIX - Version simplifiée
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
  
  # Autocommands minimaux
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "nix" ];
      callback.__raw = ''
        function()
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.commentstring = "# %s"
        end
      '';
    }
  ];
}
