// =====================================================================
//  Heart Suspender Clip  (lever / locking-tab style, no screw)
// ---------------------------------------------------------------------
//  Three printed parts:
//    1. BODY  - heart back plate, strap loop, hinge cheeks, gripping teeth
//    2. LEVER - heart-shaped locking tab with an over-center toothed cam
//    3. PIN   - hinge pin (or use a 3 mm steel rod / cut nail)
//
//  How it works: flip the heart tab up and the cam swings away, opening a
//  ~3 mm gap. Slide the fabric in from the point of the heart, press the tab
//  down. The cam rolls just past dead-center and clamps the fabric against
//  the teeth. Pulling on the fabric pulls the cam tighter, not open.
//
//  Coordinates (assembled): X = width, Y = up the heart (point at y=0),
//  Z = out of the back plate toward the front.
//
//  PART = "assembly" | "open" | "body" | "lever" | "pin" | "plate"
// =====================================================================

PART = "plate";

/* [Size] */
heart_w      = 44;    // overall width of the body heart (mm)
plate_t      = 2.5;   // back plate thickness
lever_inset  = 2.5;   // how much smaller the front heart is than the body
lever_t      = 3.5;   // lever heart thickness

/* [Strap loop] */
strap_w      = 20;    // strap / webbing width that goes through the loop
strap_gap    = 4.5;   // slot height (strap thickness + slack)
loop_bar     = 3.0;   // loop bar width
loop_t       = 3.0;   // loop thickness

/* [Hinge + cam] */
pin_d        = 3.0;   // hinge pin diameter
pin_clr_body = 0.15;  // pin clearance in cheeks (snug)
pin_clr_lever= 0.25;  // pin clearance in lever (free spin)
hub_wall     = 2.0;   // lever wall around pin
cheek_r      = 4.0;   // cheek knuckle radius around the pin
lever_half   = 11.5;  // half-width of lever neck = grip width / 2
side_clr     = 0.4;   // gap between lever neck and cheeks
tooth_h      = 0.6;   // body tooth height
grip_gap     = 0.6;   // cam-tip to tooth-crest gap when closed
open_gap     = 3.0;   // fabric gap with lever open
overcenter   = 10;    // degrees the cam rests past dead-center

$fn = 64;

// ---------------- derived -------------------------------------------
s        = heart_w / (1 + sqrt(2)/2);    // heart base square side
heart_top= s * (3/(2*sqrt(2)) + 0.5);
cleft_y  = s * sqrt(2);
y_p      = 0.775 * s;                    // hinge axis height
r_hole_l = pin_d/2 + pin_clr_lever;
rh       = r_hole_l + hub_wall;          // hub radius
crest    = plate_t + tooth_h;
z_p      = crest + open_gap + rh;        // hinge axis z
R_cam    = z_p - crest - grip_gap;       // cam radius to tip
z_front  = z_p + rh;                     // front face of lever
xc       = lever_half + side_clr;        // cheek inner face
y_wide   = y_p + cheek_r + 0.6;          // where lever widens past cheeks
cam_dir  = [-sin(overcenter), -cos(overcenter)];   // in (y,z)

// ---------------- 2D helpers ----------------------------------------
module heart2d(w) {
    ss = w / (1 + sqrt(2)/2);
    rotate(45) union() {
        square(ss);
        translate([ss/2, ss]) circle(d = ss, $fn = 128);
        translate([ss, ss/2]) circle(d = ss, $fn = 128);
    }
}

// teardrop hole in the YZ plane, extruded along X; tip points to +z (up=1)
// or -z (up=-1) so horizontal holes print without support
module teardrop_x(r, len, up = 1) {
    rotate([0, 90, 0]) linear_extrude(height = len, center = true)
        rotate(up > 0 ? 180 : 0) union() {
            circle(r);
            rotate(45) square(r);
        }
}

// solid of a 2D (y,z) profile extruded along X
module yz_extrude(len) {
    rotate([90, 0, 90]) linear_extrude(height = len, center = true) children();
}

// heart prism with stepped 45-deg chamfer on the top edge
module chamfered_heart(w, h, c = 0.6, steps = 3) {
    linear_extrude(height = h - c) heart2d(w);
    for (i = [0 : steps - 1])
        translate([0, 0, h - c + i * c/steps])
            linear_extrude(height = c/steps) offset(delta = -(i+1) * c/steps) heart2d(w);
}

// ---------------- BODY -----------------------------------------------
module strap_loop() {
    iw = strap_w + 1;
    ow = iw + 2*loop_bar;
    y0 = cleft_y - 1.5;                     // overlaps the heart cleft
    slot_y = heart_top + 0.6;
    oh = slot_y + strap_gap + loop_bar - y0;
    linear_extrude(height = loop_t) difference() {
        translate([-ow/2, y0]) offset(r = 1.5) offset(delta = -1.5) square([ow, oh]);
        translate([-iw/2, slot_y]) offset(r = 1) offset(delta = -1) square([iw, strap_gap]);
    }
}

module cheek_profile() {     // (y,z)
    hull() {
        translate([y_p, z_p]) circle(cheek_r);
        translate([y_p - cheek_r, 0]) square([2*cheek_r, 0.01]);
    }
}

