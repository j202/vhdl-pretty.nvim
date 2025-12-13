# vhdl-pretty.nvim

Syntax-aware operator prettification for VHDL using Tree-sitter.

This plugin **visually replaces** common VHDL operators with clearer Unicode symbols
using Tree-sitter queries and Neovim’s conceal feature.  
It **does not modify files on disk**.

Works with **Neovim 0.9.x, 0.10.x, and 0.11.x**.

---

## Features

| VHDL Construct            | Original | Displayed |
|---------------------------|----------|-----------|
| Signal assignment         | `<=`     | `⇐`       |
| Variable assignment       | `:=`     | `≔`       |
| Element association       | `=>`     | `⇒`       |
| Less-than-or-equal        | `<=`     | `≤`       |
| Greater-than-or-equal     | `>=`     | `≥`       |
| Not equal                 | `/=`     | `≠`       |

- Tree-sitter based (syntax-aware)
- VHDL-2008 compatible
- No LSP dependency
- Safe for all Neovim 0.9–0.11 versions

---

## Requirements

- Neovim **≥ 0.9**
- `nvim-treesitter`
- VHDL Tree-sitter parser installed:

```vim
:TSInstall vhdl
```

- A Unicode-capable font (e.g. JetBrains Mono, FiraCode, Nerd Fonts)

---

## Plugin File Structure

The plugin repository must have this structure:

```
vhdl-pretty.nvim/
├── lua/
│   └── vhdl_pretty/
│       └── init.lua
├── after/
│   └── queries/
│       └── vhdl/
│           └── highlights.scm
└── README.md
```

---

## Installation (LazyVim)

### 1. Add the plugin spec

Create this file:

```
~/.config/nvim/lua/plugins/vhdl-pretty.lua
```

Put **exactly this** inside it:

```lua
return {
  "j202/vhdl-pretty.nvim",
  config = function()
    require("vhdl_pretty").setup()
  end,
}
```

### 2. Sync plugins

```vim
:Lazy sync
```

### 3. Restart Neovim

---

## Manual Installation (No Plugin Manager)

### 1. Clone the repository

```sh
git clone https://github.com/j202/vhdl-pretty.nvim \
  ~/.config/nvim/pack/plugins/start/vhdl-pretty.nvim
```

> The directory name **must** be `vhdl-pretty.nvim`.

### 2. Restart Neovim

Neovim will automatically load the plugin from `pack/*/start`.

---

## Enabling Conceal

Conceal must be enabled for symbols to appear.

You can enable it globally in your config:

```lua
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"
```

Or per-buffer (manual test):

```vim
:set conceallevel=2
:set concealcursor=nc
```

---

## Neovim 0.11 Note (Important)

Neovim 0.11 does **not automatically start Tree-sitter highlighting**.

This plugin handles that automatically via an autocommand, so **no extra
configuration is required**.

---

## Troubleshooting

### Symbols do not appear

1. Confirm Tree-sitter parser is installed:

```vim
:TSInstallInfo
```

2. Confirm Tree-sitter is running:

```vim
:lua vim.treesitter.start(0, "vhdl")
```

3. Ensure conceal is enabled:

```vim
:set conceallevel?
```

### Unicode symbols not visible

Test:

```vim
:echo "⇐ ≔ ⇒ ≤ ≥ ≠"
```

If these do not render, switch to a Unicode-capable font.

---

## Customization

You can override highlight groups:

```lua
vim.api.nvim_set_hl(0, "@vhdl.assign.signal", { fg = "#88c0d0", bold = true })
vim.api.nvim_set_hl(0, "@vhdl.assign.variable", { fg = "#81a1c1", bold = true })
vim.api.nvim_set_hl(0, "@vhdl.compare", { fg = "#bf616a" })
```

---

## License

MIT
