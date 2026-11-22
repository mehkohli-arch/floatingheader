#!/usr/bin/env bash
# Builds the print files. Needs OpenSCAD and `pip install manifold3d trimesh`.
set -euo pipefail
cd "$(dirname "$0")/.."
tmp=$(mktemp -d); mkdir -p stl
for p in layer_face layer_main layer_pockets; do openscad -q -o "$tmp/$p.stl" -D "part=\"$p\"" invitation.scad; done
python3 tools/merge.py stl/invitation_body.stl "$tmp/layer_face.stl" "$tmp/layer_main.stl" "$tmp/layer_pockets.stl"
openscad -q -o "$tmp/inlay.stl" -D 'part="inlay"' invitation.scad
python3 tools/merge.py stl/invitation_inlay_gold.stl "$tmp/inlay.stl"
rm -rf "$tmp"
