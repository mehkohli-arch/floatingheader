// =====================================================================
//  Heart Suspender Clip  (lever / locking-tab style, no screw)
// ---------------------------------------------------------------------
//  Hang it from your keys by the ring at the TOP of the heart. The jaw sits
//  in a little hinge bar under the heart's point and clips onto the star (or
//  any strap/fabric) below. The whole front heart is the locking tab.
//
//  Three printed parts:
//    1. BODY  - heart back plate, keychain ring on top, hinge bar + teeth below
//    2. LEVER - front heart (the locking tab) with an over-center toothed cam
//    3. PIN   - hinge pin (or use a 3 mm steel rod / cut nail)
//
//  Flip the heart out, push the star's edge up into the jaw from below, press
//  the heart back down. The cam rolls just past dead-center and locks; the
//  star's weight pulls it tighter, not open.
//
//  X = width, Y = up, Z = out of the back plate (heart upright as modelled).
//
//  PART = "assembly" | "open" | "body" | "lever" | "pin" | "plate"
// =====================================================================

PART = "plate";

/* [Size] */
heart_w      = 44;    // overall width of the body heart (mm)
plate_t      = 2.6;   // back plate thickness
lever_inset  = 2.5;   // how much smaller the front heart is than the body
lever_t      = 3.5;   // lever thickness
round_c      = 1.0;   // soft (stepped 45 deg) edge size

/* [Keychain ring] */
ring_hole    = 7;     // hole for a split ring / lobster clasp
ring_wall    = 3.2;   // ring band width
ring_t       = 3.2;   // ring thickness

/* [Hinge + cam] */
pin_d        = 3.0;   // hinge pin diameter
pin_clr_body = 0.15;  // pin clearance in cheeks (snug)
pin_clr_lever= 0.25;  // pin clearance in lever (free spin)
hub_wall     = 2.0;   // lever wall around pin
cheek_r      = 4.0;   // cheek knuckle radius around the pin
lever_half   = 9.6;   // half-width of the cam = grip width / 2
side_clr     = 0.4;   // gap between lever neck and cheeks
tooth_h      = 0.6;   // body tooth height
preload      = 1.0;   // how far the cam pushes the spring jaw with nothing in it
open_gap     = 4.5;   // free jaw gap with the heart flipped open

/* [Spring jaw] -- makes the clip fit many thicknesses (0 to ~5 mm) */
tongue_t     = 1.5;   // spring tongue thickness (thinner = softer)
tongue_w     = 18;    // spring tongue width
tongue_top   = 31;    // where the tongue joins the heart (longer = more travel)
tongue_slot  = 0.8;   // slot around the tongue
overcenter   = 10;    // degrees the cam rests past dead-center

$fn = 64;

// ---------------- derived -------------------------------------------
s        = heart_w / (1 + sqrt(2)/2);    // heart base square side
H        = s * (3/(2*sqrt(2)) + 0.5);    // heart height
y_p      = cheek_r + 2.4;                // hinge axis (bottom bar)
dip      = 3;                            // front heart's point sits this far below the axis
y_b      = y_p - dip - lever_inset*sqrt(2); // body heart point
r_hole_l = pin_d/2 + pin_clr_lever;
rh       = r_hole_l + hub_wall;          // hub radius
crest    = tongue_t + tooth_h;
z_p      = crest + open_gap + rh;        // hinge axis z
R_cam    = z_p - crest + preload;        // cam radius to tip
z_front  = z_p + rh;                     // front face of lever
xc       = lever_half + side_clr;        // cheek inner face
y_wide   = y_p + cheek_r + 0.6;          // where lever widens past cheeks
cheek_w  = 4.5;                          // cheek width
tab_hw   = xc + cheek_w;                  // half-width of the hinge bar
tab_y0   = y_p - cheek_r - 2.4;           // top edge of the jaw (strap goes in here)
cam_dir  = [-sin(overcenter), -cos(overcenter)];   // in (y,z)

