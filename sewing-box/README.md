# Loaf Cat Sewing Box

A large sewing box shaped like a cat, with lift-out trays that have snap-on lids.

![assembled](renders/assembly.png)

| | |
|---|---|
| ![exploded](renders/exploded.png) | ![tail side](renders/side_tail.png) |

## Size
- **Body:** 330 W × 240 D × 290 H mm (13 × 9.5 × 11.4 in). It is about 355 mm tall to the ear tips.
- **Inside:** 322 × 232 mm, about 286 mm deep.
- **Trays:** there are two stacks, left and right. Each stack is a 60 mm deep tray with a 45 mm shallow tray on top. The deep tray hangs from a ledge on its end lugs, and the shallow tray sits on the deep tray's lid.
- **Bin:** a clear 166 mm deep space under the trays for fabric, scissors and projects in progress.

## Parts (`stl/`) — bed needed: 250 × 250 mm
| File | Qty | Notes |
|---|---|---|
| body_lower_left / _right | 1 each | Print upright, no supports |
| body_upper_left / _right | 1 each | Print upright. The ledge has a built-in 45° gusset |
| lid_left / _right | 1 each | Prints top-face-down; the lip points up |
| ear_left / _right | 1 each | Print flat. Good candidates for a colour swap |
| tray_deep_grid | 1 | 3 × 4 grid (bobbins, buttons) |
| tray_deep_split | 1 | 2 large bays |
| tray_shallow_grid | 1 | 2 × 3 grid |
| tray_shallow_long | 1 | 3 long slots (needles, seam ripper, chalk) |
| tray_lid | 4 | Prints top-down. A button motif is pressed into the top |

Suggested settings: PLA or PETG, 0.2 mm layers, 3 walls, 15 % infill. Print the tray lids in PLA or PETG; PETG gives the snap a bit more spring.

The face, paws, bell and tail are raised 1.6–3 mm. Use a filament/colour change at those heights, or paint them.

## Assembly
1. **Pins:** cut 1.75 mm filament into 11 mm pieces and use them as dowels in the 2 mm holes on every split face.
2. **Halves:** glue the left and right halves together with CA glue, or with plastic weld for PLA. Do this for the lower tier, the upper tier and the lid.
3. **Tiers:** the lower tier has a sleeve that the upper tier slides over. Glue it; the seam hides under the cat's collar.
4. **Ears:** push the ears' pegs into the sockets in the lid and glue them. The ears double as lid handles.
5. **Tray lids:** press each lid onto its tray until it clicks. To open, push up on the small tab above the lug.

## Customising
Everything is set by parameters in `cat_sewing_box.scad`: the box size, tray heights, divider grids, how tight the snap is, and so on. Export a part with:
```
openscad -D 'part="tray_lid"' -o tray_lid.stl cat_sewing_box.scad
```
- **Snap too tight or too loose:** change `CATCH`. The default 0.25 gives 0.35 mm of interference; raise it to loosen the snap.
- **220 mm bed (e.g. Ender 3):** set `D = 215` and `TD = 184`.
- **12 in front-to-back:** set `D = 305` and `TD = 272`. The body halves then need a 310 mm bed, or split them further.
