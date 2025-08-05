{
  # =====================================================================
  # MINI.NVIM - Plugins modulaires (ai, pairs, surround)
  # =====================================================================

  plugins.mini = {
    enable = true;
    mockDevIcons = true; # Remplace web-devicons pour éviter le warning
    modules = {
      # =================================================================
      # MINI.ICONS - Déjà configuré
      # =================================================================
      icons = { };

      # =================================================================
      # MINI.AI - Text objects améliorés
      # =================================================================
      ai = {
        # Configuration LazyVim style
        n_lines = 500;

        # Custom text objects (style LazyVim)
        custom_textobjects = {
          # Whole buffer
          g = {
            __raw = ''
              function()
                local from = { line = 1, col = 1 }
                local to = {
                  line = vim.fn.line('$'), 
                  col = math.max(vim.fn.getline('$'):len(), 1)
                }
                return { from = from, to = to }
              end
            '';
          };

          # Current line
          l = {
            __raw = ''
              function()
                local from = { line = vim.fn.line('.'), col = 1 }
                local to = { 
                  line = vim.fn.line('.'), 
                  col = math.max(vim.fn.getline('.'):len(), 1) 
                }
                return { from = from, to = to }
              end
            '';
          };

          # Indent level
          i = {
            __raw = ''
              function()
                local ai = require('mini.ai')
                return ai.gen_spec.treesitter({ a = '@block.inner', i = '@block.inner' })()
              end
            '';
          };

          # Function call
          o = {
            __raw = ''
              function()
                local ai = require('mini.ai')
                return ai.gen_spec.treesitter({ a = '@call.outer', i = '@call.inner' })()
              end
            '';
          };

          # Complete buffer
          e = {
            __raw = ''
              function()
                local from = { line = 1, col = 1 }
                local to = {
                  line = vim.fn.line('$'), 
                  col = math.max(vim.fn.getline('$'):len(), 1)
                }
                return { from = from, to = to }
              end
            '';
          };
        };
      };

      # =================================================================
      # MINI.PAIRS - Auto-pairing intelligent (version silencieuse)
      # =================================================================
      pairs = {
        # Modes où activer les pairs
        modes = {
          insert = true;
          command = false;
          terminal = false;
        };

        # Skip autopair when next character is one of these
        skip_next = {
          __raw = "[=[[%w%%%'%[%\"%.%`%$]]=]";
        };

        # Skip autopair when the cursor is inside these treesitter nodes
        skip_ts = [ "string" ];

        # Skip autopair when next character is closing pair and there are more closing pairs than opening pairs
        skip_unbalanced = true;

        # Better deal with markdown code blocks
        markdown = true;

        # IMPORTANT: Mode silencieux pour éviter conflits avec noice
        silent = true;
      };

      # =================================================================
      # MINI.SURROUND - Gestion des surroundings (version silencieuse)
      # =================================================================
      surround = {
        # Configuration des mappings (style LazyVim)
        mappings = {
          add = "gsa"; # Add surrounding in Normal and Visual modes
          delete = "gsd"; # Delete surrounding
          find = "gsf"; # Find surrounding (to the right)
          find_left = "gsF"; # Find surrounding (to the left)
          highlight = "gsh"; # Highlight surrounding
          replace = "gsr"; # Replace surrounding
          update_n_lines = "gsn"; # Update `n_lines`

          suffix_last = "l"; # Suffix to search with "prev" method
          suffix_next = "n"; # Suffix to search with "next" method
        };

        # Number of lines within which surrounding is searched
        n_lines = 20;

        # How to search for surrounding (first inside current line, then inside neighborhood)
        search_method = "cover";

        # IMPORTANT: Mode silencieux pour éviter conflits avec noice
        silent = true;

        # Custom surroundings (LazyVim style)
        custom_surroundings = {
          # Markdown code block
          c = {
            input = {
              __raw = "{ '%w+%(().-%)%)', '^.-%w+%(().-%)%).*$' }";
            };
            output = {
              __raw = ''
                function()
                  local fname = vim.fn.input('Function name: ')
                  return { left = fname .. '(', right = ')' }
                end
              '';
            };
          };

          # HTML/XML tag
          t = {
            input = {
              __raw = "{ '<%w->().*()</>', '^<.->().-()</>' }";
            };
            output = {
              __raw = ''
                function()
                  local tag = vim.fn.input('Tag name: ')
                  return { left = '<' .. tag .. '>', right = '</' .. tag .. '>' }
                end
              '';
            };
          };
        };
      };

      # =================================================================
      # MINI.COMMENT - Commentaires intelligents (version silencieuse)
      # =================================================================
      comment = {
        # Options pour la gestion des commentaires
        options = {
          # Fonction pour calculer commentstring personnalisé
          custom_commentstring = null;

          # Ignorer les lignes vides lors du commenting
          ignore_blank_line = false;

          # Commenter au début de la ligne ou après l'indentation
          start_of_line = false;

          # Gestion de l'indentation des commentaires
          pad_comment_parts = true;
        };

        # Mappings (style LazyVim)
        mappings = {
          # Commenter ligne(s) en normal et visual
          comment = "gc";
          comment_line = "gcc";
          comment_visual = "gc";

          # Commenter jusqu'à la fin de la ligne
          textobject = "gc";
        };

        # IMPORTANT: Mode silencieux pour éviter conflits avec noice
        silent = true;
      };

      # =================================================================
      # MINI.HIPATTERNS - Mise en évidence de patterns (couleurs, TODO, etc.)
      # =================================================================
      hipatterns = {
        # Patterns prédéfinis (style LazyVim)
        highlighters = {
          # Couleurs hexadécimales (#ffffff, #123ABC, etc.)
          hex_color = {
            __raw = ''
              require('mini.hipatterns').gen_highlighter.hex_color()
            '';
          };

          # Mots-clés TODO, FIXME, etc.
          fixme = {
            pattern = "%f[%w]()FIXME()%f[%W]";
            group = "MiniHipatternsFixme";
          };

          hack = {
            pattern = "%f[%w]()HACK()%f[%W]";
            group = "MiniHipatternsHack";
          };

          todo = {
            pattern = "%f[%w]()TODO()%f[%W]";
            group = "MiniHipatternsTodo";
          };

          note = {
            pattern = "%f[%w]()NOTE()%f[%W]";
            group = "MiniHipatternsNote";
          };

          # Couleurs nommées courantes
          red = {
            pattern = "red";
            group = "MiniHipatternsRed";
          };

          blue = {
            pattern = "blue";
            group = "MiniHipatternsBlue";
          };

          green = {
            pattern = "green";
            group = "MiniHipatternsGreen";
          };
        };
      };
    };
  };

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE LUA - SANS INTÉGRATION WHICH-KEY
  # =====================================================================

  extraConfigLua = ''
    -- -- Configuration des highlights pour mini.nvim (gruvbox style)
    -- vim.api.nvim_create_autocmd("ColorScheme", {
    --   pattern = "*",
    --   callback = function()
    --     -- Highlights pour mini.surround
    --     vim.api.nvim_set_hl(0, "MiniSurround", {
    --       bg = "#fe8019",  -- gruvbox orange
    --       fg = "#282828",  -- gruvbox dark
    --       bold = true
    --     })
    --
    --     -- Highlights pour mini.ai
    --     vim.api.nvim_set_hl(0, "MiniAiTextobjectInner", {
    --       bg = "#504945",  -- gruvbox dark2
    --       fg = "#ebdbb2"   -- gruvbox light1
    --     })
    --
    --     vim.api.nvim_set_hl(0, "MiniAiTextobjectOuter", {
    --       bg = "#665c54",  -- gruvbox dark3
    --       fg = "#ebdbb2"   -- gruvbox light1
    --     })
    --
    --     -- Highlights pour mini.pairs
    --     vim.api.nvim_set_hl(0, "MiniPairs", {
    --       fg = "#8ec07c",  -- gruvbox bright aqua
    --       bold = true
    --     })
    --   end,
    -- })

    -- ===================================================================
    -- CONFIGURATION ANTI-CONFLIT NOICE POUR MINI.NVIM
    -- ===================================================================

    -- Configuration silencieuse pour mini.pairs
    vim.defer_fn(function()
      local pairs_ok, pairs = pcall(require, 'mini.pairs')
      if pairs_ok then
        -- Désactiver tous les messages/notifications de mini.pairs
        local original_notify = vim.notify
        vim.notify = function(msg, level, opts)
          if type(msg) == "string" and (
            msg:match("pairs") or 
            msg:match("Pairs") or 
            msg:match("autopair")
          ) then
            return -- Skip mini.pairs messages
          end
          return original_notify(msg, level, opts)
        end
      end
    end, 100)

    -- Configuration silencieuse pour mini.surround  
    vim.defer_fn(function()
      local surround_ok, surround = pcall(require, 'mini.surround')
      if surround_ok then
        -- Redéfinir les fonctions d'input pour éviter les conflits
        local original_input = vim.fn.input
        vim.fn.input = function(prompt, default)
          if prompt:match("Function name") or prompt:match("Tag name") then
            -- Pour éviter les conflits avec noice, utiliser des defaults
            if prompt:match("Function name") then
              return default or "func"
            elseif prompt:match("Tag name") then
              return default or "div"
            end
          end
          return original_input(prompt, default)
        end
      end
    end, 100)
  '';
}
