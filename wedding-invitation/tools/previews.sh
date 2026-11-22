#!/usr/bin/env bash
# Renders renders/front.png, envelope_open.png, envelope_closed.png
set -euo pipefail
cd "$(dirname "$0")/.."
t=$(mktemp -d)
for p in plate engraved flaps_open hinges_open fold_left fold_right fold_bot fold_top fold_seal fold_sealart; do
  openscad -q -o "$t/$p.svg" -D "part=\"2d_$p\"" invitation.scad; done
export NODE_PATH=$(npm root -g)
IV='#fcfaf5'; SH='0.4px 0.9px 0.9px rgba(70,45,35,.35)'
node tools/compose.js renders/front.png "-70 -96 140 192" 1300 \
  RECT=-50.8,-76.2,101.6,152.4=#e3b8ab "$t/plate.svg=$IV=$SH" "$t/engraved.svg=gold"
node tools/compose.js renders/envelope_open.png "-200 -185 400 370" 1500 \
  RECT=-50.8,-76.2,101.6,152.4=#e3b8ab "$t/hinges_open.svg=#efe8dc" "$t/flaps_open.svg=$IV=$SH" "$t/plate.svg=$IV=$SH" "$t/engraved.svg=gold"
node tools/compose.js renders/envelope_closed.png "-70 -96 140 192" 1300 \
  "$t/plate.svg=$IV=$SH" "$t/fold_left.svg=$IV=$SH" "$t/fold_right.svg=$IV=$SH" "$t/fold_bot.svg=$IV=$SH" \
  "$t/fold_top.svg=$IV=$SH" "$t/fold_seal.svg=#f6f1e7=0.5px 1.2px 1.2px rgba(70,45,35,.4)" "$t/fold_sealart.svg=gold"
rm -rf "$t"