module cheeks() {
    difference() {
        intersection() {
            linear_extrude(height = 50) heart2d(heart_w);
            yz_extrude(200) cheek_profile();
            union() {
                translate([ xc, -50, -1]) cube([100, 200, 100]);
                translate([-xc - 100, -50, -1]) cube([100, 200, 100]);
            }
        }
        translate([0, y_p, z_p]) teardrop_x(pin_d/2 + pin_clr_body, 200, 1);
    }
}

module teeth() {
    pitch = 1.2;
    n = 7;
    yc = y_p + R_cam * cam_dir[0];          // where the cam tip lands
    intersection() {
        for (i = [0 : n - 1])
            translate([0, yc + (i - (n-1)/2) * pitch, plate_t - 0.01])
                yz_extrude(2 * xc - 0.4)
                    polygon([[-pitch/2, 0], [pitch/2, 0], [0, tooth_h]]);
        linear_extrude(height = 10) heart2d(heart_w);
    }
}

module body() {
    union() {
        chamfered_heart(heart_w, plate_t);
        strap_loop();
        cheeks();
        teeth();
    }
}

// ---------------- LEVER (modelled in closed position) ----------------
module lever_profile() {     // (y,z) hub + cam lobe + neck
    tip_c = [y_p, z_p] + (R_cam - 1) * cam_dir;
    hull() {
        translate([y_p, z_p]) circle(rh);
        translate(tip_c) circle(1);
    }
    hull() {
        translate([y_p, z_p]) circle(rh);
        translate([y_p, z_front - lever_t]) square([y_wide + 2 - y_p, lever_t]);
    }
}

module lever() {
    difference() {
        union() {
            // narrow neck with hub and cam
            yz_extrude(2 * lever_half) lever_profile();
            // heart tab
            translate([0, 0, z_front - lever_t])
                linear_extrude(height = lever_t)
                    intersection() {
                        offset(r = -lever_inset) heart2d(heart_w);
                        translate([-50, y_wide]) square([100, 100]);
                    }
            // stop bump: lands on the back plate just past over-center
            for (sx = [-1, 1])
                translate([sx * s * 0.32, cleft_y - 4.5, plate_t + 0.4])
                    cylinder(d1 = 3, d2 = 6, h = z_front - lever_t - plate_t - 0.4 + 0.01);
        }
        // pin hole (tip toward -z = up when printed face-down)
        translate([0, y_p, z_p]) teardrop_x(r_hole_l, 100, -1);
        // comb teeth across the cam tip
        pitch = 1.6;
        for (x = [-lever_half + pitch/2 : pitch : lever_half])
            translate([x, y_p, z_p]) rotate([-overcenter, 0, 0])
                translate([0, 0, -R_cam]) rotate([0, 45, 0])
                    cube([0.85, 6, 0.85], center = true);
        // small chamfer on front edge (bed side when printing)
        translate([0, 0, z_front - 0.4])
            linear_extrude(height = 1) difference() {
                square(200, center = true);
                offset(delta = -0.4) offset(r = -lever_inset) heart2d(heart_w);
            }
    }
}

module lever_rotated(a) {    // a = opening angle in degrees
    translate([0, y_p, z_p]) rotate([a, 0, 0]) translate([0, -y_p, -z_p]) lever();
}

// ---------------- PIN ------------------------------------------------
module pin() {
    // span between cheek outer faces at hinge height, minus a hair
    L = 2 * pin_half_len() - 0.4;
    intersection() {
        rotate([0, 90, 0]) cylinder(d = pin_d, h = L, center = true, $fn = 48);
        cube([L + 1, pin_d + 1, pin_d - 0.3], center = true);   // flats for printing
    }
}
// heart half-width at the hinge height (lobe circle region)
function pin_half_len() =
    let(cx = s/(2*sqrt(2)), cy = 3*s/(2*sqrt(2)), r = s/2,
        dy = y_p - cy)
    (abs(dy) < r) ? cx + sqrt(r*r - dy*dy) : y_p;

// ---------------- outputs --------------------------------------------
module print_plate() {
    body();
    // lever face-down beside the body
    translate([heart_w + 4, 0, z_front]) mirror([0, 0, 1]) lever();
    translate([heart_w/2 + 2, -8, (pin_d - 0.3)/2]) pin();
}

if (PART == "assembly") {
    color("hotpink") body();
    color("crimson") lever();
    color("silver") translate([0, y_p, z_p]) pin();
} else if (PART == "open") {
    color("hotpink") body();
    color("crimson") lever_rotated(100);
    color("silver") translate([0, y_p, z_p]) pin();
} else if (PART == "body")  body();
else if (PART == "lever")   translate([0, 0, z_front]) mirror([0, 0, 1]) lever();
else if (PART == "pin")     translate([0, 0, (pin_d - 0.3)/2]) pin();
else                        print_plate();

echo(str("hinge z=", z_p, "  cam R=", R_cam, "  front z=", z_front,
         "  heart top=", heart_top, "  pin length=", 2*pin_half_len() - 0.4));
