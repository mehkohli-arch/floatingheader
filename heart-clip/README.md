# Heart clip

A heart-shaped, suspender-style locking clip for hanging a flowstar from a bag. From the front it's just a heart with a keychain ring. The hinge, jaw and grip wheel are hidden behind it.

![front](images/front.png) ![angle](images/angle.png) ![open](images/open.png)

## Using it
Made to work with long nails, shaky hands, or after a few drinks: big simple motions, nothing fiddly.

1. **Hang it:** put a keychain ring or lobster clasp through the ring at the top and onto your bag.
2. **Open:**
   - **Easiest:** hook a fingertip or nail under the bottom edge of the heart and lift. The back of the edge is bevelled so it catches easily.
   - **Or:** press the top of the heart backward firmly with your thumb. It pivots like a seesaw.
3. **Insert:** hold the heart up with one hand and push the flowstar's canvas trim up into the gap between the two hearts with the other. It slides in over the teeth. The heart falls closed on its own if you let go, so keep a thumb on it.
4. **Close:** press the middle of the heart until it clicks flat. Until it clicks, the trim pushes it back open, so you can see when it isn't locked.

### Set the grip once for your trim
The toothed wheel at the **right-hand edge**, between the two hearts, sets how tight the jaw closes.
- **Flick a tooth:** each tooth is about 0.5 mm. Rolling the wheel's front edge **up tightens**; **down loosens**.
- **Easiest with the heart open:** the wheel turns freely then.
- **Check it:**
  1. Close the clip on the trim and give it a firm tug.
  2. If it slips, open the heart, flick one tooth tighter and try again.
  3. If the heart is hard to click shut, flick one tooth looser.
- **Leave it:** once it's right, leave the wheel alone. Daily use is just open, insert, close.
- **Range:** about **0.3–5 mm** of trim, from single canvas to folded in half. Past either end it wraps round to the other end, so if one flick suddenly makes it much tighter or looser, flick back.

![wheel](images/side_wheel.png)

![how it works](images/how_it_hangs.png)

## What you need
| | |
|---|---|
| **Printed** | body, heart, arm, blade, cam, dial shaft, wheel, 2 snap clips (all on one plate: `heart_clip_all_parts.stl`, 173 × 99 mm) |
| **Bought** | **2 × steel dowel pins, 3 mm × 25 mm** (stainless). Printed pins would bend under a firm grip, and steel looks finished and needs no glue. |
| **Tools** | a vise or clamp (or a small hammer) to press the pins in, and a 3 mm drill bit to clear any strings from the holes |

No glue anywhere.

## Getting a clean, finished look
The design already does the heavy lifting:
- **Every face you look at prints against the build plate**, so it has no layer lines at all: the front of the heart, and the back of the clip. Their finish is whatever your build plate's surface is.
- **Edges are rounded or chamfered in fine slices**, so they print smoothly instead of as visible steps.
- **The bottom edge of each part has a small chamfer**, which hides the first-layer squish ("elephant's foot").
- **Steel pins sit 1 mm inside the hinge posts, and the snap clips and wheel are tucked behind the heart**, so no fasteners show from the front.

Then these settings finish the job (Creality Print 6 or OrcaSlicer; both have every option below).

