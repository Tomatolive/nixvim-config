{
  # =====================================================================
  # WHICH-KEY - Configuration corrigée pour which-key v3 (nixvim)
  # =====================================================================
  
  plugins.which-key = {
    enable = true;
    
    # Configuration principale pour which-key v3
    settings = {
      # Preset Helix comme LazyVim
      preset = "helix";
      
      # Délai d'affichage (200ms comme LazyVim)
      delay = 200;
      
      # Configuration des icônes
      icons = {
        breadcrumb = "»";
        separator = "➜";
        group = "+";
        ellipsis = "…";
        mappings = true;
        rules = false;
        colors = true;
      };
      
      # Configuration de la fenêtre popup
      win = {
        padding = [ 1 2 ];
        wo = {
          winblend = 10;
        };
      };
      
      # Layout
      layout = {
        width = { min = 20; max = 50; };
        height = { min = 4; max = 25; };
        spacing = 3;
        align = "center";
      };
      
      # Notifications
      notify = true;
    };
  };
  
  # =====================================================================
  # PLUGINS COMPLÉMENTAIRES
  # =====================================================================
  
  # Icônes pour mini.icons (recommandé par which-key v3)
  plugins.mini = {
    enable = true;
    modules = {
      icons = { };
    };
  };
  
  # Fallback si mini.icons n'est pas disponible
  plugins.web-devicons.enable = true;
  
  # =====================================================================
  # KEYMAPS POUR WHICH-KEY
  # =====================================================================
  
  keymaps = [
    # Keymap pour afficher which-key avec keymaps locaux
    {
      mode = "n"; 
      key = "<leader>?";
      action.__raw = ''
        function()
          require("which-key").show({ global = false })
        end
      '';
      options.desc = "Buffer Local Keymaps (which-key)";
    }
    
    # Keymap pour afficher tous les keymaps
    {
      mode = "n";
      key = "<leader>K";
      action.__raw = ''
        function()
          require("which-key").show({ global = true })
        end
      '';
      options.desc = "Show All Keymaps";
    }
    
    # Raccourci pour help
    {
      mode = "n";
      key = "<leader>h";
      action = ":help ";
      options.desc = "Help";
    }
  ];
  
  # =====================================================================
  # CONFIGURATION LUA SUPPLÉMENTAIRE
  # =====================================================================
  
  extraConfigLua = ''
    -- Configuration des couleurs which-key pour gruvbox (style compatible)
    local function setup_which_key_gruvbox_colors()
      -- Couleurs gruvbox adaptées (au lieu des couleurs Tokyo Night)
      local gruvbox_colors = {
        bg0 = "#282828",     -- gruvbox dark0
        bg1 = "#3c3836",     -- gruvbox dark1
        bg2 = "#504945",     -- gruvbox dark2
        fg0 = "#fbf1c7",     -- gruvbox light0
        fg1 = "#ebdbb2",     -- gruvbox light1
        red = "#fb4934",     -- gruvbox bright red
        green = "#b8bb26",   -- gruvbox bright green
        yellow = "#fabd2f",  -- gruvbox bright yellow
        blue = "#83a598",    -- gruvbox bright blue
        purple = "#d3869b",  -- gruvbox bright purple
        aqua = "#8ec07c",    -- gruvbox bright aqua
        orange = "#fe8019",  -- gruvbox bright orange
        gray = "#928374",    -- gruvbox gray
      }
      
      -- NOMS CORRECTS pour which-key v3 (différents de v2)
      vim.api.nvim_set_hl(0, "WhichKey", { 
        fg = gruvbox_colors.blue, 
        bold = true 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyGroup", { 
        fg = gruvbox_colors.purple 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyDesc", { 
        fg = gruvbox_colors.green 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeySeparator", { 
        fg = gruvbox_colors.gray 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyNormal", { 
        bg = gruvbox_colors.bg0,
        fg = gruvbox_colors.fg1
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyBorder", { 
        fg = gruvbox_colors.green,  -- Bordure verte pour plus de visibilité
        bg = "NONE" 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyValue", { 
        fg = gruvbox_colors.aqua 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyIcon", { 
        fg = gruvbox_colors.yellow 
      })
      
      vim.api.nvim_set_hl(0, "WhichKeyTitle", { 
        fg = gruvbox_colors.orange,
        bold = true 
      })
    end
    
    -- Fonction pour désactiver temporairement la transparence (debug)
    local function disable_transparency_for_debug()
      vim.api.nvim_set_hl(0, "WhichKeyNormal", { 
        bg = "#282828",  -- Arrière-plan solide pour debug
        fg = "#ebdbb2"
      })
    end
    
    -- Appliquer les couleurs après le chargement du colorscheme gruvbox
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "gruvbox*",
      callback = function()
        -- Petit délai pour s'assurer que gruvbox est complètement chargé
        vim.defer_fn(function()
          setup_which_key_gruvbox_colors()
        end, 50)
      end,
    })
    
    -- Appliquer au démarrage si gruvbox est déjà chargé
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.defer_fn(function()
          if vim.g.colors_name == "gruvbox" then
            setup_which_key_gruvbox_colors()
          end
        end, 100)
      end,
    })
    
    -- Éviter les conflits de keymaps
    local function safe_del_keymap(mode, key)
      pcall(vim.keymap.del, mode, key)
    end
    
    -- Supprimer les keymaps par défaut qui pourraient causer des conflits
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Attendre un peu pour que tous les plugins soient chargés
        vim.defer_fn(function()
          safe_del_keymap({"n", "i", "v"}, "<A-j>")
          safe_del_keymap("n", "<S-h>")
          safe_del_keymap("n", "<S-l>")
        end, 100)
      end,
    })
    
    -- Fonction utilitaire pour debug des couleurs
    _G.debug_which_key_colors = function()
      print("Current colorscheme:", vim.g.colors_name)
      disable_transparency_for_debug()
      print("Transparency disabled for which-key. Test with <leader> key.")
    end
    
    -- Fonction pour recharger les couleurs manuellement
    _G.reload_which_key_colors = function()
      setup_which_key_gruvbox_colors()
      print("Which-key colors reloaded!")
    end
    
    -- Ajout automatique des groupes which-key
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        local ok, wk = pcall(require, "which-key")
        if ok then
          -- Enregistrer des groupes principaux
          wk.add({
            { "<leader>", group = "Leader" },
            { "<leader>f", group = "Find/File" },
            { "<leader>g", group = "Git" },
            { "<leader>b", group = "Buffer" },
            { "<leader>w", group = "Window" },
            { "<leader>c", group = "Code" },
            { "<leader>u", group = "UI" },
            { "<leader>x", group = "Diagnostics" },
            { "<leader>t", group = "Terminal" },
            { "<leader>n", group = "Notifications" },
            { "g", group = "Goto" },
            { "[", group = "Previous" },
            { "]", group = "Next" },
            { "z", group = "Fold" },
          })
        end
      end,
    })
  '';
}
