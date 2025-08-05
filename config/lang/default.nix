{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION DES LANGAGES - Index principal
  # =====================================================================

  imports = [
    ./nix.nix
    ./haskell.nix
    # Ajoutez ici vos futurs langages :
    # ./python.nix
    # ./rust.nix
    # ./javascript.nix
    # ./lua.nix
    # ./go.nix
    # ./typescript.nix
    # ./html.nix
    # ./css.nix
    # ./json.nix
    # ./yaml.nix
    # ./markdown.nix
    # ./bash.nix
  ];

  # =====================================================================
  # CONFIGURATION LSP GLOBALE SIMPLIFIÉE
  # =====================================================================

  plugins.lsp = {
    enable = true;

    # Configuration des handlers LSP - SANS KEYMAPS
    onAttach = ''
      -- Configuration commune à tous les LSP servers
      if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
          group = "lsp_document_highlight",
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
          group = "lsp_document_highlight", 
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
      end
      
      -- Activer les inlay hints si supporté (Neovim 0.10+)
      if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
      end
      
      print("LSP attached: " .. client.name .. " (keymaps managed globally)")
    '';
  };

  # =====================================================================
  # TREESITTER GLOBAL - Configuration centralisée
  # =====================================================================

  plugins.treesitter = {
    enable = true;

    # Utiliser grammarPackages au lieu de ensure_installed pour nixvim
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      # Langages de base
      lua
      vim
      vimdoc
      query
      regex

      # Langages de programmation
      nix
      haskell
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

      # Documentation et markup
      markdown
      markdown_inline

      # Shell
      bash
      fish

      # Autres
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

      # Modules supplémentaires
      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = "<C-space>";
          node_incremental = "<C-space>";
          scope_incremental = "<C-s>";
          node_decremental = "<M-space>";
        };
      };

      textobjects = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
          };
        };
        move = {
          enable = true;
          set_jumps = true;
          goto_next_start = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
          };
          goto_next_end = {
            "]M" = "@function.outer";
            "][" = "@class.outer";
          };
          goto_previous_start = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
          };
          goto_previous_end = {
            "[M" = "@function.outer";
            "[]" = "@class.outer";
          };
        };
      };
    };
  };

  # =====================================================================
  # FORMATAGE GLOBAL (conform.nvim)
  # =====================================================================

  plugins.conform-nvim = {
    enable = true;

    settings = {
      # Configuration de base (étendue par chaque langage)
      format_on_save = {
        timeout_ms = 500;
        lsp_fallback = true;
      };

      # Notification lors du formatage
      notify_on_error = true;
    };
  };

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE - SANS KEYMAPS
  # =====================================================================

  extraConfigLua = ''
    -- Configuration globale pour les langages
    
    -- CONFIGURATION DES DIAGNOSTICS
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
          if #message > 50 then
            message = message:sub(1, 47) .. "..."
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
        format = function(diagnostic)
          local code = diagnostic.code and string.format(" [%s]", diagnostic.code) or ""
          return string.format("%s%s", diagnostic.message, code)
        end,
      },
      
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })
    
    -- Fonctions utilitaires
    _G.restart_all_lsp = function()
      vim.cmd("LspRestart")
      print("All LSP servers restarted")
    end
    
    -- Commandes globales
    vim.api.nvim_create_user_command("LangInfo", function()
      local ft = vim.bo.filetype
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      
      print("=== Language Information ===")
      print("Filetype: " .. ft)
      print("Buffer: " .. vim.api.nvim_buf_get_name(0))
      
      if #clients > 0 then
        print("LSP Clients:")
        for _, client in ipairs(clients) do
          print(string.format("  - %s (capabilities: %d)", 
            client.name, 
            vim.tbl_count(client.server_capabilities or {})
          ))
        end
      else
        print("No LSP clients attached")
      end
      
      local ts_parser = vim.treesitter.get_parser(0, ft, { error = false })
      print("Treesitter: " .. (ts_parser and "enabled" or "disabled"))
      
      local diagnostics = vim.diagnostic.get(0)
      local error_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      local warn_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      print(string.format("Diagnostics: %d total (%d errors, %d warnings)", 
        #diagnostics, error_count, warn_count))
    end, { desc = "Show language information for current buffer" })
    
    vim.api.nvim_create_user_command("ToggleDiagnostics", function()
      local config = vim.diagnostic.config()
      if config.virtual_text then
        vim.diagnostic.config({ virtual_text = false })
        print("Diagnostics virtual text disabled")
      else
        vim.diagnostic.config({ virtual_text = true })
        print("Diagnostics virtual text enabled")
      end
    end, { desc = "Toggle diagnostics virtual text" })
  '';
}
