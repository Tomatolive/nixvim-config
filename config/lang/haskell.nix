{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION HASKELL - Conforme aux recommandations haskell-tools
  # =====================================================================

  # =====================================================================
  # HASKELL-TOOLS.NVIM - Fonctionne "out of the box"
  # =====================================================================
  extraPlugins = with pkgs.vimPlugins; [
    haskell-tools-nvim
  ];

  # =====================================================================
  # ⚠️  PAS DE LSP HLS - haskell-tools gère automatiquement !
  # Conflit si on configure les deux selon les docs officielles
  # =====================================================================
  # plugins.lsp.servers.hls = {
  #   enable = true;  # ← SUPPRIMÉ pour éviter conflits
  # };

  # =====================================================================
  # PACKAGES REQUIS
  # =====================================================================
  extraPackages = with pkgs; [
    # Compilateur Haskell
    ghc
    cabal-install
    stack
    
    # Language Server (géré automatiquement par haskell-tools)
    haskell-language-server
    
    # Outils additionnels
    haskellPackages.hoogle
    ghcid
  ];

  # =====================================================================
  # AUTOCOMMANDS MINIMAUX (indentation seulement)
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "haskell" "lhaskell" ];
      callback.__raw = ''
        function()
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.commentstring = "-- %s"
        end
      '';
    }
  ];

  # =====================================================================
  # CONFIGURATION CONFORME - Presque pas de Lua !
  # =====================================================================
  extraConfigLua = ''
    -- ===================================================================
    -- CONFIGURATION HASKELL-TOOLS (conforme aux docs officielles)
    -- ===================================================================
    
    -- Configuration AVANT le chargement du plugin (seule façon correcte)
    vim.g.haskell_tools = {
      tools = {
        repl = {
          handler = 'builtin',
          auto_focus = true,
        },
        hover = {
          border = 'rounded',
        },
      },
      -- PAS de configuration hls - haskell-tools gère automatiquement
    }
    
    -- ===================================================================
    -- KEYMAPS - Méthode recommandée par les docs
    -- ===================================================================
    
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "haskell", "lhaskell" },
      callback = function()
        local opts = { buffer = true, silent = true }
        
        -- Keymaps recommandés par haskell-tools
        vim.keymap.set("n", "<leader>hr", function()
          require('haskell-tools').repl.toggle()
        end, vim.tbl_extend("force", opts, { desc = "Toggle REPL" }))
        
        vim.keymap.set("n", "<leader>hl", function()
          local file = vim.api.nvim_buf_get_name(0)
          if file ~= "" then
            require('haskell-tools').repl.load_file(file)
          else
            require('haskell-tools').repl.toggle()
          end
        end, vim.tbl_extend("force", opts, { desc = "Load file in REPL" }))
        
        vim.keymap.set({ "n", "v" }, "<leader>he", function()
          require('haskell-tools').repl.operator()
        end, vim.tbl_extend("force", opts, { desc = "Evaluate in REPL" }))
        
        -- Hoogle simple (pas besoin de haskell-tools pour ça)
        vim.keymap.set("n", "<leader>hs", function()
          local word = vim.fn.expand('<cword>')
          if word and word ~= "" then
            if vim.fn.executable('hoogle') == 1 then
              require("snacks").terminal.open("hoogle --info " .. vim.fn.shellescape(word), {
                title = "Hoogle - " .. word,
                size = { width = 0.8, height = 0.6 }
              })
            else
              require("snacks").notify("hoogle not available", { title = "Haskell", level = "warn" })
            end
          end
        end, vim.tbl_extend("force", opts, { desc = "Hoogle Search" }))
        
        -- Keymaps additionnels recommandés par haskell-tools
        vim.keymap.set("n", "<leader>hc", function()
          require('haskell-tools').lsp.buf_eval_all()
        end, vim.tbl_extend("force", opts, { desc = "Evaluate All" }))
      end,
    })
    
    -- ===================================================================
    -- COMMANDES SIMPLES
    -- ===================================================================
    
    vim.api.nvim_create_user_command("HaskellRepl", function()
      require('haskell-tools').repl.toggle()
    end, { desc = "Toggle Haskell REPL" })
    
    vim.api.nvim_create_user_command("HaskellLoad", function()
      local file = vim.api.nvim_buf_get_name(0)
      if file ~= "" then
        require('haskell-tools').repl.load_file(file)
      else
        require('haskell-tools').repl.toggle()
      end
    end, { desc = "Load file in REPL" })
    
    -- Message de confirmation
    vim.defer_fn(function()
      require("snacks").notify("Haskell tools configured (auto-managed)", { 
        title = "Haskell", 
        timeout = 1500 
      })
    end, 1000)
  '';
}
