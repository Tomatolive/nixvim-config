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
        modes = { insert = true; command = false; terminal = false; };
        
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
    };
  };

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE LUA
  # =====================================================================
  
  extraConfigLua = ''
    -- Configuration des highlights pour mini.nvim (gruvbox style)
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        -- Highlights pour mini.surround
        vim.api.nvim_set_hl(0, "MiniSurround", {
          bg = "#fe8019",  -- gruvbox orange
          fg = "#282828",  -- gruvbox dark
          bold = true
        })
        
        -- Highlights pour mini.ai
        vim.api.nvim_set_hl(0, "MiniAiTextobjectInner", {
          bg = "#504945",  -- gruvbox dark2
          fg = "#ebdbb2"   -- gruvbox light1
        })
        
        vim.api.nvim_set_hl(0, "MiniAiTextobjectOuter", {
          bg = "#665c54",  -- gruvbox dark3
          fg = "#ebdbb2"   -- gruvbox light1
        })
        
        -- Highlights pour mini.pairs
        vim.api.nvim_set_hl(0, "MiniPairs", {
          fg = "#8ec07c",  -- gruvbox bright aqua
          bold = true
        })
      end,
    })
    
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
    
    -- ===================================================================
    -- FONCTIONS DE TEST (SANS MESSAGES DEBUG)
    -- ===================================================================
    
    -- Fonction pour tester mini.ai text objects
    _G.test_mini_ai = function()
      print("=== Mini.ai Text Objects ===")
      print("")
      print("Standard text objects (enhanced):")
      print("  w - word")
      print("  s - sentence") 
      print("  p - paragraph")
      print("  t - tag")
      print("  b - bracket")
      print("  q - quote")
      print("")
      print("Custom text objects:")
      print("  g - entire buffer")
      print("  l - current line")
      print("  i - indent level")
      print("  o - function call")
      print("  e - entire buffer")
      print("")
      print("Usage: v + i/a + object (ex: 'vip' = select inside paragraph)")
      print("       d + i/a + object (ex: 'daw' = delete around word)")
      print("       c + i/a + object (ex: 'cit' = change inside tag)")
    end
    
    -- Fonction pour tester mini.surround
    _G.test_mini_surround = function()
      print("=== Mini.surround Keymaps ===")
      print("")
      print("Basic operations:")
      print("  gsa + motion + char - Add surrounding")
      print("  gsd + char - Delete surrounding") 
      print("  gsr + old + new - Replace surrounding")
      print("")
      print("Navigation:")
      print("  gsf + char - Find next surrounding")
      print("  gsF + char - Find previous surrounding")
      print("  gsh + char - Highlight surrounding")
      print("")
      print("Examples:")
      print("  gsaiw) - Add parentheses around word")
      print("  gsd' - Delete single quotes")
      print("  gsr'\" - Replace single quotes with double quotes")
      print("")
      print("Custom surroundings:")
      print("  c - Markdown code block")
      print("  f - Function call")
      print("  t - HTML/XML tag")
    end
    
    -- Fonction pour tester mini.pairs
    _G.test_mini_pairs = function()
      print("=== Mini.pairs Features ===")
      print("")
      print("Auto-pairing:")
      print("  ( ) [ ] { } \" \" ' ' ` `")
      print("")
      print("Smart features:")
      print("  - Skip when next char is word/quote")
      print("  - Skip inside strings")
      print("  - Balance checking")
      print("  - Markdown awareness")
      print("")
      print("Try typing opening brackets and quotes!")
    end
    
    -- Commandes de test
    vim.api.nvim_create_user_command("TestMiniAi", function()
      test_mini_ai()
    end, { desc = "Show mini.ai text objects help" })
    
    vim.api.nvim_create_user_command("TestMiniSurround", function()
      test_mini_surround()
    end, { desc = "Show mini.surround keymaps help" })
    
    vim.api.nvim_create_user_command("TestMiniPairs", function()
      test_mini_pairs()
    end, { desc = "Show mini.pairs features" })

    -- Intégration which-key pour mini.surround (silencieuse)
    vim.defer_fn(function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          -- Mini.surround group
          { "gs", group = "󰴈 Surround" },
          { "gsa", desc = "Add Surround", icon = "󰴈" },
          { "gsd", desc = "Delete Surround", icon = "󰆴" },
          { "gsr", desc = "Replace Surround", icon = "󰛔" },
          { "gsf", desc = "Find Surround →", icon = "󰮡" },
          { "gsF", desc = "Find Surround ←", icon = "󰮢" },
          { "gsh", desc = "Highlight Surround", icon = "󰸱" },
          { "gsn", desc = "Update Lines", icon = "󰆾" },
        })
      end
    end, 1000)

    -- Note: Pas de message print() pour éviter les conflits avec noice
  '';
}
