{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION NIX - LSP et formatage
  # =====================================================================
  
  # =====================================================================
  # LSP - nixd (LSP server moderne pour Nix)
  # =====================================================================
  plugins.lsp.servers.nixd = {
    enable = true;
    
    settings = {
      nixpkgs = {
        expr = "import <nixpkgs> { }";
      };
      
      formatting = {
        command = [ "nixpkgs-fmt" ];
      };
      
      options = {
        nixos = {
          expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.HOSTNAME.options";
        };
        
        home_manager = {
          expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.USERNAME.options";
        };
      };
    };
  };
  
  # =====================================================================
  # FORMATAGE - nixpkgs-fmt via conform.nvim
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
      };
    };
  };
  
  # =====================================================================
  # PACKAGES REQUIS
  # =====================================================================
  extraPackages = with pkgs; [
    nixd
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
          
          print("Nix configuration loaded with nixd + nixpkgs-fmt")
        end
      '';
    }
  ];
  
  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE VIA LUA
  # =====================================================================
  extraConfigLua = ''
    -- Configuration avancée pour nixd
    
    -- ===================================================================
    -- KEYMAPS SPÉCIFIQUES À NIX (via autocommands)
    -- ===================================================================
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "nix",
      callback = function(event)
        local bufnr = event.buf
        local opts = { noremap = true, silent = true, buffer = bufnr }
        
        -- Format manuel
        vim.keymap.set('n', '<leader>lf', function()
          require('conform').format({ async = true, lsp_fallback = true })
        end, vim.tbl_extend('force', opts, { desc = "Format buffer (Nix)" }))
        
        -- Commandes nixd spécifiques
        vim.keymap.set('n', '<leader>lR', vim.lsp.buf.rename, 
          vim.tbl_extend('force', opts, { desc = "Rename symbol (Nix)" }))
        
        vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, 
          vim.tbl_extend('force', opts, { desc = "Go to definition (Nix)" }))
        
        vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, 
          vim.tbl_extend('force', opts, { desc = "Hover documentation (Nix)" }))
        
        vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, 
          vim.tbl_extend('force', opts, { desc = "Code actions (Nix)" }))
        
        -- ===== INTÉGRATION WHICH-KEY POUR NIX =====
        vim.defer_fn(function()
          local ok, wk = pcall(require, "which-key")
          if ok then
            wk.add({
              { "<leader>l", group = "Language/Nix", icon = " ", buffer = bufnr },
              { "<leader>lf", desc = "Format Code", icon = " ", buffer = bufnr },
              { "<leader>ld", desc = "Go to Definition", icon = " ", buffer = bufnr },
              { "<leader>lh", desc = "Hover Info", icon = " ", buffer = bufnr },
              { "<leader>la", desc = "Code Actions", icon = "󰌵 ", buffer = bufnr },
              { "<leader>lR", desc = "Rename Symbol", icon = "󰑕 ", buffer = bufnr },
            })
          end
        end, 100)
        
        print("Nix keymaps loaded for buffer " .. bufnr)
      end,
    })
    
    -- ===================================================================
    -- FONCTIONS UTILITAIRES
    -- ===================================================================
    
    -- Détection automatique de flake.nix
    local function find_flake_root()
      local current_dir = vim.fn.expand('%:p:h')
      local flake_file = vim.fn.findfile('flake.nix', current_dir .. ';')
      if flake_file ~= "" then
        return vim.fn.fnamemodify(flake_file, ':h')
      end
      return nil
    end
    
    -- Configuration dynamique de nixd selon le projet
    local function setup_nix_development()
      local flake_root = find_flake_root()
      if flake_root then
        print("Flake detected at: " .. flake_root)
      end
    end
    
    -- Fonction utilitaire pour débugger nixd
    _G.debug_nixd = function()
      local clients = vim.lsp.get_clients({ name = "nixd" })
      if #clients > 0 then
        print("nixd is running")
        for _, client in ipairs(clients) do
          print("Client ID:", client.id)
          print("Root dir:", client.config.root_dir)
          print("Settings:", vim.inspect(client.config.settings))
        end
      else
        print("nixd is not running")
      end
    end
    
    -- Setup au démarrage
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.defer_fn(setup_nix_development, 500)
      end,
    })
    
    -- Commandes personnalisées
    vim.api.nvim_create_user_command("NixdRestart", function()
      vim.cmd("LspRestart nixd")
      print("nixd restarted")
    end, { desc = "Restart nixd LSP server" })
    
    vim.api.nvim_create_user_command("NixFormat", function()
      require("conform").format({ 
        async = true, 
        lsp_fallback = true,
        filter = function(client)
          return client.name == "nixd"
        end
      })
      print("Formatted with nixpkgs-fmt")
    end, { desc = "Format current Nix file" })
  '';
}
