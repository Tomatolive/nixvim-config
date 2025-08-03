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

    # Configuration des handlers LSP
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
      
      -- ===================================================================
      -- KEYMAPS LSP BUFFER-LOCAL (définis ici pour éviter les conflits)
      -- ===================================================================
      
      local function map(modes, lhs, rhs, desc)
        vim.keymap.set(modes, lhs, rhs, { 
          buffer = bufnr, 
          desc = desc,
          silent = true,
          noremap = true 
        })
      end
      
      -- Code actions
      if client.server_capabilities.codeActionProvider then
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action (" .. client.name .. ")")
      end
      
      -- Rename
      if client.server_capabilities.renameProvider then
        map("n", "<leader>cr", vim.lsp.buf.rename, "Rename (" .. client.name .. ")")
      end
      
      -- Format
      if client.server_capabilities.documentFormattingProvider then
        map("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format (" .. client.name .. ")")
      end
      
      -- Hover
      if client.server_capabilities.hoverProvider then
        map("n", "K", vim.lsp.buf.hover, "Hover (" .. client.name .. ")")
      end
      
      -- Signature Help
      if client.server_capabilities.signatureHelpProvider then
        map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help (" .. client.name .. ")")
      end
      
      -- Navigation avec Snacks picker (plus joli)
      if client.server_capabilities.definitionProvider then
        map("n", "gd", function()
          require("snacks").picker.lsp_definitions()
        end, "Go to Definition (" .. client.name .. ")")
      end
      
      if client.server_capabilities.referencesProvider then
        map("n", "gr", function()
          require("snacks").picker.lsp_references()
        end, "Find References (" .. client.name .. ")")
      end
      
      if client.server_capabilities.implementationProvider then
        map("n", "gi", function()
          require("snacks").picker.lsp_implementations()
        end, "Go to Implementation (" .. client.name .. ")")
      end
      
      if client.server_capabilities.typeDefinitionProvider then
        map("n", "gt", function()
          require("snacks").picker.lsp_type_definitions()
        end, "Go to Type Definition (" .. client.name .. ")")
      end
      
      -- Declaration (fallback vers LSP standard)
      if client.server_capabilities.declarationProvider then
        map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration (" .. client.name .. ")")
      end
      
      -- Diagnostics (globaux, pas spécifiques au LSP)
      map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
      map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
      map("n", "<leader>xe", vim.diagnostic.open_float, "Line Diagnostics")
      
      print("LSP attached: " .. client.name .. " with buffer-local keymaps")
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
  # CONFIGURATION SUPPLÉMENTAIRE
  # =====================================================================

  extraConfigLua = ''
    -- Configuration globale pour les langages
    
    -- CONFIGURATION DES DIAGNOSTICS
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
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
    
    -- Couleurs des diagnostics pour gruvbox
    vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#fb4934" })
    vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#fabd2f" })
    vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#83a598" })
    vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#8ec07c" })
    
    vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#fb4934", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#fabd2f", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#83a598", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#8ec07c", bg = "NONE" })
    
    -- Fonctions utilitaires
    _G.list_lsp_clients = function()
      local clients = vim.lsp.get_clients()
      if #clients == 0 then
        print("No LSP clients active")
        return
      end
      
      print("Active LSP clients:")
      for _, client in ipairs(clients) do
        print(string.format("  - %s (id: %d, root: %s)", 
          client.name, 
          client.id, 
          client.config.root_dir or "unknown"
        ))
      end
    end
    
    _G.restart_all_lsp = function()
      vim.cmd("LspRestart")
      print("All LSP servers restarted")
    end
    
    -- Auto-commande pour afficher des informations sur le langage
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local ft = args.match
        vim.defer_fn(function()
          local clients = vim.lsp.get_clients({ bufnr = args.buf })
          if #clients > 0 then
            local client_names = {}
            for _, client in ipairs(clients) do
              table.insert(client_names, client.name)
            end
            print(string.format("Language: %s | LSP: %s", ft, table.concat(client_names, ", ")))
          end
        end, 1000)
      end,
    })
    
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
        
      -- Afficher les keymaps LSP buffer-local
      print("LSP Keymaps available (buffer-local):")
      print("  gd → Go to Definition")
      print("  gr → Find References") 
      print("  gi → Go to Implementation")
      print("  gt → Go to Type Definition")
      print("  K → Hover Documentation")
      print("  <leader>ca → Code Actions")
      print("  <leader>cr → Rename")
      print("  <leader>cf → Format")
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
