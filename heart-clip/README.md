# Heart suspender clip (lever / locking-tab style)

A heart-shaped clip in the classic suspender style, with a flip-up locking tab instead of a screw.

![closed](images/closed.png) ![open](images/open.png)

## Parts (`stl/`)
| File | Print orientation | Notes |
|---|---|---|
| `body.stl`  | back flat on bed | heart plate, strap loop, hinge cheeks, teeth |
| `lever.stl` | front face down  | heart tab with toothed over-center cam |
| `pin.stl`   | lying flat       | 3 mm hinge pin. A 3 mm steel rod or a cut nail also works |

No supports are needed: the horizontal holes are teardrop-shaped. Use PETG or PLA, 0.2 mm layers, at least 4 walls, and 40%+ infill so the cam and cheeks are solid.

![plate](images/print_plate.png)

## Assembly
1. Set the lever between the cheeks, with the heart over the body.
2. Push the pin through cheek, lever, then the other cheek. Add a drop of CA glue at each end, or melt the ends slightly.

## Use
Flip the heart tab up to open a ~3 mm gap. Slide the fabric in from the point of the heart, then press the tab down.
The cam rolls 10° past dead-center onto the teeth and locks. Pulling the fabric pulls it tighter.

## Customising (`heart_suspender_clip.scad`)
Set `PART` to `assembly`, `open`, `body`, `lever`, `pin` or `plate`. Useful parameters:
- `heart_w`: overall size (default 44 mm)
- `strap_w` / `strap_gap`: strap loop opening for the strap you attach
- `grip_gap`: lower this for thin fabric, raise it for thick fabric
- `pin_clr_lever` / `pin_clr_body`: hinge fit for your printer
- `overcenter`: increase for a harder snap
