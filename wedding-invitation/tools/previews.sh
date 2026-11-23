#!/usr/bin/env bash
# Renders renders/open.png and renders/closed.png (needs OpenSCAD, Node + Playwright)
set -euo pipefail
cd "$(dirname "$0")/.."
t=$(mktemp -d)
for p in inside engraved hinges card closed_back closed_p1 closed_p3 closed_seal closed_sealart; do
  openscad -q -o "$t/$p.svg" -D "part=\"2d_$p\"" invitation.scad; done
export NODE_PATH=$(npm root -g)
IV='#fcfaf5'; SH='0.4px 0.9px 0.9px rgba(70,45,35,.35)'
node tools/compose.js renders/open.png "-95 -258 190 266" 1300 \
  "$t/hinges.svg=#eee6da" "$t/inside.svg=$IV=$SH" "$t/engraved.svg=gold" "$t/card.svg=#ecd0c6=0.3px 0.8px 1px rgba(70,45,35,.3)"
node tools/compose.js renders/closed.png "-95 -192 190 112" 1400 \
  "$t/closed_back.svg=$IV=$SH" "$t/closed_p1.svg=$IV=$SH" "$t/closed_p3.svg=$IV=$SH" \
  "$t/closed_seal.svg=#f6f1e7=0.5px 1.2px 1.2px rgba(70,45,35,.4)" "$t/closed_sealart.svg=gold"
rm -rf "$t"
