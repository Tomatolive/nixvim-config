{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION NIX - Spécificités uniquement
  # LSP/Format/Lint gérés par l'écosystème unifié dans lang/default.nix
  # =====================================================================
  
  # =====================================================================
  # LSP - nixd SPÉCIFIQUE (configuration sera override par l'écosystème)
  # =====================================================================
  plugins.lsp.servers.nixd = {
    enable = true;
    
    settings = {
      # Configuration nixpkgs allégée pour performance
      nixpkgs = {
        expr = "import <nixpkgs> { }";
      };
      
      # Formatage désactivé (géré par conform dans l'écosystème unifié)
      formatting = {
        command = null;
      };
      
      # Options réduites pour performance
      # Décommentez si vous avez besoin de completion NixOS/Home-Manager :
      options = {
        # nixos = {
        #   expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.HOSTNAME.options";
        # };
        # home_manager = {
        #   expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.USERNAME.options";
        # };
      };
      
      # Paramètres de performance
      diagnostic = {
        suppress = [ "sema-escaping-with" ];
      };
    };
  };
  
  # =====================================================================
  # ALTERNATIVE RAPIDE : nil LSP
  # Décommentez et désactivez nixd pour une expérience plus rapide
  # =====================================================================
  
  # plugins.lsp.servers.nil-ls = {
  #   enable = true;
  #   settings = {
  #     formatting = {
  #       command = [ "nixpkgs-fmt" ]; # Sera ignoré par l'écosystème unifié
  #     };
  #   };
  # };
  
  # =====================================================================
  # PACKAGES SPÉCIFIQUES NIX (les formatters/linters sont dans default.nix)
  # =====================================================================
  extraPackages = with pkgs; [
    # LSP seulement
    nixd
    # nil # Décommentez si vous utilisez nil au lieu de nixd
  ];
  
  # =====================================================================
  # AUTOCOMMANDS SPÉCIFIQUES NIX
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
          
          -- Configuration Blink pour nixd (lent) - privilégier sources rapides
          local blink_ok, blink = pcall(require, 'blink.cmp')
          if blink_ok and blink.update_sources then
            pcall(function()
              blink.update_sources({
                per_filetype = {
                  nix = { "buffer", "snippets", "lsp", "path" }  -- LSP en 3e position
                }
              })
            end)
          end
        end
      '';
    }
  ];
  
  # =====================================================================
  # FONCTIONS SPÉCIFIQUES NIX - Build, Check, Eval
  # (pas liées à l'écosystème LSP standard)
  # =====================================================================
  extraConfigLua = ''
    -- ===================================================================
    -- FONCTIONS UTILITAIRES SPÉCIFIQUES NIX
    -- ===================================================================
    
    -- Fonction pour tester les performances nixd (diagnostic)
    _G.test_nixd_performance = function()
      print("=== nixd Performance Test ===")
      
      local clients = vim.lsp.get_clients({ name = "nixd" })
      if #clients > 0 then
        print("nixd active")
        for _, client in ipairs(clients) do
          print("  Client ID: " .. client.id)
          print("  Root dir: " .. (client.config.root_dir or "none"))
          
          local flags = client.config.flags or {}
          print("  Debounce: " .. (flags.debounce_text_changes or "default"))
          print("  Incremental sync: " .. tostring(flags.allow_incremental_sync or false))
        end
      else
        print("nixd not active")
      end
      
      print("")
      print("Performance test:")
      print("1. Type 'pkgs.' in a .nix file")
      print("2. Observe completion delay")
      print("3. If too slow, consider switching to nil LSP")
      print("")
      print("Ecosystem status:")
      print("  Format: managed by conform (nixpkgs-fmt)")
      print("  Lint: managed by nvim-lint + none-ls (deadnix, statix)")
      print("  Actions: managed by unified LSP + none-ls")
    end
    
    -- Fonction pour suggérer nil comme alternative
    _G.suggest_nil_alternative = function()
      print("=== Alternative: nil LSP ===")
      print("")
      print("nixd: + Full nixpkgs completion, - Slow")
      print("nil:  + Fast, - Basic completion only")
      print("")
      print("To switch to nil:")
      print("1. In config/lang/nix.nix:")
      print("   - Set nixd: enable = false")
      print("   - Set nil-ls: enable = true")
      print("2. Add 'nil' to extraPackages")
      print("3. Rebuild with 'nix run .'")
      print("")
      print("Note: Formatting/Linting will work the same with both!")
    end
    
    -- Fonctions de build/check Nix (spécifiques au langage)
    _G.nix_build_current = function()
      local file = vim.api.nvim_buf_get_name(0)
      if not file or file == "" then
        require("snacks").notify("No file to build", { title = "Nix" })
        return
      end
      
      local is_flake = vim.fn.findfile('flake.nix', '.;') ~= ""
      local cmd
      
      if is_flake then
        cmd = "nix build --no-link --show-trace"
      else
        cmd = "nix-build " .. vim.fn.shellescape(file)
      end
      
      require("snacks").terminal.open(cmd, {
        cwd = vim.fn.getcwd(),
        title = "Nix Build",
        size = { width = 0.8, height = 0.6 }
      })
    end
    
    _G.nix_check_current = function()
      local file = vim.api.nvim_buf_get_name(0)
      if not file or file == "" then
        require("snacks").notify("No file to check", { title = "Nix" })
        return
      end
      
      local is_flake = vim.fn.findfile('flake.nix', '.;') ~= ""
      local cmd
      
      if is_flake then
        cmd = "nix flake check --show-trace"
      else
        cmd = "nix-instantiate --parse " .. vim.fn.shellescape(file)
      end
      
      require("snacks").terminal.open(cmd, {
        cwd = vim.fn.getcwd(), 
        title = "Nix Check",
        size = { width = 0.8, height = 0.6 }
      })
    end
    
    _G.nix_eval_expression = function()
      local expr = vim.fn.input("Nix expression: ")
      if expr and expr ~= "" then
        local cmd = "nix eval --expr '" .. expr .. "'"
        require("snacks").terminal.open(cmd, {
          title = "Nix Eval",
          size = { width = 0.8, height = 0.4 }
        })
      end
    end
    
    _G.nix_develop = function()
      local is_flake = vim.fn.findfile('flake.nix', '.;') ~= ""
      if is_flake then
        require("snacks").terminal.open("nix develop", {
          title = "Nix Develop",
          size = { width = 0.9, height = 0.7 }
        })
      else
        require("snacks").notify(
          "No flake.nix found - nix develop requires a flake",
          { title = "Nix", level = "warn" }
        )
      end
    end
    
    _G.nix_show_flake = function()
      local is_flake = vim.fn.findfile('flake.nix', '.;') ~= ""
      if is_flake then
        require("snacks").terminal.open("nix flake show", {
          title = "Flake Outputs",
          size = { width = 0.8, height = 0.6 }
        })
      else
        require("snacks").notify(
          "No flake.nix found",
          { title = "Nix", level = "warn" }
        )
      end
    end
    
    -- ===================================================================
    -- COMMANDES SPÉCIFIQUES NIX
    -- ===================================================================
    
    vim.api.nvim_create_user_command("NixdPerformance", function()
      test_nixd_performance()
    end, { desc = "Test nixd performance and ecosystem status" })
    
    vim.api.nvim_create_user_command("SuggestNil", function()
      suggest_nil_alternative()
    end, { desc = "Info about nil LSP alternative" })
    
    vim.api.nvim_create_user_command("NixBuild", function()
      nix_build_current()
    end, { desc = "Build current Nix file/flake" })
    
    vim.api.nvim_create_user_command("NixCheck", function()
      nix_check_current()  
    end, { desc = "Check current Nix file/flake" })
    
    vim.api.nvim_create_user_command("NixEval", function()
      nix_eval_expression()
    end, { desc = "Evaluate Nix expression" })
    
    vim.api.nvim_create_user_command("NixDevelop", function()
      nix_develop()
    end, { desc = "Enter nix develop shell" })
    
    vim.api.nvim_create_user_command("NixShow", function()
      nix_show_flake()
    end, { desc = "Show flake outputs" })
    
    print("Nix language configuration loaded (ecosystem managed globally)")
  '';
}
