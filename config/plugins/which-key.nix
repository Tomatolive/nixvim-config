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
      
      # ===================================================================
      # SPEC - Syntaxe corrigée pour which-key v3
      # ===================================================================
      # spec = [
      #   # ===============================================================
      #   # GROUPES PRINCIPAUX
      #   # ===============================================================
      #   {
      #     mode = [ "n" "v" ];
      #
      #     # Groupes file/find
      #     "<leader>f" = { group = "file/find"; icon = " "; };
      #     "<leader>ff" = { desc = "Find Files"; };
      #     "<leader>fg" = { desc = "Find Text (Grep)"; };
      #     "<leader>fr" = { desc = "Recent Files"; };
      #     "<leader>fb" = { desc = "Find Buffers"; };
      #     "<leader>fc" = { desc = "Command History"; };
      #     "<leader>fs" = { desc = "LSP Symbols"; };
      #     "<leader>fS" = { desc = "LSP Workspace Symbols"; };
      #
      #     # Groupes git
      #     "<leader>g" = { group = "git"; icon = " "; };
      #     "<leader>gg" = { desc = "Git Status"; };
      #     "<leader>gb" = { desc = "Git Blame"; };
      #     "<leader>gd" = { desc = "Git Diff"; };
      #     "<leader>gl" = { desc = "Git Log"; };
      #     "<leader>gp" = { desc = "Git Push"; };
      #     "<leader>gP" = { desc = "Git Pull"; };
      #     "<leader>gs" = { desc = "Git Stage"; };
      #     "<leader>gu" = { desc = "Git Unstage"; };
      #     "<leader>gr" = { desc = "Git Reset"; };
      #     "<leader>gc" = { desc = "Git Commit"; };
      #
      #     # Groupes buffer
      #     "<leader>b" = { group = "buffer"; icon = " "; };
      #     "<leader>bd" = { desc = "Delete Buffer"; };
      #     "<leader>bD" = { desc = "Delete All Buffers"; };
      #     "<leader>bp" = { desc = "Previous Buffer"; };
      #     "<leader>bn" = { desc = "Next Buffer"; };
      #     "<leader>bl" = { desc = "List Buffers"; };
      #     "<leader>bf" = { desc = "Find Buffer"; };
      #     "<leader>bs" = { desc = "Save Buffer"; };
      #     "<leader>br" = { desc = "Reload Buffer"; };
      #
      #     # Groupes windows
      #     "<leader>w" = { group = "windows"; icon = " "; };
      #     "<leader>wh" = { desc = "Go Left"; };
      #     "<leader>wj" = { desc = "Go Down"; };
      #     "<leader>wk" = { desc = "Go Up"; };
      #     "<leader>wl" = { desc = "Go Right"; };
      #     "<leader>ws" = { desc = "Split Horizontal"; };
      #     "<leader>wv" = { desc = "Split Vertical"; };
      #     "<leader>wc" = { desc = "Close Window"; };
      #     "<leader>wo" = { desc = "Only This Window"; };
      #     "<leader>w=" = { desc = "Balance Windows"; };
      #     "<leader>wr" = { desc = "Rotate Windows"; };
      #
      #     # Groupes code
      #     "<leader>c" = { group = "code"; icon = " "; };
      #     "<leader>ca" = { desc = "Code Action"; };
      #     "<leader>cr" = { desc = "Rename"; };
      #     "<leader>cf" = { desc = "Format"; };
      #     "<leader>cd" = { desc = "Definition"; };
      #     "<leader>cR" = { desc = "References"; };
      #     "<leader>ci" = { desc = "Implementation"; };
      #     "<leader>ct" = { desc = "Type Definition"; };
      #     "<leader>ch" = { desc = "Hover"; };
      #     "<leader>cs" = { desc = "Signature Help"; };
      #
      #     # Groupes UI
      #     "<leader>u" = { group = "ui"; icon = "󰙵 "; };
      #     "<leader>un" = { desc = "Dismiss Notifications"; };
      #     "<leader>ul" = { desc = "Toggle Line Numbers"; };
      #     "<leader>ur" = { desc = "Toggle Relative Numbers"; };
      #     "<leader>uw" = { desc = "Toggle Word Wrap"; };
      #     "<leader>uc" = { desc = "Colorscheme"; };
      #     "<leader>uh" = { desc = "Highlight Groups"; };
      #     "<leader>ui" = { desc = "Toggle Indent Guides"; };
      #     "<leader>us" = { desc = "Hide Status Line"; };
      #     "<leader>ut" = { desc = "Hide Tab Line"; };
      #
      #     # Groupes diagnostics
      #     "<leader>x" = { group = "diagnostics"; icon = "󱖫 "; };
      #     "<leader>xx" = { desc = "Quickfix List"; };
      #     "<leader>xl" = { desc = "Location List"; };
      #     "<leader>xd" = { desc = "Diagnostics"; };
      #     "<leader>xt" = { desc = "Todo Comments"; };
      #     "<leader>xw" = { desc = "Workspace Diagnostics"; };
      #     "<leader>xe" = { desc = "Show Line Diagnostics"; };
      #     "<leader>xn" = { desc = "Next Diagnostic"; };
      #     "<leader>xp" = { desc = "Previous Diagnostic"; };
      #
      #     # Groupes search
      #     "<leader>s" = { group = "search"; icon = " "; };
      #     "<leader>sg" = { desc = "Grep"; };
      #     "<leader>sf" = { desc = "Files"; };
      #     "<leader>sr" = { desc = "Replace"; };
      #     "<leader>sw" = { desc = "Word Under Cursor"; };
      #     "<leader>ss" = { desc = "Current Buffer"; };
      #     "<leader>sh" = { desc = "Help Tags"; };
      #     "<leader>sk" = { desc = "Keymaps"; };
      #     "<leader>sm" = { desc = "Man Pages"; };
      #
      #     # Groupes terminal
      #     "<leader>t" = { group = "terminal"; icon = " "; };
      #     "<leader>tt" = { desc = "Toggle Terminal"; };
      #     "<leader>th" = { desc = "Horizontal Terminal"; };
      #     "<leader>tv" = { desc = "Vertical Terminal"; };
      #     "<leader>tf" = { desc = "Floating Terminal"; };
      #     "<leader>tn" = { desc = "New Terminal"; };
      #     "<leader>tk" = { desc = "Kill Terminal"; };
      #
      #     # Groupes notifications
      #     "<leader>n" = { group = "notifications"; icon = " "; };
      #     "<leader>nh" = { desc = "Show History"; };
      #     "<leader>nd" = { desc = "Dismiss All"; };
      #     "<leader>nl" = { desc = "Last Notification"; };
      #     "<leader>nc" = { desc = "Clear History"; };
      #
      #     # Autres groupes
      #     "<leader><tab>" = { group = "tabs"; icon = " "; };
      #     "<leader>q" = { group = "quit/session"; icon = " "; };
      #
      #     # Which-key specific
      #     "<leader>?" = { desc = "Buffer Local Keymaps (which-key)"; };
      #     "<leader>K" = { desc = "Show All Keymaps"; };
      #     "<leader>h" = { desc = "Help"; };
      #   }
      #
      #   # ===============================================================
      #   # GROUPES DE NAVIGATION (mode normal uniquement)
      #   # ===============================================================
      #   {
      #     mode = "n";
      #
      #     # Goto group
      #     "g" = { group = "goto"; };
      #     "gd" = { desc = "Goto Definition"; };
      #     "gD" = { desc = "Goto Declaration"; };
      #     "gr" = { desc = "Goto References"; };
      #     "gi" = { desc = "Goto Implementation"; };
      #     "gt" = { desc = "Goto Type Definition"; };
      #     "gh" = { desc = "Hover Documentation"; };
      #     "gs" = { desc = "Signature Help"; };
      #     "gx" = { desc = "Open with system app"; };
      #     "gf" = { desc = "Go to File"; };
      #
      #     # Previous navigation
      #     "[" = { group = "prev"; };
      #     "[d" = { desc = "Previous Diagnostic"; };
      #     "[h" = { desc = "Previous Hunk"; };
      #     "[q" = { desc = "Previous Quickfix"; };
      #     "[l" = { desc = "Previous Location"; };
      #     "[b" = { desc = "Previous Buffer"; };
      #     "[t" = { desc = "Previous Tab"; };
      #     "[e" = { desc = "Previous Error"; };
      #     "[w" = { desc = "Previous Warning"; };
      #
      #     # Next navigation
      #     "]" = { group = "next"; };
      #     "]d" = { desc = "Next Diagnostic"; };
      #     "]h" = { desc = "Next Hunk"; };
      #     "]q" = { desc = "Next Quickfix"; };
      #     "]l" = { desc = "Next Location"; };
      #     "]b" = { desc = "Next Buffer"; };
      #     "]t" = { desc = "Next Tab"; };
      #     "]e" = { desc = "Next Error"; };
      #     "]w" = { desc = "Next Warning"; };
      #
      #     # Fold operations
      #     "z" = { group = "fold"; };
      #     "za" = { desc = "Toggle fold"; };
      #     "zc" = { desc = "Close fold"; };
      #     "zo" = { desc = "Open fold"; };
      #     "zm" = { desc = "Close all folds"; };
      #     "zr" = { desc = "Open all folds"; };
      #     "zf" = { desc = "Create fold"; };
      #     "zd" = { desc = "Delete fold"; };
      #     "zE" = { desc = "Eliminate all folds"; };
      #   }
      #
      #   # ===============================================================
      #   # KEYMAPS PERSONNALISÉS JKLM
      #   # ===============================================================
      #   {
      #     mode = [ "n" "v" "o" ];
      #
      #     "j" = { desc = "Move left (custom)"; };
      #     "k" = { desc = "Move down (custom)"; };
      #     "l" = { desc = "Move up (custom)"; };
      #     "m" = { desc = "Move right (custom)"; };
      #   }
      #
      #   {
      #     mode = "n";
      #     "§" = { desc = "Set mark (custom)"; };
      #   }
      # ];
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
    -- Configuration des couleurs which-key (style LazyVim/Tokyo Night)
    local function setup_which_key_colors()
     vim.api.nvim_set_hl(0, "WhichKey", { fg = "#7aa2f7", bold = true })
      vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = "#bb9af7" })
      vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = "#9ece6a" })
      vim.api.nvim_set_hl(0, "WhichKeySeperator", { fg = "#565f89" })
      vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "#1a1b26" })
      vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = "#565f89" })
      vim.api.nvim_set_hl(0, "WhichKeyValue", { fg = "#73daca" })
      vim.api.nvim_set_hl(0, "WhichKeyIcon", { fg = "#7aa2f7" })
    end
    
    -- Attendre que which-key soit chargé avant de configurer
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Configuration des couleurs
        setup_which_key_colors()
        
        -- Ajouter des groupes additionnels si nécessaire
        local ok, wk = pcall(require, "which-key")
        if ok then
          -- Enregistrer des groupes supplémentaires si besoin
          wk.add({
            { "<leader>", group = "Leader" },
            { "g", group = "Goto" },
            { "[", group = "Previous" },
            { "]", group = "Next" },
            { "z", group = "Fold" },
          })
        end
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
  '';
}
