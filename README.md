# vhdl-pretty.nvim

A Neovim plugin to render **VHDL 2008 operators** and assignments with prettified Unicode symbols using Tree-sitter. Fully compatible with **Neovim 0.9 → 0.11** and LazyVim.

## Features

- `<=` → `⇐` (signal assignment)  
- `:=` → `≔` (variable assignment)  
- `=>` → `⇒` (element association)  
- Comparisons: `<=`, `>=`, `/=` → `≤`, `≥`, `≠`  
- Works in GUI (Neovide, Goneovim) using Tree-sitter  
- Works in terminal using fallback `matchadd()`  

## Installation (LazyVim)

Add to your LazyVim plugin list:

```lua
return {
  "yourname/vhdl-pretty.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "vhdl" },
  config = function()
    local ok, plugin = pcall(require, "vhdl-pretty")
    if ok then
      plugin.setup()
    end
  end,
}
```

### Optional: manual installation

1. Place the `highlights.scm` file in:

```
~/.config/nvim/after/queries/vhdl/highlights.scm
```

1. Place `init.lua` under:

```
~/.config/nvim/lua/vhdl-pretty/init.lua
```

1. Set LazyVim to load for VHDL filetypes only, or use the autocmd in `init.lua`.  

---

## Notes

- Conceallevel must be ≥1 (plugin sets 2 automatically).  
- GUI Neovim: Tree-sitter conceal fully works.  
- Terminal: fallback `matchadd()` guarantees visibility.  
- Supports **VHDL 2008 edge cases**.
