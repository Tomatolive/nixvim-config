{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION DES LANGAGES - Index principal
  # =====================================================================
  
  imports = [
    ./nix.nix
    ./haskell.nix       # NOUVEAU : Support Haskell avec haskell-tools.nvim
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
  # CONFIGURATION LSP GLOBALE
  # =====================================================================
  
  # S'assurer que LSP est activé globalement
  plugins.lsp = {
    enable = true;
    
    # Configuration globale pour tous les LSP
    keymaps = {
      # Keymaps LSP communs à tous les langages
      lspBuf = {
        "gd" = "definition";
        "gD" = "declaration"; 
        "gr" = "references";
        "gi" = "implementation";
        "gt" = "type_definition";
        "K" = "hover";
        "<C-k>" = "signature_help";
        "<leader>ca" = "code_action";
        "<leader>cr" = "rename";
        "<leader>cf" = "format";
      };
      
      # Diagnostics
      diagnostic = {
        "[d" = "goto_prev";
        "]d" = "goto_next";
        "<leader>xe" = "open_float";
        "<leader>xl" = "setloclist";
        "<leader>xq" = "setqflist";  # Tous les diagnostics dans quickfix
      };
    };
    
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
        -- Signature corrigée pour Neovim 0.11+
        pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
      end
      
      print("LSP attached: " .. client.name)
    '';
  };
  
  # =====================================================================
  # TREESITTER GLOBAL
  # =====================================================================
  
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
      
      # Langages de base (étendus par chaque fichier de langage)
      ensure_installed = [
        "lua"          # Pour la configuration Neovim
        "vim"          # Pour les scripts Vim
        "vimdoc"       # Pour la documentation Vim
        "query"        # Pour les queries Treesitter
        "regex"        # Pour les expressions régulières
      ];
      
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
        enable = true;
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
  # AUTOCOMPLÉTION GLOBALE
  # =====================================================================
  
  # Déjà configuré dans plugins/blink.nix
  # Mais on peut ajouter des sources spécifiques aux langages ici
  
  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE
  # =====================================================================
  
  extraConfigLua = ''
    -- Configuration globale pour les langages
    
    -- CONFIGURATION DES DIAGNOSTICS - Affichage dans le buffer
    vim.diagnostic.config({
      -- Afficher les diagnostics dans la signcolumn avec des icônes
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",  -- Erreurs en rouge
          [vim.diagnostic.severity.WARN] = " ",   -- Warnings en jaune  
          [vim.diagnostic.severity.INFO] = " ",   -- Infos en bleu
          [vim.diagnostic.severity.HINT] = "󰌵 ",   -- Hints en vert
        },
      },
      
      -- Texte virtuel à la fin des lignes (optionnel)
      virtual_text = {
        enabled = true,
        spacing = 4,
        prefix = "●",
        format = function(diagnostic)
          -- Limiter la longueur du message  
          local message = diagnostic.message
          if #message > 50 then
            message = message:sub(1, 47) .. "..."
          end
          return message
        end,
      },
      
      -- Fenêtre flottante pour les diagnostics détaillés
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
      
      -- Affichage dans la ligne de statut
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })
    
    -- Définir les couleurs des diagnostics pour gruvbox
    vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#fb4934" })  -- Rouge gruvbox
    vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#fabd2f" })   -- Jaune gruvbox
    vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#83a598" })   -- Bleu gruvbox
    vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#8ec07c" })   -- Vert gruvbox
    
    -- Couleurs pour les icônes dans la signcolumn
    vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#fb4934", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#fabd2f", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#83a598", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#8ec07c", bg = "NONE" })
    
    -- Fonction utilitaire pour vérifier les LSP actifs (API corrigée)
    _G.list_lsp_clients = function()
      local clients = vim.lsp.get_clients()  -- API corrigée
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
    
    -- Fonction pour redémarrer tous les LSP
    _G.restart_all_lsp = function()
      vim.cmd("LspRestart")
      print("All LSP servers restarted")
    end
    
    -- Auto-commande pour afficher des informations sur le langage
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local ft = args.match
        -- Attendre un peu que les LSP se connectent
        vim.defer_fn(function()
          local clients = vim.lsp.get_clients({ bufnr = args.buf })  -- API corrigée
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
    
    -- Commandes globales pour les langages
    vim.api.nvim_create_user_command("LangInfo", function()
      local ft = vim.bo.filetype
      local clients = vim.lsp.get_clients({ bufnr = 0 })  -- API corrigée
      
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
      
      -- Afficher le nombre de diagnostics
      local diagnostics = vim.diagnostic.get(0)
      local error_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      local warn_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      print(string.format("Diagnostics: %d total (%d errors, %d warnings)", 
        #diagnostics, error_count, warn_count))
    end, { desc = "Show language information for current buffer" })
    
    -- Commande pour basculer les diagnostics virtuels
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
