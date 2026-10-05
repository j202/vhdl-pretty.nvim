#!/usr/bin/env python3
"""Build a one-glyph font holding a horizontally mirrored copy of a font's
"=>" ligature, at a private-use codepoint, for vhdl-pretty.nvim.

Reads a font the user already has; writes a new file locally. Nothing is
redistributed."""
import argparse
import sys

try:
    import uharfbuzz as hb
    from fontTools.ttLib import TTFont
    from fontTools.fontBuilder import FontBuilder
    from fontTools.pens.ttGlyphPen import TTGlyphPen
    from fontTools.pens.transformPen import TransformPen
    from fontTools.pens.cu2quPen import Cu2QuPen
except ImportError as e:
    sys.exit("missing python module (%s); install with: pip install fonttools uharfbuzz" % e.name)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--font", required=True, help="path to a .ttf/.otf font")
    ap.add_argument("--out", required=True)
    ap.add_argument("--family", default="VhdlPrettyArrow")
    ap.add_argument("--codepoint", type=lambda s: int(s, 16), default=0xF8F0)
    a = ap.parse_args()

    font = TTFont(a.font)
    gs = font.getGlyphSet()
    order = font.getGlyphOrder()
    cmap = font.getBestCmap()
    upm = font["head"].unitsPerEm

    blob = hb.Blob.from_file_path(a.font)
    hbfont = hb.Font(hb.Face(blob))
    buf = hb.Buffer()
    buf.add_str("=>")
    buf.guess_segment_properties()
    hb.shape(hbfont, buf, {"liga": True, "calt": True})
    infos, poss = buf.glyph_infos, buf.glyph_positions

    # The plugin leaves every other operator to the font, so the font must
    # ligate all five; otherwise the result would be a mix of styles.
    def ligated(text):
        b = hb.Buffer()
        b.add_str(text)
        b.guess_segment_properties()
        hb.shape(hbfont, b, {"liga": True, "calt": True})
        return [order[i.codepoint] for i in b.glyph_infos] != [cmap.get(ord(c)) for c in text]

    missing = [op for op in ("<=", ">=", ":=", "=>", "/=") if not ligated(op)]
    if missing:
        sys.exit("this font does not ligate: %s (or ligatures are off); unsupported" % " ".join(missing))
    shaped = [order[i.codepoint] for i in infos]

    # Draw every shaped glyph at its pen position into one outline, mirrored
    # across the centre of the whole run's advance.
    total = sum(p.x_advance for p in poss)
    cell = total // 2
    pen = TTGlyphPen(None)
    # CFF (.otf) outlines are cubic; TrueType needs quadratic.
    target = Cu2QuPen(pen, 1.0) if "CFF " in font or "CFF2" in font else pen
    x = 0
    for info, pos in zip(infos, poss):
        tp = TransformPen(target, (-1, 0, 0, 1, total - (x + pos.x_offset), pos.y_offset))
        gs[order[info.codepoint]].draw(tp)
        x += pos.x_advance

    fb = FontBuilder(upm, isTTF=True)
    fb.setupGlyphOrder([".notdef", "arrow"])
    fb.setupCharacterMap({a.codepoint: "arrow"})
    fb.setupGlyf({".notdef": TTGlyphPen(None).glyph(), "arrow": pen.glyph()})
    fb.setupHorizontalMetrics({".notdef": (cell, 0), "arrow": (cell, 0)})
    hh = font["hhea"]
    fb.setupHorizontalHeader(ascent=hh.ascent, descent=hh.descent)
    fb.setupNameTable({"familyName": a.family, "styleName": "Regular"})
    fb.setupOS2(sTypoAscender=hh.ascent, sTypoDescender=hh.descent,
                usWinAscent=hh.ascent, usWinDescent=-hh.descent)
    fb.setupPost()
    fb.save(a.out)
    print("shaped '=>' as %s, run advance %d (%d cells of %d)" % (shaped, total, total // cell, cell))
    print("wrote", a.out)


if __name__ == "__main__":
    main()
