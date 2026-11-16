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

## Parts (`stl/`)
| File | Print orientation | Material |
|---|---|---|
| `heart_clip_all_parts.stl` | everything laid out (143 × 89 mm) | |
| `body.stl` | back down | PLA or PETG |
| `heart.stl` | front face down | PLA or PETG |
| `arm.stl` | front face down | PETG |
| `blade.stl` | on its side | PETG |
| `cam.stl` | flat | PETG |
| `dial.stl` | standing, lever down (use a brim) | PETG |
| `cap.stl` | flat | any |
| `pin.stl` | lying flat. **Print 2**, or use 3 mm steel pins | PETG |

No supports needed. Use 0.2 mm layers, 4 walls and 40%+ infill. The finished clip is 52 × 64 mm and 19 mm thick.

## Assembly
1. Put the blade (teeth facing back) between the arm's two side plates, set both between the lower hinge posts, and push a pin through.
2. Put the cam between the arm's side plates, in front of the blade. Slide the dial in from the right, through the arm and cam, and glue the cap onto its left end. Glue only the cap to the dial.
3. Put the heart's hinge between the upper hinge posts, behind the arm's top, and push the second pin through. Add a drop of glue on the pin ends.

## Editing
Everything is generated from `heart_suspender_clip.scad` in OpenSCAD. Set `PART` to preview or export a single part.
