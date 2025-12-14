# vhdl-pretty.nvim

Render **VHDL 2008 operators** with Unicode symbols in Neovim.

## Features

- `<=` → `⇐` (signal assignment)  
- `:=` → `≔` (variable assignment)  
- `=>` → `⇒` (element association)  
- Comparisons: `<=`, `>=`, `/=` → `≤`, `≥`, `≠`  
- Tree-sitter conceal in GUI (Neovide, Goneovim)  
- Terminal fallback using `matchadd()`  
- Fully compatible with **Neovim 0.9 → 0.11**  
- LazyVim-compatible

## Installation (LazyVim)

```lua
return {
  "j202/vhdl-pretty.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "vhdl" },
  config = function()
    local ok, plugin = pcall(require, "vhdl-pretty")
    if ok then plugin.setup() end
  end,
}
```

## Manual installation

1. Place `highlights.scm` under:

```
~/.config/nvim/after/queries/vhdl/highlights.scm
```

1. Place `init.lua` under:

```
~/.config/nvim/lua/vhdl-pretty/init.lua
```

1. Ensure `conceallevel` ≥ 1 (plugin sets 2 automatically).

## Notes

- GUI: Tree-sitter conceal works fully  
- Terminal: fallback ensures all operators are visible  
- Supports **VHDL 2008 edge cases**
