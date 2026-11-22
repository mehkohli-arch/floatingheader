#!/usr/bin/env bash
# Builds the print files. Needs OpenSCAD and `pip install manifold3d trimesh`.
# The flat envelope is rotated 45 degrees so it fits a 256 x 256 mm bed.
set -euo pipefail
cd "$(dirname "$0")/.."
tmp=$(mktemp -d); mkdir -p stl
for p in layer_face layer_main layer_pockets layer_flaps inlay; do
  openscad -q -o "$tmp/$p.stl" -D "part=\"$p\"" invitation.scad; done
python3 tools/merge.py --rotz=45 stl/envelope_invitation_body.stl \
  "$tmp/layer_face.stl" "$tmp/layer_main.stl" "$tmp/layer_pockets.stl" "$tmp/layer_flaps.stl"
python3 tools/merge.py --rotz=45 stl/envelope_invitation_inlay_gold.stl "$tmp/inlay.stl"
rm -rf "$tmp"
