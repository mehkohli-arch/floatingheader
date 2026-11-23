#!/usr/bin/env bash
# Renders renders/front.png from the 2D artwork (needs Node + Playwright)
set -euo pipefail
cd "$(dirname "$0")/.."
t=$(mktemp -d)
for p in plate engraved; do openscad -q -o "$t/$p.svg" -D "part=\"2d_$p\"" invitation.scad; done
IW=$(grep -oP '^insert_w = \K[0-9.]+' invitation.scad); IH=$(grep -oP 'insert_h = \K[0-9.]+' invitation.scad)
NODE_PATH=$(npm root -g) node tools/compose.js renders/front.png "-64 -86 128 172" 1300 \
  "RECT=$(python3 -c "print(f'{-$IW/2},{-$IH/2},$IW,$IH')")=#e3b8ab" \
  "$t/plate.svg=#fcfaf5=0.4px 0.9px 0.9px rgba(70,45,35,.35)" "$t/engraved.svg=gold"
rm -rf "$t"
