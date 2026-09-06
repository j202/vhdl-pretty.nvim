# vhdl-pretty.nvim

Syntax-aware operator prettification for VHDL, using Tree-sitter.

This plugin **visually replaces** common VHDL operators with clearer Unicode
symbols via Neovim's conceal feature. It **does not modify files on disk** —
turn it off and your source is untouched.

## Features

| VHDL construct                              | Original | Displayed |
| -------------------------------------------- | -------- | --------- |
| Signal assignment                            | `<=`     | `⇐`       |
| Variable assignment                          | `:=`     | `≔`       |
| Association arrow (aggregates, port/generic maps, `case...when`) | `=>` | `⇒` |
| Less-than-or-equal (comparison)              | `<=`     | `≤`       |
| Greater-than-or-equal (comparison)           | `>=`     | `≥`       |
| Not equal                                    | `/=`     | `≠`       |

- Tree-sitter based: signal-assignment `<=` and comparison `<=` are distinct
  grammar nodes, so they're told apart correctly and never confused.
- Every place one of these tokens can occur is covered — checked against
  the full grammar, not just the common cases — including port/generic
  maps, `case` statements, and VHDL-2008 conditional-analysis directives.
  Nothing falls through to a ligature-enabled terminal font's own
  (differently-styled) rendering of the same text.
- Works with both nvim-treesitter's legacy (`master`) and current (`main`)
  branch — whichever you have installed.
- LazyVim-compatible, including filetype-based lazy loading (`ft = "vhdl"`).
- Each concealed symbol keeps the original token's two-column width (the
  symbol, then a literal blank for the second column), so manually
  column-aligned code — a common VHDL style, including wrapped
  multi-line assignments — stays aligned. This is the same technique
  Nerd Font icons use, for the same reason: conceal only ever accepts a
  single replacement character, so the second column has to be filled
  explicitly rather than left to shrink away.

> **Caveat for the legacy `master` branch of nvim-treesitter:** on that
> branch (not the current `main`), `setup()` falls back to calling
> `require("nvim-treesitter.configs").setup({ ensure_installed = { "vhdl" },
> highlight = { enable = true } })`. If you already call
> `nvim-treesitter.configs.setup()` yourself elsewhere (common in LazyVim
> configs that configure several languages at once), this second call isn't
> purely additive the way the `main`-branch install path is — depending on
> load order it can interact with your own config instead of just adding
> `vhdl` to it. This doesn't affect the current `main` branch, which has no
> `nvim-treesitter.configs` module at all, so this plugin never takes that
> path there.

## Requirements

- Neovim ≥ 0.9 (uses `vim.treesitter.start`; developed and tested on 0.12)
- [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
- The `vhdl` Tree-sitter parser — installed automatically the first time
  `setup()` runs; if that fails for some reason, install it manually with
  `:TSInstall vhdl`
- A UTF-8-capable terminal and font so the substitution characters
  (`⇐ ≔ ⇒ ≤ ≥ ≠`) render instead of showing as boxes

## Installation (LazyVim)

```lua
return {
  "j202/vhdl-pretty.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "vhdl" },
  config = function()
    require("vhdl_pretty").setup()
  end,
}
```

## Manual installation (no plugin manager)

Clone it into Neovim's native package path — this keeps the `lua/` and
`after/` directories together correctly, which matters since Neovim's
`after/queries` override mechanism relies on that layout:

```sh
git clone https://github.com/j202/vhdl-pretty.nvim \
  ~/.config/nvim/pack/plugins/start/vhdl-pretty.nvim
```

Then call `setup()` from your `init.lua` — native packages don't do this for
you automatically:

```lua
require("vhdl_pretty").setup()
```

Restart Neovim.

## Conceal settings

`setup()` sets `conceallevel = 2` and `concealcursor = "nc"` automatically,
but only for buffers with `filetype = "vhdl"`. To use different values,
set them yourself afterwards, e.g. in your own `after/ftplugin/vhdl.lua`.

## Troubleshooting

**Symbols don't appear:**

1. Check the parser installed correctly:
   ```vim
   :checkhealth nvim-treesitter
   ```
   or force a (re)install with `:TSInstall vhdl`.
2. Check Tree-sitter actually attached to the buffer:
   ```vim
   :lua =vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil
   ```
3. Check conceal is active:
   ```vim
   :set conceallevel? concealcursor?
   ```

**Symbols show as boxes/tofu:** that's a font issue, not this plugin — test
with `:echo "⇐ ≔ ⇒ ≤ ≥ ≠"` and switch to a Unicode-capable font (e.g. a
[Nerd Font](https://www.nerdfonts.com/)) if they don't render.

## Customization

The concealed operators share the `@operator` highlight capture with
nvim-treesitter's own bundled VHDL query, so restyling `@operator` affects
*all* VHDL operators, not just the concealed ones:

```lua
vim.api.nvim_set_hl(0, "@operator.vhdl", { fg = "#88c0d0", bold = true })
```

(`@operator.vhdl` overrides `@operator` for VHDL buffers only, leaving
other filetypes unaffected.)
