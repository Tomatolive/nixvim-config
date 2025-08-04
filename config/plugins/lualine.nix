{
  # =====================================================================
  # LUALINE - StatusLine moderne style LazyVim
  # =====================================================================

  plugins.lualine = {
    enable = true;

      settings = {
    #     # =====================================================================
    #     # CONFIGURATION GLOBALE
    #     # =====================================================================
        options = {
    #       theme = "gruvbox-material"; # Thème gruvbox
    #       component_separators = {
    #         left = "";
    #         right = "";
    #       };
    #       section_separators = {
    #         left = "";
    #         right = "";
    #       };
          disabled_filetypes = {
            statusline = [ "dashboard" "alpha" "starter" ];
            winbar = [ ];
          };
    #       ignore_focus = [ ];
    #       always_divide_middle = true;
    #       globalstatus = true; # Statusline globale (LazyVim style)
    #       refresh = {
    #         statusline = 1000;
    #         tabline = 1000;
    #         winbar = 1000;
    #       };
        };
    #
    #     # =====================================================================
    #     # SECTIONS - Layout LazyVim
    #     # =====================================================================
    #     sections = {
    #       # Section A (gauche) - Mode et Git
    #       lualine_a = [
    #         {
    #           __unkeyed-1 = "mode";
    #         }
    #       ];
    #
    #       # Section B - Branche Git
    #       lualine_b = [
    #         {
    #           __unkeyed-1 = "branch";
    #         }
    #       ];
    #
    #       # Section C - Fichier et diagnostics
    #       lualine_c = [
    #         {
    #           __unkeyed-1 = "diagnostics";
    #           sources = [ "nvim_lsp" "nvim_diagnostic" ];
    #           sections = [ "error" "warn" "info" "hint" ];
    #           diagnostics_color = {
    #             error = "DiagnosticError";
    #             warn = "DiagnosticWarn";
    #             info = "DiagnosticInfo";
    #             hint = "DiagnosticHint";
    #           };
    #           symbols = {
    #             error = " ";
    #             warn = " ";
    #             info = " ";
    #             hint = "󰌵 ";
    #           };
    #           colored = true;
    #           update_in_insert = false;
    #           always_visible = false;
    #         }
    #         {
    #           __unkeyed-1 = "filename";
    #           file_status = true;
    #           newfile_status = false;
    #           path = 1; # Nom relatif
    #           symbols = {
    #             modified = "●";
    #             readonly = "";
    #             unnamed = "[No Name]";
    #             newfile = "[New]";
    #           };
    #         }
    #       ];
    #
    #       # Section X (droite) - LSP et Formatters
    #       lualine_x = [
    #         # LSP clients actifs
    #         {
    #           __unkeyed-1.__raw = ''
    #             function()
    #               local clients = vim.lsp.get_clients({ bufnr = 0 })
    #               if #clients == 0 then
    #                 return ""
    #               end
    #
    #               local client_names = {}
    #               for _, client in ipairs(clients) do
    #                 table.insert(client_names, client.name)
    #               end
    #
    #               return "󰒋 " .. table.concat(client_names, " ")
    #             end
    #           '';
    #           icon = "󰒋";
    #           color = {
    #             fg = "#83a598";
    #           }; # Bleu gruvbox
    #         }
    #
    #         # Formatters (conform.nvim)
    #         {
    #           __unkeyed-1.__raw = ''
    #             function()
    #               local ok, conform = pcall(require, "conform")
    #               if not ok then
    #                 return ""
    #               end
    #
    #               local formatters = conform.list_formatters()
    #               if #formatters == 0 then
    #                 return ""
    #               end
    #
    #               local formatter_names = {}
    #               for _, formatter in ipairs(formatters) do
    #                 table.insert(formatter_names, formatter.name)
    #               end
    #
    #               return " " .. table.concat(formatter_names, " ")
    #             end
    #           '';
    #           color = {
    #             fg = "#b8bb26";
    #           }; # Vert gruvbox
    #         }
    #
    #         # Treesitter
    #         {
    #           __unkeyed-1.__raw = ''
    #             function()
    #               local ok, ts = pcall(require, "nvim-treesitter.parsers")
    #               if not ok then
    #                 return ""
    #               end
    #
    #               local buf = vim.api.nvim_get_current_buf()
    #               local ft = vim.api.nvim_buf_get_option(buf, "filetype")
    #               local lang = ts.get_parser_configs()[ft]
    #
    #               if lang then
    #                 return " " .. ft
    #               else
    #                 return ""
    #               end
    #             end
    #           '';
    #           color = {
    #             fg = "#fe8019";
    #           }; # Orange gruvbox
    #         }
    #       ];
    #
    #       # Section Y - Encodage et type de fichier
    #       lualine_y = [
    #         {
    #           __unkeyed-1 = "encoding";
    #           fmt.__raw = ''
    #             function(str)
    #               return str:upper()
    #             end
    #           '';
    #         }
    #         {
    #           __unkeyed-1 = "fileformat";
    #           symbols = {
    #             unix = "LF";
    #             dos = "CRLF";
    #             mac = "CR";
    #           };
    #         }
    #         {
    #           __unkeyed-1 = "filetype";
    #           colored = true;
    #           icon_only = false;
    #           icon = {
    #             align = "right";
    #           };
    #         }
    #       ];
    #
    #       # Section Z - Position dans le fichier
    #       lualine_z = [
    #         {
    #           __unkeyed-1 = "progress";
    #           separator = { right = ""; };
    #           left_padding = 2;
    #         }
    #         {
    #           __unkeyed-1 = "location";
    #           padding = { left = 0; right = 1; };
    #         }
    #       ];
    #     };
    #
    #     # =====================================================================
    #     # SECTIONS INACTIVES
    #     # =====================================================================
    #     inactive_sections = {
    #       lualine_a = [ ];
    #       lualine_b = [ ];
    #       lualine_c = [
    #         {
    #           __unkeyed-1 = "filename";
    #           file_status = true;
    #           path = 1;
    #         }
    #       ];
    #       lualine_x = [ "location" ];
    #       lualine_y = [ ];
    #       lualine_z = [ ];
    #     };
    #
    #     # =====================================================================
    #     # TABLINE - Désactivée (utilise bufferline)
    #     # =====================================================================
    #     tabline = { };
    #
    #     # =====================================================================
    #     # WINBAR - Désactivée
    #     # =====================================================================
    #     winbar = { };
    #     inactive_winbar = { };
    #
    #     # =====================================================================
    #     # EXTENSIONS
    #     # =====================================================================
    #     extensions = [
    #       "nvim-tree"
    #       "toggleterm"
    #       "quickfix"
    #       "fugitive"
    #       "neo-tree"
    #       "fzf"
    #       "man"
    #     ];
    #   };
    };
    #
    # # =====================================================================
    # # CONFIGURATION SUPPLÉMENTAIRE LUA
    # # =====================================================================
    # extraConfigLua = ''
    #   -- ===================================================================
    #   -- CONFIGURATION AVANCÉE LUALINE
    #   -- ===================================================================
    #
    #   -- Fonction pour afficher le statut git personnalisé
    #   local function git_status()
    #     local ok, gitsigns = pcall(require, "gitsigns")
    #     if not ok then
    #       return ""
    #     end
    #
    #     local status = vim.b.gitsigns_status_dict
    #     if not status then
    #       return ""
    #     end
    #
    #     local added = status.added or 0
    #     local changed = status.changed or 0
    #     local removed = status.removed or 0
    #
    #     local result = {}
    #     if added > 0 then
    #       table.insert(result, "+" .. added)
    #     end
    #     if changed > 0 then
    #       table.insert(result, "~" .. changed)
    #     end
    #     if removed > 0 then
    #       table.insert(result, "-" .. removed)
    #     end
    #
    #     if #result > 0 then
    #       return " [" .. table.concat(result, " ") .. "]"
    #     else
    #       return ""
    #     end
    #   end
    #
    #   -- Fonction pour afficher le statut des macros
    #   local function macro_recording()
    #     local recording = vim.fn.reg_recording()
    #     if recording ~= "" then
    #       return "󰑊 Recording @" .. recording
    #     else
    #       return ""
    #     end
    #   end
    #
    #   -- Fonction pour afficher le nombre de buffers
    #   local function buffer_count()
    #     local buffers = vim.fn.len(vim.fn.filter(range(1, vim.fn.bufnr('$')), 'buflisted(v:val)'))
    #     return "󰓩 " .. buffers
    #   end
    #
    #   -- Fonction pour afficher l'indentation
    #   local function indent_style()
    #     local expandtab = vim.bo.expandtab
    #     local shiftwidth = vim.bo.shiftwidth
    #
    #     if expandtab then
    #       return "Spaces: " .. shiftwidth
    #     else
    #       return "Tabs: " .. shiftwidth
    #     end
    #   end
    #
    #   -- Attendre que lualine soit chargée pour ajouter des composants personnalisés
    #   vim.defer_fn(function()
    #     local ok, lualine = pcall(require, "lualine")
    #     if not ok then
    #       return
    #     end
    #
    #     -- Recharger avec composants personnalisés
    #     lualine.setup({
    #       sections = {
    #         lualine_c = {
    #           {
    #             "filename",
    #             file_status = true,
    #             newfile_status = false,
    #             path = 1,
    #             symbols = {
    #               modified = "●",
    #               readonly = "",
    #               unnamed = "[No Name]",
    #               newfile = "[New]",
    #             },
    #           },
    #           {
    #             git_status,
    #             color = { fg = "#d3869b" },  -- Purple gruvbox
    #           },
    #           {
    #             "diagnostics",
    #             sources = { "nvim_lsp", "nvim_diagnostic" },
    #             sections = { "error", "warn", "info", "hint" },
    #             symbols = {
    #               error = " ",
    #               warn = " ",
    #               info = " ",
    #               hint = "󰌵 ",
    #             },
    #             colored = true,
    #           },
    #         },
    #         lualine_x = {
    #           {
    #             macro_recording,
    #             color = { fg = "#fb4934" },  -- Red gruvbox
    #           },
    #           {
    #             function()
    #               local clients = vim.lsp.get_clients({ bufnr = 0 })
    #               if #clients == 0 then
    #                 return ""
    #               end
    #
    #               local client_names = {}
    #               for _, client in ipairs(clients) do
    #                 table.insert(client_names, client.name)
    #               end
    #
    #               return "󰒋 " .. table.concat(client_names, " ")
    #             end,
    #             color = { fg = "#83a598" },
    #           },
    #           {
    #             function()
    #               local ok, conform = pcall(require, "conform")
    #               if not ok then
    #                 return ""
    #               end
    #
    #               local formatters = conform.list_formatters()
    #               if #formatters == 0 then
    #                 return ""
    #               end
    #
    #               local formatter_names = {}
    #               for _, formatter in ipairs(formatters) do
    #                 table.insert(formatter_names, formatter.name)
    #               end
    #
    #               return " " .. table.concat(formatter_names, " ")
    #             end,
    #             color = { fg = "#b8bb26" },
    #           },
    #         },
    #       },
    #     })
    #
    #     print("Lualine enhanced components loaded")
    #   end, 1000)
    #
    #   -- ===================================================================
    #   -- HIGHLIGHTS PERSONNALISÉS
    #   -- ===================================================================
    #
    #   vim.api.nvim_create_autocmd("ColorScheme", {
    #     callback = function()
    #       -- Ajuster les couleurs lualine pour gruvbox
    #       vim.api.nvim_set_hl(0, "lualine_a_normal", { 
    #         fg = "#282828", 
    #         bg = "#83a598", 
    #         bold = true 
    #       })
    #       vim.api.nvim_set_hl(0, "lualine_a_insert", { 
    #         fg = "#282828", 
    #         bg = "#b8bb26", 
    #         bold = true 
    #       })
    #       vim.api.nvim_set_hl(0, "lualine_a_visual", { 
    #         fg = "#282828", 
    #         bg = "#fe8019", 
    #         bold = true 
    #       })
    #       vim.api.nvim_set_hl(0, "lualine_a_replace", { 
    #         fg = "#282828", 
    #         bg = "#fb4934", 
    #         bold = true 
    #       })
    #       vim.api.nvim_set_hl(0, "lualine_a_command", { 
    #         fg = "#282828", 
    #         bg = "#d3869b", 
    #         bold = true 
    #       })
    #
    #       -- Couleurs des sections
    #       vim.api.nvim_set_hl(0, "lualine_b_normal", { 
    #         fg = "#ebdbb2", 
    #         bg = "#504945" 
    #       })
    #       vim.api.nvim_set_hl(0, "lualine_c_normal", { 
    #         fg = "#a89984", 
    #         bg = "#3c3836" 
    #       })
    #     end,
    #   })
    #
    #   -- Appliquer immédiatement
    #   vim.defer_fn(function()
    #     vim.cmd("doautocmd ColorScheme")
    #   end, 100)
    #
    #   -- ===================================================================
    #   -- COMMANDES ET RACCOURCIS
    #   -- ===================================================================
    #
    #   -- Fonction de debug
    #   _G.debug_lualine = function()
    #     print("=== Lualine Debug ===")
    #
    #     local ok, lualine = pcall(require, "lualine")
    #     if ok then
    #       print("Lualine loaded: ✓")
    #
    #       -- Informations sur la configuration
    #       local config = require("lualine_require").require("lualine.config")
    #       print("Theme:", config.options.theme)
    #       print("Global status:", config.options.globalstatus)
    #
    #       -- LSP clients
    #       local clients = vim.lsp.get_clients({ bufnr = 0 })
    #       print("LSP clients:", #clients)
    #
    #       -- Git status
    #       local git_head = vim.b.gitsigns_head
    #       print("Git branch:", git_head or "none")
    #
    #     else
    #       print("Lualine not loaded: ✗")
    #     end
    #   end
    #
    #   -- Commande pour recharger lualine
    #   vim.api.nvim_create_user_command("LualineReload", function()
    #     package.loaded["lualine"] = nil
    #     require("lualine").setup()
    #     print("Lualine reloaded")
    #   end, { desc = "Reload lualine configuration" })
    #
    #   -- Commande pour toggle statusline
    #   vim.api.nvim_create_user_command("LualineToggle", function()
    #     if vim.o.laststatus == 0 then
    #       vim.o.laststatus = 3
    #       print("Lualine enabled")
    #     else
    #       vim.o.laststatus = 0
    #       print("Lualine disabled")
    #     end
    #   end, { desc = "Toggle lualine visibility" })
    #
    #   print("Lualine LazyVim-style configuration loaded")
    # '';
  };
}
