{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION NIX - LSP optimisé pour la vitesse
  # =====================================================================
  
  # =====================================================================
  # LSP - nixd OPTIMISÉ pour la performance
  # =====================================================================
  plugins.lsp.servers.nixd = {
    enable = true;
    
    settings = {
      # Optimisation 1: Configuration nixpkgs allégée
      nixpkgs = {
        # Utiliser une évaluation plus légère
        expr = "import <nixpkgs> { }";
      };
      
      # Optimisation 2: Désactiver le formatage (utilise conform.nvim à la place)
      formatting = {
        command = null;  # Désactiver pour éviter les requêtes
      };
      
      # Optimisation 3: Réduire les options évaluées
      options = {
        # Commentez ces lignes pour accélérer (pas de completion NixOS/Home-Manager)
        # nixos = {
        #   expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.HOSTNAME.options";
        # };
        # home_manager = {
        #   expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.USERNAME.options";
        # };
      };
      
      # Optimisation 4: Paramètres de performance
      diagnostic = {
        suppress = [ "sema-escaping-with" ];  # Supprime certains diagnostics lents
      };
    };
  };
  
  # =====================================================================
  # ALTERNATIVE RAPIDE : nil LSP (commenté par défaut)
  # Décommentez pour passer à nil (beaucoup plus rapide)
  # =====================================================================
  
  # plugins.lsp.servers.nil-ls = {
  #   enable = true;
  #   settings = {
  #     # nil est beaucoup plus rapide que nixd
  #     formatting = {
  #       command = [ "nixpkgs-fmt" ];
  #     };
  #   };
  # };
  
  # =====================================================================
  # FORMATAGE - nixpkgs-fmt via conform.nvim (plus rapide que LSP)
  # =====================================================================
  plugins.conform-nvim.settings = {
    formatters_by_ft = {
      nix = [ "nixpkgs_fmt" ];
    };
    
    formatters = {
      nixpkgs_fmt = {
        command = "nixpkgs-fmt";
        args = [ ];
        stdin = true;
        timeout_ms = 2000;  # Timeout rapide
      };
    };
  };
  
  # =====================================================================
  # PACKAGES REQUIS
  # =====================================================================
  extraPackages = with pkgs; [
    nixd
    # nil_ls  # Décommentez si vous passez à nil
    nixpkgs-fmt
  ];
  
  # =====================================================================
  # AUTOCOMMANDS POUR NIX
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "nix" ];
      callback.__raw = ''
        function()
          -- Configuration d'indentation pour Nix
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.softtabstop = 2
          
          -- Commentaires Nix
          vim.bo.commentstring = "# %s"
          
          -- Options spécifiques
          vim.wo.foldmethod = "indent"
          vim.wo.foldlevel = 99
          
          print("Nix configuration loaded with optimized nixd")
        end
      '';
    }
  ];
  
  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE VIA LUA
  # =====================================================================
  extraConfigLua = ''
    -- Configuration avancée pour nixd optimisé
    
    -- ===================================================================
    -- OPTIMISATIONS SPÉCIFIQUES NIXD
    -- ===================================================================
    
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client or client.name ~= "nixd" then
          return
        end
        
        print("Optimizing nixd for performance...")
        
        -- Configuration de performance pour nixd
        client.config.flags = client.config.flags or {}
        client.config.flags.debounce_text_changes = 500  -- Plus de debounce
        client.config.flags.allow_incremental_sync = true
        
        -- Désactiver certaines fonctionnalités lentes
        if client.server_capabilities then
          -- Garder les fonctionnalités essentielles
          client.server_capabilities.documentFormattingProvider = false  -- Utilise conform à la place
          client.server_capabilities.documentRangeFormattingProvider = false
          
          -- Réduire la fréquence des diagnostics
          client.config.update_in_insert = false
        end
        
        print("nixd performance optimizations applied")
      end
    })
    
    -- ===================================================================
    -- KEYMAPS SPÉCIFIQUES À NIX (via autocommands)
    -- ===================================================================
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "nix",
      callback = function(event)
        local bufnr = event.buf
        local opts = { noremap = true, silent = true, buffer = bufnr }
        
        -- Format manuel RAPIDE (utilise conform au lieu de LSP)
        vim.keymap.set('n', '<leader>lf', function()
          require('conform').format({ 
            async = true, 
            timeout_ms = 2000,  -- Timeout court
            lsp_fallback = false  -- Pas de fallback LSP (plus rapide)
          })
        end, vim.tbl_extend('force', opts, { desc = "Format buffer (Fast)" }))
        
        -- Commandes nixd spécifiques avec timeouts
        vim.keymap.set('n', '<leader>lR', function()
          vim.lsp.buf.rename()
        end, vim.tbl_extend('force', opts, { desc = "Rename symbol (Nix)" }))
        
        vim.keymap.set('n', '<leader>ld', function()
          -- Timeout court pour go-to-definition
          vim.lsp.buf.definition({ timeout_ms = 2000 })
        end, vim.tbl_extend('force', opts, { desc = "Go to definition (Fast)" }))
        
        vim.keymap.set('n', '<leader>lh', function()
          vim.lsp.buf.hover()
        end, vim.tbl_extend('force', opts, { desc = "Hover info (Nix)" }))
        
        vim.keymap.set('n', '<leader>la', function()
          vim.lsp.buf.code_action({ timeout_ms = 1000 })
        end, vim.tbl_extend('force', opts, { desc = "Code actions (Fast)" }))
        
        -- Fonction pour basculer vers completion rapide
        vim.keymap.set('n', '<leader>ls', function()
          print("Basculement vers completion rapide (buffer + snippets)")
          -- Dans blink, cela privilégierait les sources non-LSP
        end, vim.tbl_extend('force', opts, { desc = "Fast completion mode" }))
        
        -- ===== INTÉGRATION WHICH-KEY POUR NIX =====
        vim.defer_fn(function()
          local ok, wk = pcall(require, "which-key")
          if ok then
            wk.add({
              { "<leader>l", group = "Nix (Optimized)", icon = " ", buffer = bufnr },
              { "<leader>lf", desc = "Format (Fast)", icon = " ", buffer = bufnr },
              { "<leader>ld", desc = "Definition (Fast)", icon = " ", buffer = bufnr },
              { "<leader>lh", desc = "Hover Info", icon = " ", buffer = bufnr },
              { "<leader>la", desc = "Actions (Fast)", icon = "󰌵 ", buffer = bufnr },
              { "<leader>lR", desc = "Rename", icon = "󰑕 ", buffer = bufnr },
              { "<leader>ls", desc = "Speed Mode", icon = "󰓅 ", buffer = bufnr },
            })
          end
        end, 100)
        
        print("Nix keymaps loaded (optimized for nixd performance)")
      end,
    })
    
    -- ===================================================================
    -- FONCTIONS UTILITAIRES
    -- ===================================================================
    
    -- Fonction pour tester les performances nixd
    _G.test_nixd_performance = function()
      print("=== Test Performance nixd ===")
      
      local clients = vim.lsp.get_clients({ name = "nixd" })
      if #clients > 0 then
        print("nixd actif")
        for _, client in ipairs(clients) do
          print("Client ID:", client.id)
          print("Root dir:", client.config.root_dir)
          
          local flags = client.config.flags or {}
          print("Debounce:", flags.debounce_text_changes or "default")
          print("Incremental sync:", flags.allow_incremental_sync or false)
        end
      else
        print("nixd pas actif")
      end
      
      print("")
      print("Test de vitesse:")
      print("1. Tapez 'pkgs.' dans un fichier .nix")
      print("2. Observez le délai de completion")
      print("3. Si trop lent, utilisez <leader>ls pour mode rapide")
    end
    
    -- Fonction pour basculer vers nil (LSP alternatif plus rapide)
    _G.suggest_nil_alternative = function()
      print("=== Alternative plus rapide : nil ===")
      print("")
      print("nixd est lent car il charge tout nixpkgs.")
      print("nil est un LSP Nix plus rapide mais avec moins de fonctionnalités.")
      print("")
      print("Pour passer à nil:")
      print("1. Dans config/lang/nix.nix:")
      print("   - Désactivez nixd: enable = false")
      print("   - Activez nil-ls: enable = true")
      print("2. Ajoutez 'nil_ls' aux extraPackages")
      print("3. Rebuilder avec 'nix run .'")
      print("")
      print("nil vs nixd:")
      print("  nil:  + Rapide, - Moins de features")
      print("  nixd: + Plus de features, - Lent")
    end
    
    -- Commandes personnalisées
    vim.api.nvim_create_user_command("NixdPerformance", function()
      test_nixd_performance()
    end, { desc = "Test nixd performance" })
    
    vim.api.nvim_create_user_command("NixFormat", function()
      require("conform").format({ 
        async = true, 
        lsp_fallback = false,
        timeout_ms = 2000
      })
      print("Formatted with nixpkgs-fmt (fast)")
    end, { desc = "Format current Nix file (fast)" })
    
    vim.api.nvim_create_user_command("SuggestNil", function()
      suggest_nil_alternative()
    end, { desc = "Info about nil LSP alternative" })
  '';
}
