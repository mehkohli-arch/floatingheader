# Heart suspender clip (heart pacifier-clip style, hinge hidden)

From the front it's just a heart with a keychain ring at the top. The hinge, jaw and teeth all sit behind the heart.
Hang it from your bag by the ring. The jaw mouth opens downward between the front heart and the heart-shaped back plate, and the flowstar clips in there and hangs below.

![front](images/closed.png) ![angle](images/closed_angle.png) ![open](images/open.png)

![how it hangs](images/how_it_hangs.png)

## How it works
- **Body:** a heart-shaped back plate with teeth, two pairs of hinge knuckles and the keychain ring.
- **Front jaw:** pivots on pin B. Below the pin it's the gripping blade; above the pin it has a short tail.
- **Front heart:** the locking lever, on pin A behind the jaw's tail. Its cam pushes the tail forward, which swings the blade back onto the teeth.
  Lift the heart's point out and up to release the jaw, push the flowstar's edge up into the mouth, then fold the heart flat.
  The cam rolls 8° past dead-center and locks. Two small stops behind the heart rest it flat.

## Thickness: six swappable front jaws
| Front jaw | Grips | Mouth opens to |
|---|---|---|
| `jaw_size0.stl` | 0 – 1 mm (thin fabric, straps) | 2.2 mm |
| `jaw_size1.stl` | 1 – 2 mm | 3.1 mm |
| `jaw_size2.stl` | 2 – 3 mm | 4.1 mm |
| `jaw_size3.stl` | 3 – 4 mm | 5.1 mm |
| `jaw_size4.stl` | 4 – 5 mm | 6.1 mm |
| `jaw_size5.stl` | 5 – 6 mm (e.g. thick fabric folded in half) | 7.0 mm |

Each blade bends a little, like the steel plate in a metal clip, so the heart always closes flat. To swap a jaw, push out pin B (the lower pin).
Fabric squashes, so a folded flowstar fits the size matching its *lightly pinched* folded thickness, and often the size below too.

## Pulling and tugging
- **The teeth are one-way barbs.** On both jaws the flat face points down, so the flowstar slides in easily but a pull drags it into the barbs.
- **A pull can't flip the heart open.** The cam sits 8° past dead-center, so a pull on the flowstar pushes the heart further *closed* against its stops.
- **Clamp force (PETG):** about 6 N at the thin end of each jaw size and about 16 N at the thick end, with the teeth on both faces crimping the material.
  Friction alone holds roughly 0.5–1.5 kg of steady pull. The barbs add a lot on top of that for fabric.
- **Strength:** the ring, the pins (3 mm, supported on both sides) and the blade under tension can each take well over 30 kg, so a tug pulls the flowstar out of the teeth before anything breaks.
- **Not tested on a printed part.** These are estimates. Give it a few firm tugs before trusting it, and if it slips, use the next jaw size up.

## Parts (`stl/`)
| File | Print orientation |
|---|---|
| `heart_clip_all_parts.stl` | everything laid out (body, heart, 6 jaws, 2 pins), 153 × 76 mm |
| `body.stl` | back flat on bed |
| `heart.stl` | front face down |
| `jaw_size0-5.stl` | standing on edge (as exported), so the blade's layers run the strong way |
| `pin_x2.stl` | lying flat, print 2. A 3 mm steel rod also works |

No supports are needed. **Print the jaws in PETG**, because the blade has to spring (the thick end of each size bends it about 1.6 mm, which is too much for PLA over time). The body and heart can be PLA. Use 0.2 mm layers, 4 walls and 40%+ infill.
The clip is 52 mm wide, about 64 mm tall with the ring, and about 18 mm thick.

## Assembly
1. Put the jaw between the lower knuckles with the blade pointing down, then push a pin through (pin B).
2. Put the heart's hinge between the upper knuckles, behind the jaw's tail, then push a pin through (pin A).
3. Add a drop of CA glue on pin A's ends. Leave pin B unglued if you want to swap jaws.

## Customising (`heart_suspender_clip.scad`)
`PART` = `assembly` | `open` | `body` | `jaw` | `heart` | `pin` | `plate`, and `JAW_SIZE` = 0–5.
Useful parameters are `heart_w`, `ring_hole`, `size_step`, `blade_t` (grip stiffness) and the pin clearances.
