#!/usr/bin/env bash
# Renders renders/open.png, closed.png and medallion_closeup.png (needs OpenSCAD, Node + Playwright)
set -euo pipefail
cd "$(dirname "$0")/.."
t=$(mktemp -d)
for p in inside engraved hinges card closed_back closed_p1 closed_p3 closed_cord1 closed_cord3 \
         closed_button closed_button2 closed_buttonart; do
  openscad -q -o "$t/$p.svg" -D "part=\"2d_$p\"" invitation.scad; done
export NODE_PATH=$(npm root -g)
IV='#fcfaf5'; SH='0.4px 0.9px 0.9px rgba(70,45,35,.35)'
CORD='#ffffff=0.25px 0.35px 0.35px rgba(70,45,35,.45)'
BTN='#fbf8f1=0.4px 1px 1.2px rgba(70,45,35,.45)'
node tools/compose.js renders/open.png "-95 -258 190 266" 1300 \
  "$t/hinges.svg=#eee6da" "$t/inside.svg=$IV=$SH" "$t/engraved.svg=gold" "$t/card.svg=#ecd0c6=0.3px 0.8px 1px rgba(70,45,35,.3)"
# closed: the blush details card shows through the lace front panel
CLOSED=( "$t/closed_back.svg=$IV=$SH" "RECT=-63.5,-154.75,127,63.5=#ecd0c6" "$t/closed_p1.svg=$IV=$SH" "$t/closed_cord1.svg=$CORD"
  "$t/closed_p3.svg=$IV=$SH" "$t/closed_cord3.svg=$CORD" "$t/closed_button.svg=$BTN" "$t/closed_button2.svg=$BTN"
  "$t/closed_buttonart.svg=$CORD" )
node tools/compose.js renders/closed.png "-95 -192 190 112" 1400 "${CLOSED[@]}"
node tools/compose.js renders/medallion_closeup.png "-40 -150 80 46" 1400 "${CLOSED[@]}"
rm -rf "$t"
