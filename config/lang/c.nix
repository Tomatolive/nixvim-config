{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION C/C++ - Version minimaliste 
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
    
    -- Notification simple
    vim.defer_fn(function()
      require("snacks").notify("C/C++ ready", { title = "clangd", timeout = 1000 })
    end, 1000)
  '';
}