// ---------------- 2D helpers ----------------------------------------
module heart_up(w) {                     // classic heart, point at origin
    ss = w / (1 + sqrt(2)/2);
    rotate(45) union() {
        square(ss);
        translate([ss/2, ss]) circle(d = ss, $fn = 128);
        translate([ss, ss/2]) circle(d = ss, $fn = 128);
    }
}
// heart in the modelling frame: lobes at y=0, point at y=H
module heart2d(w) { translate([0, y_b]) heart_up(w); }

// teardrop hole along X; tip toward +z (up=1) or -z (up=-1)
module teardrop_x(r, len, up = 1) {
    rotate([0, 90, 0]) linear_extrude(height = len, center = true)
        rotate(up > 0 ? 180 : 0) union() {
            circle(r);
            rotate(45) square(r);
        }
}

module yz_extrude(len) {
    rotate([90, 0, 90]) linear_extrude(height = len, center = true) children();
}

// prism of a 2D shape with a soft stepped 45-deg top edge
module soft_prism(h, c = round_c, steps = 5) {
    linear_extrude(height = h - c) children();
    for (i = [0 : steps - 1])
        translate([0, 0, h - c + i * c/steps])
            linear_extrude(height = c/steps + 0.001)
                offset(delta = -(i+1) * c/steps) children();
}

// ---------------- BODY -----------------------------------------------
// hinge bar under the heart's point that carries the jaw
module tab2d() {
    translate([-tab_hw, tab_y0]) offset(r = 3) offset(delta = -3)
        square([2 * tab_hw, y_p + cheek_r + 2 - tab_y0]);
}
module outline2d() { union() { heart2d(heart_w); tab2d(); } }

ring_r  = ring_hole/2 + ring_wall;
ring_cy = y_b + H + 1.3;                  // ring hole sits just above the lobes

module ring2d() {
    difference() {
        hull() {
            translate([0, ring_cy]) circle(ring_r);
            translate([0, y_b + s*sqrt(2) - 2]) circle(3);
        }
        translate([0, ring_cy]) circle(d = ring_hole);
    }
}
module ring_hole_cut() { translate([0, ring_cy, -1]) cylinder(d = ring_hole, h = 20); }

module cheek_profile() {     // (y,z)
    hull() {
        translate([y_p, z_p]) circle(cheek_r);
        translate([y_p - cheek_r, 0]) square([2*cheek_r, 0.01]);
    }
}

module cheeks() {
    difference() {
        intersection() {
            linear_extrude(height = 50) offset(delta = -0.3) outline2d();
            yz_extrude(200) cheek_profile();
            union() {
                translate([ xc, -50, -1]) cube([100, 200, 100]);
                translate([-xc - 100, -50, -1]) cube([100, 200, 100]);
            }
        }
        translate([0, y_p, z_p]) teardrop_x(pin_d/2 + pin_clr_body, 200, 1);
    }
}

module teeth() {          // on the spring tongue
    pitch = 1.2;
    n = 6;
    yc = y_p + R_cam * cam_dir[0];          // where the cam tip lands
    for (i = [0 : n - 1])
        translate([0, yc + (i - (n-1)/2) * pitch, tongue_t - 0.01])
            yz_extrude(tongue_w)
                polygon([[-pitch/2, 0], [pitch/2, 0], [0, tooth_h]]);
}

// slot that frees the tongue + thinning so it flexes backward
module tongue_cut() {
    tw = tongue_w/2;
    // U-slot through the plate
    difference() {
        translate([-tw - tongue_slot, tab_y0 - 1, -1])
            cube([2*(tw + tongue_slot), tongue_top + tongue_slot - tab_y0 + 1, 10]);
        translate([-tw, tab_y0 - 2, -2]) cube([2*tw, tongue_top + tongue_slot - tab_y0 + 5, 12]);
    }
    // thin the tongue (front side) so it is springy
    translate([-tw - 0.01, tab_y0 - 1, tongue_t]) cube([2*tw + 0.02, tongue_top - tab_y0 + 1, 5]);
    // lead-in chamfer on the tongue tip so a thick edge can push its way in
    translate([0, tab_y0, tongue_t]) rotate([45, 0, 0]) cube([2*tw + 0.02, 2.5, 2.5], center = true);
}

