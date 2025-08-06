{
  # =====================================================================
  # LUALINE - Configuration style LazyVim exacte avec toutes les fonctionnalités
  # =====================================================================

  plugins.lualine = {
    enable = true;

    settings = {
      options = {
        theme = "auto";
        globalstatus = true; # vim.o.laststatus == 3
        disabled_filetypes = {
          statusline = [ "dashboard" "alpha" "ministarter" "snacks_dashboard" ];
        };
      };

      sections = {
        # Section A - Mode
        lualine_a = [ "mode" ];

        # Section B - Branche Git
        lualine_b = [ "branch" ];

        # Section C - Root dir, diagnostics, filetype icon, pretty path
        lualine_c = [
          # Root directory (équivalent LazyVim.lualine.root_dir())
          {
            __unkeyed-1.__raw = ''
              function()
                local root_patterns = { ".git", "package.json", "Cargo.toml", "pyproject.toml", ".svn" }
                local path = vim.api.nvim_buf_get_name(0)
                if path == "" then return "" end
                
                path = vim.fs.dirname(path)
                local root = vim.fs.find(root_patterns, { path = path, upward = true })[1]
                if root then
                  local root_dir = vim.fs.dirname(root)
                  local relative_root = vim.fn.fnamemodify(root_dir, ':~:.')
                  return "󱉭 " .. (relative_root == "." and vim.fn.fnamemodify(root_dir, ':t') or relative_root)
                end
                return ""
              end
            '';
            color =
              {
                fg = "#83a598";
              }; # bleu gruvbox
          }

          # Diagnostics avec icônes LazyVim
          {
            __unkeyed-1 = "diagnostics";
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
              hint = " ";
            };
          }

          # Filetype icon seulement
          {
            __unkeyed-1 = "filetype";
            icon_only = true;
            separator = "";
            padding = { left = 1; right = 0; };
          }

          # Pretty path (équivalent LazyVim.lualine.pretty_path())
          {
            __unkeyed-1.__raw = ''
              function()
                local path = vim.api.nvim_buf_get_name(0)
                if path == "" then return "[No Name]" end
                
                local filename = vim.fn.fnamemodify(path, ':t')
                local directory = vim.fn.fnamemodify(path, ':h:t')
                
                if directory == "." or directory == "" then
                  return filename
                end
                
                -- Raccourcir le chemin si trop long
                local max_len = 40
                local full_path = directory .. "/" .. filename
                if #full_path > max_len then
                  return "…/" .. filename
                end
                
                return directory .. "/" .. filename
              end
            '';
            color = {
              fg = "#ebdbb2";
            }; # fg normal gruvbox
          }
        ];

        # Section X - Profiler, Noice, DAP, Lazy updates, Git diff
        lualine_x = [
          # Snacks profiler status
          {
            __unkeyed-1.__raw = ''
              function()
                local ok, snacks = pcall(require, "snacks")
                if ok and snacks.profiler and snacks.profiler.status then
                  local status = snacks.profiler.status()
                  return type(status) == "string" and status or ""
                end
                return ""
              end
            '';
            color =
              {
                fg = "#d3869b";
              }; # purple gruvbox
          }

          # Noice command
          {
            __unkeyed-1.__raw = ''
              function() 
                local ok, noice = pcall(require, "noice")
                if ok and noice.api and noice.api.status and noice.api.status.command and noice.api.status.command.has() then
                  local cmd = noice.api.status.command.get()
                  return type(cmd) == "string" and cmd or ""
                end
                return ""
              end
            '';
            cond.__raw = ''
              function() 
                local ok, noice = pcall(require, "noice")
                return ok and noice.api and noice.api.status and noice.api.status.command and noice.api.status.command.has()
              end
            '';
            color.__raw = ''
              function() 
                return { fg = "#fabd2f" }
              end
            '';
          }

          # Noice mode
          {
            __unkeyed-1.__raw = ''
              function() 
                local ok, noice = pcall(require, "noice")
                if ok and noice.api and noice.api.status and noice.api.status.mode and noice.api.status.mode.has() then
                  local mode = noice.api.status.mode.get()
                  return type(mode) == "string" and mode or ""
                end
                return ""
              end
            '';
            cond.__raw = ''
              function() 
                local ok, noice = pcall(require, "noice")
                return ok and noice.api and noice.api.status and noice.api.status.mode and noice.api.status.mode.has()
              end
            '';
            color.__raw = ''
              function() 
                return { fg = "#8ec07c" }
              end
            '';
          }

          # Git diff
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = " ";
              modified = " ";
              removed = " ";
            };
            source.__raw = ''
              function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end
            '';
          }
        ];

        # Section Y - Progress et location
        lualine_y = [
          {
            __unkeyed-1 = "progress";
            separator = " ";
            padding = { left = 1; right = 0; };
          }
          {
            __unkeyed-1 = "location";
            padding = { left = 0; right = 1; };
          }
        ];

        # Section Z - Horloge
        lualine_z = [
          {
            __unkeyed-1 = "os.date('%R')";
            icon = " ";
            color = { fg = "#282828"; bg = "#83a598"; };
          }
        ];
      };

      # Extensions LazyVim
      extensions = [ "neo-tree" "lazy" "fzf" ];
    };
  };

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE LUA
  # =====================================================================

  extraConfigLua = ''
    -- Configuration lualine style LazyVim
    
    -- Gestion de la performance et initialisation
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Set laststatus early
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
          -- set an empty statusline till lualine loads
          vim.o.statusline = " "
        else
          -- hide the statusline on the starter page
          vim.o.laststatus = 0
        end
      end
    })

    -- Restaurer laststatus quand lualine est prête
    vim.defer_fn(function()
      if vim.g.lualine_laststatus then
        vim.o.laststatus = vim.g.lualine_laststatus
      else
        vim.o.laststatus = 3  -- globalstatus par défaut
      end
    end, 100)

    -- Désactiver le require madness comme dans LazyVim
    vim.defer_fn(function()
      local ok, lualine_require = pcall(require, "lualine_require")
      if ok then
        lualine_require.require = require
      end
    end, 50)

    -- Configuration trouble symbols si trouble.nvim est disponible
    vim.defer_fn(function()
      local has_trouble = pcall(require, "trouble")
      if has_trouble and vim.g.trouble_lualine then
        local trouble = require("trouble")
        local symbols = trouble.statusline({
          mode = "symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
        
        if symbols then
          -- Ajouter symbols à lualine_c
          local ok, lualine = pcall(require, "lualine")
          if ok then
            local config = require("lualine").get_config()
            table.insert(config.sections.lualine_c, {
              symbols.get,
              cond = function()
                return vim.b.trouble_lualine ~= false and symbols.has()
              end,
            })
            lualine.setup(config)
          end
        end
      end
    end, 1000)

  '';
}
