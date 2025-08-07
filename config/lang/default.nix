{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION DES LANGAGES - Version avec grammarPackages
  # =====================================================================

  imports = [
    ./c.nix
    ./nix.nix
    ./haskell.nix
  ];

  # =====================================================================
  # LSP DE BASE
  # =====================================================================
  plugins.lsp.enable = true;

  # =====================================================================
  # PACKAGES GLOBAUX
  # =====================================================================
  extraPackages = with pkgs; [
    # Formatters
    nixpkgs-fmt
    alejandra
    ormolu
    stylish-haskell

    # Linters
    hlint
    deadnix
    statix
  ];

  # =====================================================================
  # TREESITTER - Configuration complète RESTAURÉE
  # =====================================================================
  plugins.treesitter = {
    enable = true;

    # IMPORTANT: Les grammaires ne sont PAS téléchargées automatiquement !
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      # Langages de base
      lua
      vim
      vimdoc
      query
      regex

      # Langages actuels
      nix
      haskell

      # Langages courants (ajoute selon tes besoins)
      python
      rust
      javascript
      typescript
      go
      c
      cpp
      java

      # Web
      html
      css
      scss

      # Configuration et données
      json
      yaml
      toml
      xml

      # Documentation
      markdown
      markdown_inline

      # Shell
      bash
      fish

      # Git
      diff
      git_config
      git_rebase
      gitcommit
      gitignore
    ];

    settings = {
      highlight = {
        enable = true;
        additional_vim_regex_highlighting = false;
      };

      indent = {
        enable = true;
      };

      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = "<C-space>";
          node_incremental = "<C-space>";
          scope_incremental = "<C-s>";
          node_decremental = "<M-space>";
        };
      };

      # Text objects utiles
      textobjects = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
          };
        };
      };
    };
  };

  extraConfigLua = ''
    -- Configuration des icônes de diagnostic dans la marge
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = "󰌵 ",
        },
      },
      
      virtual_text = {
        enabled = true,
        spacing = 4,
        prefix = "●",
        format = function(diagnostic)
          local message = diagnostic.message
          if #message > 60 then
            message = message:sub(1, 57) .. "..."
          end
          
          -- Ajouter la source si elle existe
          local source = diagnostic.source
          if source and source ~= "" then
            return string.format("[%s] %s", source, message)
          end
          
          return message
        end,
      },
      
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        suffix = "",
        format = function(diagnostic)
          local code = diagnostic.code and string.format(" [%s]", diagnostic.code) or ""
          local source = diagnostic.source and string.format(" (%s)", diagnostic.source) or ""
          return string.format("%s%s%s", diagnostic.message, code, source)
        end,
      },
      
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      
      jump = {
        float = true,  -- Ouvrir float automatiquement lors de la navigation
      },
    })
    
    -- Configuration des highlights (couleurs gruvbox)
    vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#fb4934" })  -- Rouge
    vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#fabd2f" })   -- Jaune
    vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#83a598" })   -- Bleu
    vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#8ec07c" })   -- Vert
  '';
}
