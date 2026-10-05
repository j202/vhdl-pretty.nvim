# vhdl-pretty.nvim

Syntax-aware prettification of one VHDL operator, using Tree-sitter.

In VHDL `<=` means two different things: signal assignment (`a <= b;`) and
"less than or equal" (`if a <= b`). Ligature fonts draw both the same way,
because a font can't read the syntax. This plugin uses Tree-sitter to tell
them apart, and draws only the signal assignment as a left double arrow: a
mirrored copy of your font's own `=>` ligature, so it matches the rest of
your ligatures. Every other operator (`:=`, `=>`, `>=`, `/=`, and comparison `<=`) is
left to your font's own ligatures. The plugin **does not modify files on
disk**.

## How it works

No font draws a two-cell left double arrow, and Neovim's conceal can only
substitute one character. So `:VhdlPrettyBuildFont` builds a tiny font on
your machine from the font you already use: it shapes `=>` with HarfBuzz,
mirrors the result horizontally, and stores it at a private-use codepoint.
The plugin conceals the `<` of a signal assignment as that glyph and the `=`
as a blank, so the arrow spans both cells. Nothing is downloaded or
redistributed; the new font is derived locally from your own copy.

Until the font has been built the plugin does nothing at all, so you never
see a worse look than plain ligatures.

## Requirements

- Neovim >= 0.10 and [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
  (the `vhdl` parser is installed automatically)
- A terminal that draws ligatures, using a font that ligates **all five** of
  `<=`, `>=`, `:=`, `=>` and `/=`. The build refuses fonts that don't.
- A terminal that falls back to other fonts via fontconfig for a codepoint
  the main font lacks. This is Linux; macOS is untested (and needs fontconfig
  installed, e.g. from Homebrew).
- Python 3 with `fonttools` and `uharfbuzz` (`pip install fonttools
  uharfbuzz`). If they are missing and `nix-shell` is available, it is used
  instead.
- `fc-match` and `fc-cache` (fontconfig), to find your font and refresh the
  font cache. Windows is not supported.

### Fonts tried

Tested in kitty: JetBrains Mono (Nerd Font Mono), Fira Code
(plain and Nerd Font Mono), Cascadia Code, Victor Mono, Monaspace Argon.
Hasklig has no `<=` ligature, so the build refuses it. Other ligature fonts
may work; the build tells you if they don't. Only the Regular weight was
tested.

### Terminals

Tested in kitty, where it looks right. In Konsole the right half of the
arrow disappears while the cursor is on it, because Konsole repaints the
cell under the cursor and wipes out the part that overflows into it. Other terminals are untested; the arrow depends on
the terminal letting a glyph overflow into the blank cell next to it.

## Setup

1. **Find your font's family name.** It must be the font your terminal uses,
   otherwise the arrow won't match your other ligatures:

   ```sh
   fc-list : family | sort -u | grep -i mono
   ```

2. **Install the plugin** and pass that name as `font` (a path to a font file
   also works).

   LazyVim / lazy.nvim:

   ```lua
   return {
     "j202/vhdl-pretty.nvim",
     dependencies = { "nvim-treesitter/nvim-treesitter" },
     ft = { "vhdl" },
     cmd = { "VhdlPrettyBuildFont" },
     config = function()
       require("vhdl_pretty").setup({
         font = "JetBrainsMono Nerd Font Mono", -- from step 1
       })
     end,
   }
   ```

   Without a plugin manager, clone it into Neovim's native package path and
   call `setup()` from your `init.lua` (native packages don't do that for
   you):

   ```sh
   git clone https://github.com/j202/vhdl-pretty.nvim \
     ~/.config/nvim/pack/plugins/start/vhdl-pretty.nvim
   ```

   ```lua
   require("vhdl_pretty").setup({ font = "JetBrainsMono Nerd Font Mono" })
   ```

3. **Build the font, once.** Run `:VhdlPrettyBuildFont`. It writes a font
   file, so it is deliberately not automatic. (`cmd = ...` in the spec above
   is what lets the command load the plugin; without it, open a `.vhd` file
   first.)

4. **Restart your terminal.** Many terminals read the font list only at
   start-up. Then open a `.vhd` file.

If you later change the font your terminal uses, change `font` and run
`:VhdlPrettyBuildFont` again; it overwrites the previous file.

## Conceal settings

`setup()` sets `conceallevel = 2` and `concealcursor = "nc"` for `vhdl`
buffers, once the font exists. To use different values, set them yourself
afterwards, e.g. in your own `after/ftplugin/vhdl.lua`.

## Troubleshooting

**Nothing happens:** run `:messages`. Until `:VhdlPrettyBuildFont` has
succeeded the plugin does nothing.

**The arrow shows as a box:** the terminal can't see the built font. Check
`fc-list | grep VhdlPrettyArrow`, and restart the terminal.

**Build says a font is unsupported:** it must ligate `<=`, `>=`, `:=`, `=>`
and `/=`, with ligatures turned on in the terminal.

**Tree-sitter isn't attached:**

```vim
:lua =vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil
```

## Where the font goes

`$XDG_DATA_HOME/fonts/VhdlPrettyArrow.ttf` (`~/.local/share/fonts` by
default), or `~/Library/Fonts` on macOS. Delete the file to undo it.