module body() {
    difference() {
        union() {
            soft_prism(plate_t) outline2d();
            soft_prism(ring_t) ring2d();
            cheeks();
        }
        ring_hole_cut();
        tongue_cut();
    }
    teeth();
}

// ---------------- LEVER (modelled closed) ----------------------------
module lever_profile() {     // (y,z) hub barrel + cam lobe
    tip_c = [y_p, z_p] + (R_cam - 1) * cam_dir;
    hull() {
        translate([y_p, z_p]) circle(rh);
        translate(tip_c) circle(1);
    }
}

module lever_outline() {
    offset(r = 1) offset(delta = -1) offset(r = -lever_inset) heart2d(heart_w);
}

module lever() {
    c = round_c; steps = 5;
    difference() {
        union() {
            yz_extrude(2 * lever_half) lever_profile();
            translate([0, 0, z_front - lever_t])
                linear_extrude(height = lever_t) lever_outline();
            // heart point is welded onto the hub barrel
            intersection() {
                translate([0, 0, z_p]) linear_extrude(height = z_front - z_p) lever_outline();
                yz_extrude(2 * lever_half) translate([y_p, z_p]) circle(rh + 0.01);
            }
            // stop bump: lands on the back plate just past over-center
            for (sx = [-1, 1])   // land beside the tongue, on solid plate
                translate([sx * (tongue_w/2 + tongue_slot + 4), y_b + 0.62 * H, plate_t + 0.4])
                    cylinder(d1 = 3, d2 = 6, h = z_front - lever_t - plate_t - 0.4 + 0.01);
        }
        translate([0, y_p, z_p]) teardrop_x(r_hole_l, 100, -1);
        // comb teeth across the cam tip
        pitch = 1.6;
        for (x = [-lever_half + pitch/2 : pitch : lever_half])
            translate([x, y_p, z_p]) rotate([-overcenter, 0, 0])
                translate([0, 0, -R_cam]) rotate([0, 45, 0])
                    cube([0.85, 6, 0.85], center = true);
        // soft front edge (bed side when printing, 45 deg is fine)
        for (i = [0 : steps - 1])
            translate([0, 0, z_front - (i+1) * c/steps])
                linear_extrude(height = c/steps + 0.002) difference() {
                    square(300, center = true);
                    offset(delta = -(steps - i) * c/steps) lever_outline();
                    // keep the hub barrel round
                    translate([-lever_half - 1, y_p - rh - 1])
                        square([2*lever_half + 2, y_wide - y_p + rh + 1]);
                }
    }
}

module lever_rotated(a) {    // a = opening angle in degrees
    translate([0, y_p, z_p]) rotate([a, 0, 0]) translate([0, -y_p, -z_p]) lever();
}

// ---------------- PIN ------------------------------------------------
function pin_half_len() = tab_hw - 0.3;

module pin() {
    L = 2 * pin_half_len() - 0.6;
    intersection() {
        rotate([0, 90, 0]) cylinder(d = pin_d, h = L, center = true, $fn = 48);
        cube([L + 1, pin_d + 1, pin_d - 0.3], center = true);   // flats for printing
    }
}

// ---------------- outputs --------------------------------------------
module upright() { children(); }

module print_plate() {
    body();
    translate([heart_w + 4, 0, z_front]) mirror([0, 0, 1]) lever();
    translate([heart_w/2 + 2, -6, (pin_d - 0.3)/2]) pin();
}

if (PART == "assembly") upright() {
    color("hotpink") body();
    color("crimson") lever();
    color("silver") translate([0, y_p, z_p]) pin();
} else if (PART == "open") upright() {
    color("hotpink") body();
    color("crimson") lever_rotated(100);
    color("silver") translate([0, y_p, z_p]) pin();
} else if (PART == "body")  body();
else if (PART == "lever")   translate([0, 0, z_front]) mirror([0, 0, 1]) lever();
else if (PART == "pin")     translate([0, 0, (pin_d - 0.3)/2]) pin();
else                        print_plate();

echo(str("H=", H, " y_p=", y_p, " hinge z=", z_p, "  cam R=", R_cam,
         "  front z=", z_front, "  pin length=", 2*pin_half_len() - 0.6));