### Build plate: decides how the front of the heart looks
- **Textured PEI** (or the V3 SE's stock textured sheet): an even matte finish, like an injection-moulded product. Most forgiving; PETG releases cleanly. **Recommended.**
- **Smooth PEI**: a glossy, mirror-like face. Use a thin layer of glue stick as a release: PETG can bond to bare smooth PEI hard enough to tear the coating.

### Filament
- **One colour for every part** looks most like a product. Matte or silk PETG hides layer lines on the edges better than glossy.
- **Dry the PETG before printing** (a filament dryer, or the oven at its lowest setting, for a few hours). Wet PETG strings and blobs, and that shows most on seams.

### Slicer settings (Ender-3 V3 SE profile, PETG)
| Setting | Value | Why |
|---|---|---|
| Layer height | **0.12 mm** for `heart` and `body` (or "variable layer height" on the heart's edge); 0.2 mm for the hidden parts | finer lines on the edges you can see |
| Seam | **Scarf seam ON** (outer walls), seam position **Aligned**, then **paint the seam** onto the heart's top dip (between the lobes) and onto the ring's back | hides the start/stop line where it can't be seen |
| Wall order | outer wall first / "precise wall" ON | smoother outer surface |
| Ironing | **Top surfaces only**, on `body` only: flow 10 %, speed 15 mm/s, spacing 0.1 mm | smooths the visible rim and ring face on the body |
| Nozzle / bed | 240 °C / 75 °C | |
| Outer wall speed | 40 mm/s (inner walls 80, infill 100). **Don't use the 250 mm/s preset** for PETG | slow outer walls = cleaner surface and stronger layer bonding |
| Cooling | 30–40 % (100 % for bridges) | |
| Retraction | 0.8 mm at 40 mm/s, wipe on | less stringing |
| First layer | 25–30 mm/s, Z-offset about 0.03 mm higher than for PLA | clean, flat show faces |
| Elephant foot compensation | 0.1 mm | the model also has bed chamfers |
| Walls / infill | 4 walls; 40 % gyroid for body and heart, **100 %** for everything else | strength |
| Supports | none | |

**Enclosure:** PETG doesn't need it. Keep the door cracked so the chamber stays under about 35 °C, otherwise PETG can soften in the extruder and jam.

### Optional finishing touches
- **Strings and fuzz:** a brief pass with a heat gun on low takes off fine strings. Keep it moving, since PETG softens quickly.
- **Edges:** PETG can't be vapour-smoothed like ABS. For an even smoother edge, wet-sand it lightly at 400 then 800 grit.
- **Painting:** for a painted finish, use filler primer, sand at 400–600 grit, repeat, then paint. With the show faces printed on the plate, you shouldn't need any of this.

## Print and fit test
1. **Print `fit_test.stl` first** (about 15 min).
   - **Steel-pin holes:** test with one of your steel pins. It should **press** into a hole marked 1–3 (pick the one that's firm but goes in with a clamp), and **turn freely** in a hole marked 4–6.
   - **D-holes:** the printed D-shaft piece should slide into a D-hole without wobble, and the test clip should snap into its groove.
   - **If a fit is off:** tell me which hole fits, or set `pin_clr_wall`, `pin_clr_mov` or `bore_clr` in `heart_suspender_clip.scad`.
   - **The numbers:** steel-pin holes 1–6 are −0.05, 0.00, +0.05, +0.20, +0.30 and +0.40 mm; D-holes 1–3 are +0.1, +0.2 and +0.3 mm.
2. **Print the plate** (`heart_clip_all_parts.stl`). Every part is already in its print orientation.
3. **Clear any strings** from the holes with a 3 mm drill bit turned by hand.

## Assembly (no glue)
1. **Build the jaw (off the clip):**
   1. Put the blade (teeth facing back) between the jaw arm's side plates.
   2. Drop the cam in front of it.
   3. Slide the D-shaft in from the right through the arm and the cam (the collar stops it).
   4. Push the wheel onto the right end.
   5. Snap a clip onto the groove at each end.
2. **Fit the jaw:** set the whole jaw between the **lower** hinge posts and press a steel pin through with a vise or clamp.
3. **Fit the heart:**
   1. Hold the heart tilted about halfway open and slide it down from above, so its hinge goes in behind the top bar of the jaw.
   2. Press the second steel pin through the **upper** hinge posts.
   3. Fold the heart closed until it clicks.

## How it works
- **Jaw arm:** pivots on the lower pin. The heart's cam pushes its top bar.
- **Blade:** the gripping jaw, with one-way barbed teeth. It hangs on the same pin inside the arm.
- **Grip cam:** a shallow spiral cam on the wheel's shaft, between the arm's side plates. It sets how far back the blade sits.
  - It only moves the blade, so the heart opens, closes and locks the same way at every wheel setting.
  - It's shallow enough that friction holds it, so the trim's push can't turn it.
- **Heart:** pivots on the upper pin. Its cam pushes past dead-center to lock, so pulling on the flowstar pushes the heart further closed.

## What was checked in the 3D model
At trim settings 0.3, 1, 2, 3, 4 and 5 mm, with the heart at its true resting angle:
- **Collisions:** no part touches any other except where intended: cam on blade, heart cam on jaw arm, heart stop tabs, and the steel pins pressed into the posts.
- **Clearances:** every other gap is at least 0.2 mm (moving fits) or 0.3 mm (everything else).
- **Lock:** the heart's cam rests firmly on the jaw arm when locked, with no slack.
- **Grip:** the closed barbs press 0.45–1.24 mm into the trim.
- **Opening:** with the heart open, the jaw opens at least 1.12 mm wider than the trim.
- **Closing on open trim:** the heart closes smoothly onto a jaw held open by the trim. It pushes the jaw shut through about 1° of extra squeeze at the click, then settles locked, with no jamming at any angle.
- **Wheel:** the grip cam self-locks with a 2.6–4.1× margin (assuming PETG friction of 0.3), and the wheel, shaft, cam and clips turn a full 360° without touching anything.

Also checked:
- **Heart travel:** the heart opens to about 65° without touching the body.
- **Assembly:** the whole jaw drops onto the body, and the tilted heart slides in.
- **Print files:** every part prints in its exported orientation without supports, each file is a single, closed solid, and the plate parts are at least 2 mm apart.

## Strength
These are estimates, not test results: a firm 40 N clamp plus a 5 kg yank on the trim, against roughly 45–50 MPa for PETG printed along its layers.

| Part | Stress |
|---|---|
| Steel pins | about 120 MPa, far below steel's limit |
| 4 mm dial shaft (printed lying down, along layers) | about 35 MPa |
| Blade | about 23 MPa |
| Jaw arm | 16 MPa or less |
| Hinge posts (across layers) | about 15 MPa |
| Heart's hinge ears, if the open heart is yanked with 2 kg against its stop | about 10 MPa |

A hard yank on the flowstar should pull the trim out of the teeth before anything breaks. None of this has been tested on a printed clip, so give it a few firm tugs on the real trim before trusting it.

## Editing
Everything is generated from `heart_suspender_clip.scad` (OpenSCAD). Set `PART` to `assembly`, `open`, `plate`, `fit_test` or a single part name to preview or export it. `GRIP` sets the trim thickness shown in previews.

## Sources for the finish settings
- [Visible layer lines: layer height, variable layer height, seams (Industrial Monitor Direct)](https://industrialmonitordirect.com/blogs/knowledgebase/bambu-lab-p2s-layer-seam-line-elimination)
- [Ironing guide (Snapmaker)](https://www.snapmaker.com/blog/ironing-in-3d-printing/) · [OrcaSlicer ironing settings](https://stacksheriff.com/3d-printing/orcaslicer-ironing-settings-explained/)
- [OrcaSlicer seam settings](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_seam) · [Scarf seam guide (Printables)](https://printables.com/model/783313-better-seams-an-orca-slicer-guide-to-using-scarf-s) · [Seam gap tips (Obico)](https://www.obico.io/blog/orcaslicer-seam-settings/)
- [Textured vs smooth PEI](https://evezone.evetech.co.za/deep-dives/textured-pei-vs-smooth-pei-build-plates-which-finish-for-which-print) · [Prusa textured sheet](https://www.prusa3d.com/en/product/textured-powder-coated-steel-sheet/)
- [Snap-fit clearances for PETG (Qidi)](https://qidi3d.com/blogs/print-lab/3d-printed-snap-fit-joints-clearance-guide) · [Glue-free snap hinge pin (MakerWorld)](https://makerworld.com/models/1218145)
- [PETG smoothing (SelfCAD)](https://www.selfcad.com/blog/petg-smoothing-what-you-need-to-know) · [Sanding and filling 3D prints (33d.ch)](https://www.33d.ch/en/blog/how-to-sand-smooth-fill-and-paint-3d-printed-surfa) · [Post-processing (Prusa)](https://blog.prusa3d.com/postprocessing-of-3d-prints-step-by-step/)
