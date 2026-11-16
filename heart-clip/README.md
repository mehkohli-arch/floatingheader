# Heart suspender clip (heart pacifier-clip style, hinge hidden, thickness dial)

From the front it's just a heart with a keychain ring at the top. The hinge, jaw, teeth and dial all sit behind the heart.
Hang it from your bag by the ring. The jaw mouth opens downward between the front heart and the heart-shaped back plate, and the flowstar's canvas trim clips in there and hangs below.

![front](images/closed.png) ![angle](images/closed_angle.png) ![open](images/open.png)

![how it hangs](images/how_it_hangs.png)

## How it works
- **Jaw arm:** pivots on pin B. Its tail is what the heart's cam pushes.
- **Front heart:** the locking lever, on pin A. Lift its point out and up to open, fold it flat to lock. The cam rolls past dead-center, so a pull on the trim pushes the heart further closed.
- **Blade:** the gripping jaw with one-way barbed teeth. It hangs on the same pin B, between the arm's two cheeks.
- **Dial cam:** a small spiral cam on a shaft through the arm, in front of the blade. Its lever sets how far back the blade sits.

**The dial never affects opening or closing.** The heart and the jaw arm move exactly the same at every dial setting; the dial only moves the blade inside the arm.
I checked this in the model at 0.6, 1.5, 2.5, 3.5, 4.5 and 5.0 mm: same heart motion, same lock, no collisions.

## Setting the dial (do it once for your trim)
With the heart open, the dial lever is on the right side of the jaw arm. Turn it so the blade sits further back for thin trim, or further forward for thick trim.
Then close the heart on the trim: it should snap down firmly. Too stiff to close? Turn the dial a little toward thick. Trim slips? Turn it a little toward thin.
The dial is continuous (no clicks) and covers about **0.6–5 mm**, from a single canvas layer up to the trim folded in half.
Its spiral is shallow enough that the trim's push can't turn it.

| Trim | Grip gap the model gives |
|---|---|
| 0.6 mm | 0.14 mm (squeezed) |
| 1.5 mm | 1.07 mm |
| 2.5 mm | 2.07 mm |
| 3.5 mm | 3.05 mm |
| 4.5 mm | 4.00 mm |
| 5.0 mm | 4.47 mm |

With the heart open, the mouth is always 2.3+ mm wider than the trim it's set for.

## Pulling and tugging
- Barbed teeth on both jaws: the trim slides in easily, and a pull digs the teeth in. Canvas weave grips these well.
- A pull can't flip the heart open, because its cam is past center. It also can't turn the dial, because the spiral is self-locking.
- **Estimate, not tested:** the ring, pins, arm and blade are each far stronger than the grip, so a hard yank pulls the trim out of the teeth before anything breaks. Give it a few firm tugs before trusting it.

## Parts (`stl/`)
| File | Print orientation |
|---|---|
| `heart_clip_all_parts.stl` | everything laid out, 143 × 89 mm |
| `body.stl` | back flat on bed |
| `heart.stl` | front face down |
| `arm.stl` | front face down |
| `blade.stl` | on its side |
| `cam.stl` | flat |
| `dial.stl` | standing, lever on the bed. Use a brim |
| `cap.stl` | flat |
| `pin.stl` | lying flat. **Print 2** (pins A and B) |

No supports are needed. PETG is recommended for the arm, blade, cam and dial; PLA is fine for the body and heart. Use 0.2 mm layers, 4 walls and 40%+ infill.
The clip is 52 mm wide, about 64 mm tall with the ring, and about 19 mm thick.

## Assembly
1. Put the blade between the arm's cheeks, teeth facing back, and set both between the lower knuckles. Push a pin through (pin B).
2. Put the cam between the cheeks, in front of the blade. Slide the dial shaft in from the right (lever outside), through the cheek, cam and other cheek. The D-shaped shaft keys into the cam.
3. Glue the cap onto the shaft's left end. Glue only the cap to the shaft, so the dial can still turn.
4. Put the heart's hinge between the upper knuckles, behind the arm's tail, and push the second pin through (pin A). Add a drop of glue on the pin ends.

## Customising (`heart_suspender_clip.scad`)
`PART` = `assembly` | `open` | `body` | `heart` | `arm` | `blade` | `cam` | `dial` | `cap` | `pin` | `plate`, and `GRIP` sets the trim thickness for previews.
Useful parameters are `grip_max` (dial range), `preload`, `heart_w` and `ring_hole`.
