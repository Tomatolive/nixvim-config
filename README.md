# Nixvim Configuration

A comprehensive and well-structured Nixvim configuration featuring modern plugins, extensive language support, and custom keybindings optimized for productivity.

## Philosophy

This configuration is **highly opinionated** and represents a personal workflow optimized for specific development needs. It draws heavy inspiration from [LazyVim](https://www.lazyvim.org/) but adapts the concepts to Nixvim's declarative approach and adds custom modifications for enhanced productivity.

**Key Design Principles:**
- Declarative configuration through Nix
- Minimal but powerful plugin selection
- Language-specific optimizations
- Custom keybinding philosophy (JKLM navigation)
- Performance-first approach

## Features

### Core Features
- **Custom Movement System**: JKLM navigation instead of traditional HJKL
- **Gruvbox Theme**: Dark theme with transparency and custom highlights
- **Performance Optimized**: Lua bytecode compilation enabled for faster startup
- **Smart Autocommands**: Language-specific configurations with buffer-local keymaps

### Language Support
- **C/C++**: Clangd LSP, debugging with LLDB/GDB, clang-format, compile_commands.json generation
- **Nix**: nixd LSP, nixpkgs-fmt formatting, flake commands integration
- **Haskell**: haskell-tools.nvim with REPL integration, ormolu formatting
- **Markdown**: Live preview, markview rendering, pandoc export

### Plugin Ecosystem
- **Snacks.nvim**: Modern dashboard, file picker, terminal, notifications
- **Blink.cmp**: Fast and extensible completion engine
- **Trouble.nvim**: Beautiful diagnostics and quickfix lists
- **DAP**: Full debugging support with UI integration
- **Git Integration**: Gitsigns, Lazygit, conventional commits with Meteor
- **Mini.nvim**: Text objects, surround, comments, auto-pairs, and more

## Installation

### Prerequisites
- Nix with flakes enabled
- Git

### Quick Start
```bash
# Test the configuration
nix run github:Tomatolive/nixvim-config

# Or install permanently
nix profile install github:Tomatolive/nixvim-config
```

## Configuration Structure

```
config/
├── core/              # Core Neovim settings
│   ├── colorscheme.nix   # Gruvbox theme configuration
│   ├── keymaps.nix       # Global key bindings
│   └── options.nix       # Neovim options
├── lang/              # Language-specific configurations
│   ├── c.nix            # C/C++ setup with Clangd
│   ├── nix.nix          # Nix language support
│   ├── haskell.nix      # Haskell development environment
│   └── markdown.nix     # Markdown editing tools
└── plugins/           # Plugin configurations
    ├── snacks.nix       # Modern UI and utilities
    ├── blink.nix        # Completion engine
    ├── dap.nix          # Debugging setup
    ├── git.nix          # Git integration
    └── ...
```

## Key Bindings

### Navigation (Custom JKLM Layout)
- `j` - Move left (replaces h)
- `k` - Move down
- `l` - Move up  
- `m` - Move right (replaces l)
- `§` - Set mark (replaces m)

### Leader Key Mappings
**Leader key**: `Space`

#### Code Actions (`<leader>c`)
- `<leader>cf` - Format code
- `<leader>cd` - Show line diagnostics
- `<leader>ca` - Code actions with preview
- `<leader>cr` - Rename symbol (interactive)

#### File Operations (`<leader>f`)
- `<leader>ff` - Find files
- `<leader>fg` - Find text (grep)
- `<leader>fr` - Recent files
- `<leader>fn` - New file

#### Git Operations (`<leader>g`)
- `<leader>gg` - Open Lazygit
- `<leader>gc` - Commit with Meteor (conventional commits)
- `<leader>gd` - Git diff
- `<leader>gs` - Git status

#### Debug (`<leader>d`)
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue
- `<leader>ds` - Step over
- `<leader>di` - Step into

#### Diagnostics (`<leader>x`)
- `<leader>xx` - Open Trouble diagnostics
- `<leader>xX` - Buffer diagnostics
- `<leader>xs` - LSP symbols

### Language-Specific Bindings

#### C/C++ (`<leader>C`)
- `<leader>Ca` - View AST
- `<leader>Ch` - Switch header/source
- `<leader>Cd` - Debug with LLDB
- `<leader>Cg` - Debug with GEF

#### Nix (`<leader>N`)
- `<leader>Nc` - Flake check
- `<leader>Nb` - Nix build
- `<leader>Nu` - Flake update

#### Haskell (`<leader>h`)
- `<leader>hr` - Toggle REPL
- `<leader>he` - Evaluate in REPL
- `<leader>hs` - Hoogle search

#### Markdown (`<leader>m`)
- `<leader>mt` - Toggle Markview
- `<leader>mp` - Preview in browser
- `<leader>me` - Export to HTML

## Customization

### Adding New Languages
1. Create a new file in `config/lang/your-language.nix`
2. Configure LSP, formatter, and linter
3. Add language-specific keymaps in autocommands
4. Import the file in `config/lang/default.nix`

### Adding Plugins
1. Add plugin configuration in appropriate `config/plugins/` file
2. Configure keymaps and which-key groups
3. Update imports in `config/plugins/default.nix`

### Modifying Keymaps
- Global keymaps: Edit `config/core/keymaps.nix`
- Plugin keymaps: Edit respective plugin files
- Language-specific: Modify autocommands in language files

## Performance Features

- **Lua Bytecode Compilation**: Configs and plugins are compiled for faster loading
- **Smart Loading**: Plugins load only when needed
- **Optimized Defaults**: Carefully chosen default settings for performance

## Development Tools

### Conventional Commits
The configuration includes Meteor for conventional commit formatting:
```bash
# Create .meteor.json config
:MeteorConfig

# Make a conventional commit
<leader>gc
```

### Project Setup
- **C/C++**: Automatic compile_commands.json generation
- **Nix**: Flake integration with development shells
- **Haskell**: Stack/Cabal project support

## Troubleshooting

### Common Issues
1. **LSP not working**: Ensure language servers are in your PATH
2. **Formatting fails**: Check if formatters are installed via extraPackages
3. **Keymaps not working**: Verify which-key shows the correct mappings

### Debug Mode
```bash
# Run with verbose output
nix run . --verbose

# Check configuration
nix flake check .
```

