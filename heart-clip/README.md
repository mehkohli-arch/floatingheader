# Heart clip

A heart-shaped clip for hanging a flowstar from a bag. From the front it's just a heart with a keychain ring; everything else is hidden behind it.

![front](images/front.png) ![angle](images/angle.png) ![open](images/open.png)

## Using it
1. **Ring:** clip the ring at the top onto your bag with a keychain ring or lobster clasp.
2. **Open:** lift the heart's point out and up. The jaw opens at the bottom, between the two hearts.
3. **Insert:** push the flowstar's canvas trim up into the jaw.
4. **Close:** fold the heart flat. It clicks shut and locks.

**Thickness dial (set once):** with the heart open, the small lever on the right side of the jaw sets the grip, from 0.6 mm (single canvas) to 5 mm (trim folded in half).
If the heart is hard to close, turn it toward thick. If the trim slips, turn it toward thin.
The dial never changes how the heart opens or closes.

![how it works](images/how_it_hangs.png)

## Built for tugging
- **Grip:** big one-way barbs on both jaws interlock and press about 0.7–0.9 mm into the trim at every setting. That forces the canvas into a deep zigzag, which grips far harder than a flat squeeze, and a pull digs the barbs in further.
- **Lock:** the heart locks 12° past dead-center. Pulling on the flowstar pushes the heart further closed, so tugging can't open it. Opening takes only a light lift on the heart's point.
- **Dial:** the dial's spiral is self-locking, so a pull can't turn it.
- **Strength:** the parts are much stronger than the grip. The 3 mm pins can take roughly 40 kg each and the ring more than that, so a hard yank would drag the trim out of the teeth before anything breaks.
  For the most strength, use 3 mm steel pins (cut nails or dowel pins) instead of printed ones.
- **Rough estimate, not tested:** about 3–7 kg of steady pull before canvas slides. Give it a few firm tugs before trusting it.

## Printing on a Creality Ender 3 V3 SE with PETG
The model is already tuned for this printer and filament. Holes are a little bigger than nominal because the V3 SE prints them slightly small and PETG oozes. There's a 0.3 mm side gap where the first-layer squish would otherwise jam parts, and every horizontal hole is a teardrop so it prints without supports.

### 1. Print the fit test first (`fit_test.stl`, about 15 min)
- **Pin holes:** a block with 6 pin holes, marked with 1–6 notches (0.10 to 0.35 mm clearance). Each hinge post is a 2.5 mm-thick plate, so try the test pin in each hole from both sides.
  - The pin should push into hole **3** with firm finger pressure. That's the fit for the hinge posts.
  - The pin should spin freely in hole **5**. That's the fit for the swinging parts.
- **D-holes:** a block with 3 D-shaped holes and a short D-shaft piece. The shaft should slide into D-hole **2** with no wobble. That's the fit for the dial in the cam.
- **If a fit is off:** in `heart_suspender_clip.scad`, change `pin_clr_wall` (hole 3), `pin_clr_mov` (hole 5) or `bore_clr` (D-hole 2) to the clearance of the hole that fit, then re-export.
  The clearances are hole 1 = 0.10, 2 = 0.15, 3 = 0.20, 4 = 0.25, 5 = 0.30, 6 = 0.35 for pins, and D-hole 1 = 0.10, 2 = 0.20, 3 = 0.30.

### 2. Slicer settings (Creality Print, Cura or Orca with the Ender-3 V3 SE profile and Generic PETG)
| Setting | Value |
|---|---|
| Nozzle / layer height | 0.4 mm / 0.2 mm |
| Nozzle temperature | 240 °C (230–245) |
| Bed temperature | 75 °C |
| Bed surface | the stock PC/PEI sheet **with a thin layer of glue stick**. PETG can bond too hard to bare PEI and tear it |
| First layer | 0.2 mm at 25–30 mm/s. Set Z-offset about 0.03 mm higher than for PLA (PETG doesn't like to be squished) |
| Elephant foot compensation | 0.15 mm (if your slicer has it) |
| Speeds | outer wall 50 mm/s, inner walls 80 mm/s, infill 100 mm/s. **Don't use the 250 mm/s preset for PETG**: it weakens layer bonding, and these parts need to be strong |
| Cooling fan | 30–40 % (100 % for bridges) |
| Retraction (Sprite direct drive) | 0.8 mm at 40 mm/s, wipe on, z-hop 0.2 mm |
| Walls / top & bottom | 4 walls / 5 layers |
| Infill | 40 % gyroid. Use **100 %** for the pins, dial, cam and blade (small parts, max strength) |
| Supports | none |
| Brim | not needed, but use a 3 mm brim on the blade if your first layer is marginal |

**Enclosure:** PETG doesn't need it. Leave the door cracked open or vented so the chamber stays under about 35 °C, otherwise PETG can soften in the extruder and jam. Close it fully only if the room is cold or drafty.

### 3. Print the clip
`heart_clip_all_parts.stl` (145 × 89 mm) fits the 220 × 220 bed in one go, about 4–5 hours. Every part is already in its correct print orientation:

| File | Orientation (as exported) |
|---|---|
| `body.stl` | back down |
| `heart.stl` | front face down |
| `arm.stl` | front face down |
| `blade.stl` | on its side |
| `cam.stl` | flat |
| `dial.stl` | lying on its flat side (layers run along the shaft, so it's strong) |
| `cap.stl` | flat |
| `pin.stl` | lying flat. **Print 2**, or use 3 mm steel pins (cut nails or dowel pins) for the most strength |

After printing, remove any PETG strings from the hinge holes with a 3 mm drill bit turned by hand.

## Assembly
1. Put the blade (teeth facing back) between the arm's two side plates, set both between the lower hinge posts, and push a pin through.
2. Put the cam between the arm's side plates, in front of the blade. Slide the dial in from the right, through the arm and cam, and glue the cap onto its left end. Glue only the cap to the dial.
3. Put the heart's hinge between the upper hinge posts, behind the arm's top, and push the second pin through. Add a drop of glue on the pin ends.

## Editing
Everything is generated from `heart_suspender_clip.scad` in OpenSCAD. Set `PART` to preview or export a single part.
