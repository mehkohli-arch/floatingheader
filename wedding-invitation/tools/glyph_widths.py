"""Writes fonts/cinzel_widths.scad: advance widths (per 1 unit of font size) for
evenly tracked capitals in OpenSCAD, which has no text metrics of its own."""
from fontTools.ttLib import TTFont
f = TTFont("fonts/Cinzel.ttf"); cmap = f.getBestCmap(); hmtx = f["hmtx"]; upm = f["head"].unitsPerEm
chars = "".join(chr(c) for c in range(32, 127)) + "·&"
rows = []
for ch in chars:
    g = cmap.get(ord(ch))
    if g and ch not in '"\\': rows.append('["%s", %.4f]' % (ch, hmtx[g][0] / upm))
open("fonts/cinzel_widths.scad", "w").write("cinzel_adv = [\n  " + ",\n  ".join(rows) + "\n];\n")
print(len(rows), "glyphs")
