{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION C/C++ - Avec keymaps locaux
  # =====================================================================

  # =====================================================================
  # CLANGD_EXTENSIONS.NVIM - Zero config, excellents défauts
  # =====================================================================
  plugins.clangd-extensions = {
    enable = true;
    # Tous les défauts sont parfaits, on ne configure que les bordures
    settings = {
      memory_usage.border = "rounded";
      symbol_info.border = "rounded";
    };
  };

  # =====================================================================
  # CLANGD LSP - Nixvim a d'excellents défauts, juste l'essentiel
  # =====================================================================
  plugins.lsp.servers.clangd = {
    enable = true;
  };

  # =====================================================================
  # PACKAGES ESSENTIELS
  # =====================================================================
  extraPackages = with pkgs; [
    # Essentiel : clang-tools inclut clangd, clang-format, clang-tidy
    clang-tools

    # Utile : pour générer compile_commands.json
    bear
  ];

  # =====================================================================
  # AUTOCOMMANDS AVEC KEYMAPS LOCAUX
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "c" "cpp" ];
      callback.__raw = ''
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          
          -- Options d'indentation
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.commentstring = "// %s"
          
          -- KEYMAPS LOCAUX - Seulement pour les buffers C/C++ !
          local opts = { buffer = bufnr, desc = "" }
          
          -- Clangd AST
          opts.desc = "View AST"
          vim.keymap.set("n", "<leader>Ca", "<cmd>ClangdAST<cr>", opts)
          vim.keymap.set("v", "<leader>Ca", ":<C-u>ClangdAST<cr>", opts)
          
          -- Symbol Info
          opts.desc = "Symbol Info"
          vim.keymap.set("n", "<leader>Cs", "<cmd>ClangdSymbolInfo<cr>", opts)
          
          -- Type Hierarchy
          opts.desc = "Type Hierarchy"
          vim.keymap.set("n", "<leader>Ct", "<cmd>ClangdTypeHierarchy<cr>", opts)
          
          -- Memory Usage
          opts.desc = "Memory Usage"
          vim.keymap.set("n", "<leader>Cm", "<cmd>ClangdMemoryUsage<cr>", opts)
          
          -- Switch Header/Source
          opts.desc = "Switch Header/Source"
          vim.keymap.set("n", "<leader>Ch", "<cmd>ClangdSwitchSourceHeader<cr>", opts)
          
          -- Generate compile_commands.json
          opts.desc = "Generate compile_commands.json"
          vim.keymap.set("n", "<leader>Cc", "<cmd>GenerateCompileCommands<cr>", opts)
          
          -- Create compile_flags.txt
          opts.desc = "Create compile_flags.txt"
          vim.keymap.set("n", "<leader>Cf", "<cmd>CreateCompileFlags<cr>", opts)
          
          -- Configuration which-key pour ce buffer seulement
          vim.defer_fn(function()
            local ok, wk = pcall(require, "which-key")
            if ok then
              wk.add({
                { "<leader>C", group = "C/C++", icon = { icon = "󰙱", color = "blue" } buffer = bufnr },
              })
            end
          end, 100)
        end
      '';
    }
  ];

  # =====================================================================
  # COMMANDES UTILES SIMPLIFIÉES
  # =====================================================================
  extraConfigLua = ''
    -- Commande pour générer compile_commands.json
    vim.api.nvim_create_user_command("GenerateCompileCommands", function()
      local cwd = vim.fn.getcwd()
      
      if vim.fn.filereadable(cwd .. "/Makefile") == 1 then
        require("snacks").terminal.open("bear -- make clean && bear -- make")
      elseif vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then  
        require("snacks").terminal.open("cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build && cp build/compile_commands.json .")
      else
        require("snacks").notify("No Makefile or CMakeLists.txt found", { level = "warn" })
      end
    end, { desc = "Generate compile_commands.json" })
    
    -- Commande pour créer compile_flags.txt (fallback simple)
    vim.api.nvim_create_user_command("CreateCompileFlags", function()
      local flags = {
        "-std=c++17",
        "-Wall",
        "-Wextra",
        "-I.",
        "-I./include",
        "-I/usr/include",
        "-I/usr/local/include"
      }
      
      local content = table.concat(flags, "\n") .. "\n"
      local file = io.open("compile_flags.txt", "w")
      if file then
        file:write(content)
        file:close()
        require("snacks").notify("Created compile_flags.txt", { title = "C/C++" })
      else
        require("snacks").notify("Failed to create compile_flags.txt", { level = "error" })
      end
    end, { desc = "Create compile_flags.txt" })
  '';
}
