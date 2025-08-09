{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION HASKELL - Avec keymaps locaux
  # =====================================================================

  # =====================================================================
  # HASKELL-TOOLS.NVIM - Fonctionne "out of the box"
  # =====================================================================
  extraPlugins = with pkgs.vimPlugins; [
    haskell-tools-nvim
  ];

  plugins = {
    treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      haskell
    ];

    conform-nvim.settings.formatters_by_ft = {
      haskell = [ "ormolu" ];
    };

    lint.lintersByFt = {
      haskell = [ "hlint" ];
    };
  };

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
    ormolu
    hlint

    # Outils additionnels
    haskellPackages.hoogle
    ghcid
  ];

  # =====================================================================
  # AUTOCOMMANDS AVEC KEYMAPS LOCAUX - Solution propre !
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "haskell" "lhaskell" ];
      callback.__raw = ''
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          
          -- Options d'indentation
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.commentstring = "-- %s"
          
          -- KEYMAPS LOCAUX - Seulement pour les buffers Haskell !
          local opts = { buffer = bufnr, desc = "" }
          
          -- REPL
          opts.desc = "Toggle REPL"
          vim.keymap.set("n", "<leader>hr", function()
            require('haskell-tools').repl.toggle()
          end, opts)
          
          -- Load file
          opts.desc = "Load file in REPL"
          vim.keymap.set("n", "<leader>hl", function()
            local file = vim.api.nvim_buf_get_name(0)
            if file ~= "" then
              require('haskell-tools').repl.load_file(file)
            else
              require('haskell-tools').repl.toggle()
            end
          end, opts)
          
          -- Evaluate
          opts.desc = "Evaluate in REPL"
          vim.keymap.set({"n", "v"}, "<leader>he", function()
            require('haskell-tools').repl.operator()
          end, opts)
          
          -- Hoogle search
          opts.desc = "Hoogle Search"
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
          end, opts)
          
          -- Evaluate all
          opts.desc = "Evaluate All"
          vim.keymap.set("n", "<leader>hc", function()
            require('haskell-tools').lsp.buf_eval_all()
          end, opts)
          
          -- Configuration which-key pour ce buffer seulement
          vim.defer_fn(function()
            local ok, wk = pcall(require, "which-key")
            if ok then
              wk.add({
                { "<leader>h", group = "Haskell", icon = { icon = "󰲒", color = "purple" }, buffer = bufnr },
              })
            end
          end, 100)
        end
      '';
    }
  ];

  extraConfigLua = ''
    local ht = require('haskell-tools')
    local bufnr = vim.api.nvim_get_current_buf()
  '';
}
