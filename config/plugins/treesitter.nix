{
  plugins = {
    treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          ensure_installed = [
            "lua"
            "nix"
            "python"
            "rust"
            "typescript"
            "javascript"
            "html"
            "css"
            "json"
            "yaml"
            "markdown"
            "markdown_inline"
            "bash"
            "vim"
            "vimdoc"
          ];
        };
    };
  };
}
