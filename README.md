# nvim_setting

A Lua-based Neovim configuration built around [lazy.nvim](https://github.com/folke/lazy.nvim),
with a focus on C/firmware development (LSP, Treesitter, ctags/cscope navigation).

## Requirements

- Neovim (recent stable; Treesitter uses the main API)
- `git`, `ripgrep` (`rg`) — required by Telescope
- `stylua` — Lua formatting
- A C compiler (for Treesitter parsers) and `ctags` / `cscope` for tag-based navigation

## Installation

```bash
git clone <this-repo> ~/.config/nvim
nvim
```

On first launch, lazy.nvim bootstraps itself and installs all plugins.

## Project Structure

```
init.lua                     # Entry point: loads core, lazy, telescope, cscope, tags
lua/chri/
  core/
    init.lua                 # Core module imports
    options.lua              # Editor options
    keymaps.lua              # Key mappings
  lazy.lua                   # lazy.nvim setup & plugin import
  plugins/                   # One plugin/feature per file
    lsp/
      lspconfig.lua          # LSP servers
      mason.lua              # LSP/tool installer
    ...
lua/cscope_wrap.lua          # cscope integration
lua/tags_autogen.lua         # Automatic ctags generation
lazy-lock.json               # Pinned plugin revisions
.stylua.toml                 # Formatting config (4-space indent)
```

- Editor behavior lives in `lua/chri/core/`.
- Plugin specifications live in `lua/chri/plugins/`; keep one focused plugin per file.
- `lazy-lock.json` is updated only when plugin versions intentionally change.

## Common Commands

| Command | Purpose |
| --- | --- |
| `nvim` | Start Neovim normally |
| `nvim --headless "+Lazy! sync" +qa` | Install/update plugins from the lockfile, surface config errors |
| `nvim --headless "+checkhealth" +qa` | Run health checks after LSP/parser/plugin changes |
| `stylua --check .` | Verify Lua formatting without modifying files |
| `stylua .` | Format all Lua sources |

## Notes

- Telescope ignores build artifacts (`Build/`, `Conf/`, `*.map`, `AutoGen.*`) and the
  `tags` / `cscope.out` databases so searches stay focused on source.
- ctags databases are generated automatically via `tags_autogen`, and cscope is wired
  up through `cscope_wrap`.

## Coding Style

Lua with four-space indentation (see `.stylua.toml`). Prefer `local` variables, trailing
commas in multiline tables, and descriptive `desc` fields for keymaps. Name files with
lowercase, hyphen-separated words (e.g. `todo-comments.lua`) and use `snake_case` for
Lua identifiers. Keep plugin specs declarative, with setup logic inside their `config`
functions.
