#!/usr/bin/env bash
# Renders renders/open.png, closed.png and seal_closeup.png (needs OpenSCAD, Node + Playwright)
set -euo pipefail
cd "$(dirname "$0")/.."
t=$(mktemp -d)
for p in inside engraved hinges card closed_back closed_p1 closed_p3 closed_seal closed_seal2 closed_seal3 closed_field closed_sealart; do
  openscad -q -o "$t/$p.svg" -D "part=\"2d_$p\"" invitation.scad; done
export NODE_PATH=$(npm root -g)
IV='#fcfaf5'; SH='0.4px 0.9px 0.9px rgba(70,45,35,.35)'
node tools/compose.js renders/open.png "-95 -258 190 266" 1300 \
  "$t/hinges.svg=#eee6da" "$t/inside.svg=$IV=$SH" "$t/engraved.svg=gold" "$t/card.svg=#ecd0c6=0.3px 0.8px 1px rgba(70,45,35,.3)"
node tools/compose.js renders/closed.png "-95 -192 190 112" 1400 \
  "$t/closed_back.svg=$IV=$SH" "$t/closed_p1.svg=$IV=$SH" "$t/closed_p3.svg=$IV=$SH" \
  "$t/closed_seal.svg=#8e4436=0.5px 1.4px 1.6px rgba(60,25,20,.45)" "$t/closed_seal2.svg=#9c4c3d" \
  "$t/closed_seal3.svg=#a95646" "$t/closed_field.svg=#8a4235" "$t/closed_sealart.svg=#b0604f=0.2px 0.3px 0.2px rgba(40,15,10,.45)"
node tools/compose.js renders/seal_closeup.png "-22 -146 44 30" 1200 \
  "$t/closed_back.svg=$IV" "$t/closed_p1.svg=$IV" "$t/closed_p3.svg=$IV=$SH" \
  "$t/closed_seal.svg=#8e4436=0.5px 1.4px 1.6px rgba(60,25,20,.45)" "$t/closed_seal2.svg=#9c4c3d" \
  "$t/closed_seal3.svg=#a95646" "$t/closed_field.svg=#8a4235" "$t/closed_sealart.svg=#b0604f=0.2px 0.3px 0.2px rgba(40,15,10,.45)"
rm -rf "$t"
