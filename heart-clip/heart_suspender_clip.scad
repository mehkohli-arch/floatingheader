// =====================================================================
//  Heart Suspender Clip  -  heart pacifier-clip style, hinge hidden
// ---------------------------------------------------------------------
//  From the front you only see a heart with a keychain ring at the top.
//  Everything else sits behind it:
//
//        O         keychain ring -> clips to your bag
//      /\ /\
//     (  <3 )      front heart = locking lever (hinge hidden behind lobes)
//      \   /       back plate  = heart-shaped body with teeth
//       \ /        jaw mouth opens DOWNWARD between the two hearts;
//                  the flowstar clips in here and hangs below
//
//  Mechanism (side view): the front jaw pivots on pin B. Below B it is the
//  gripping blade; above B it has a short tail. The front heart pivots on
//  pin A, which sits behind that tail, and its cam pushes the tail forward,
//  which swings the blade back onto the teeth. Lift the heart's point out
//  and up: the cam lets go, and the jaw mouth opens about 5 mm. Fold the
//  heart flat: the cam rolls past dead-center and locks.
//
//  Thickness: swap the front jaw (push pin B out). Each size covers 1 mm,
//  and the blade bends a little like the steel in a metal clip:
//      JAW_SIZE 0 = 0-1 mm   1 = 1-2 mm   2 = 2-3 mm
//      JAW_SIZE 3 = 3-4 mm   4 = 4-5 mm   5 = 5-6 mm (e.g. folded fabric)
//
//  Teeth on both jaws are one-way barbs: the flat face points DOWN, so the
//  flowstar slides in easily but a pull digs the teeth in harder.
//
//  Printed parts: BODY, HEART, JAW, 2x PIN
//  PART = "assembly" | "open" | "body" | "jaw" | "heart" | "pin" | "plate"
// =====================================================================

PART     = "plate";
JAW_SIZE = 0;

/* [Heart] */
heart_w     = 52;
heart_t     = 3.0;
heart_pt    = -18.5;  // y of the heart's point
body_inset  = 1.5;    // back plate is this much smaller than the front heart
plate_t     = 2.6;
round_c     = 0.8;

/* [Keychain ring] */
ring_hole   = 7;
ring_wall   = 3.2;
ring_t      = 3.2;

/* [Jaw] */
tooth_h     = 0.7;
ridge_h     = 0.6;
preload     = 0.6;
size_step   = 1.0;
jaw_hw      = 7.5;    // grip width / 2
jaw_t       = 2.5;
blade_t     = 1.0;
blade_root  = 9;      // blade bends below this
mouth_y     = -6;     // bottom of the jaw
bite_y      = -2;     // centre of the teeth
y_B         = 13;     // jaw pivot
B_r         = 3.2;
tail_len    = 4.6;    // tail plate length (ends just above the cam)

/* [Heart hinge + cam] */
y_A         = 21;     // heart pivot (behind the lobes)
A_r         = 3.2;
open_lift   = 2.4;    // tail travel when the cam lets go
overcenter  = 8;
ear_in      = 7.9;
ear_out     = 9.6;
knuck_in    = 10.0;
knuck_out   = 12.5;
knuckle_r   = 3.4;

/* [Pins] */
pin_d       = 3.0;
pin_clr_wall= 0.15;
pin_clr_mov = 0.25;

$fn = 64;

// ---------------- derived -------------------------------------------
s        = heart_w / (1 + sqrt(2)/2);
heart_H  = s * (3/(2*sqrt(2)) + 0.5);
heart_top= heart_pt + heart_H;
cleft_y  = heart_pt + s * sqrt(2);
crest    = plate_t + tooth_h;
jaw_back = crest - preload + ridge_h;
jaw_front= jaw_back + jaw_t;
z_B      = plate_t + 0.3 + B_r;
z_A      = plate_t + 0.3 + A_r;
R_cam    = A_r + open_lift;
tail_back= z_A + R_cam;
tail_front = tail_back + jaw_t;
heart_back = tail_front + 0.4;
heart_front= heart_back + heart_t;
cam_dir  = [-sin(overcenter), cos(overcenter)];   // (y,z): toward the front, past center
r_mov    = pin_d/2 + pin_clr_mov;

// ---------------- helpers --------------------------------------------
module heart_up(w) {
    ss = w / (1 + sqrt(2)/2);
    rotate(45) union() {
        square(ss);
        translate([ss/2, ss]) circle(d = ss, $fn = 128);
        translate([ss, ss/2]) circle(d = ss, $fn = 128);
    }
}
module heart2d() { translate([0, heart_pt]) heart_up(heart_w); }
module teardrop_x(r, len, up = 1) {
    rotate([0, 90, 0]) linear_extrude(height = len, center = true)
        rotate(up > 0 ? 180 : 0) union() { circle(r); rotate(45) square(r); }
}
module yz_extrude(len) {
    rotate([90, 0, 90]) linear_extrude(height = len, center = true) children();
}
module x_band(x0, x1) {   // children extruded along X between x0..x1
    translate([(x0 + x1)/2, 0, 0]) yz_extrude(x1 - x0) children();
}
module soft_prism(h, c = round_c, steps = 4) {
    linear_extrude(height = h - c) children();
    for (i = [0 : steps - 1])
        translate([0, 0, h - c + i * c/steps])
            linear_extrude(height = c/steps + 0.001) offset(delta = -(i+1) * c/steps) children();
}

// ---------------- BODY -------------------------------------------------
ring_cy = heart_top - 1.9 + ring_hole/2 + 1.0;
module ring2d() {
    hull() {
        translate([0, ring_cy]) circle(ring_hole/2 + ring_wall);
        translate([-5, y_A + A_r - 0.8]) square([10, 1]);
    }
}
module knuckles() {
    for (sx = [-1, 1])
        mirror([sx < 0 ? 1 : 0, 0, 0]) x_band(knuck_in, knuck_out) {
            hull() { translate([y_A, z_A]) circle(knuckle_r); translate([y_A - knuckle_r, 0]) square([2*knuckle_r, 0.01]); }
            hull() { translate([y_B, z_B]) circle(knuckle_r); translate([y_B - knuckle_r, 0]) square([2*knuckle_r, 0.01]); }
        }
}
module back_teeth() {
    pitch = 1.2;
    for (i = [0 : 5])
        translate([0, bite_y + (i - 2.5) * pitch, plate_t - 0.01])
            yz_extrude(2 * jaw_hw)   // barb: steep face down, ramp up
                polygon([[-pitch/2, 0], [-pitch/2 + 0.15, tooth_h], [pitch/2, 0]]);
}
module body() {
    difference() {
        union() {
            soft_prism(plate_t) offset(delta = -body_inset) heart2d();
            soft_prism(ring_t) ring2d();
            knuckles();
            back_teeth();
        }
        translate([0, ring_cy, -1]) cylinder(d = ring_hole, h = 20);
        translate([0, y_A, z_A]) teardrop_x(pin_d/2 + pin_clr_wall, 100, 1);
        translate([0, y_B, z_B]) teardrop_x(pin_d/2 + pin_clr_wall, 100, 1);
    }
}

// ---------------- FRONT JAW (pivot B, closed pose) --------------------
module jaw_profile(size) {   // (y,z)
    bb = jaw_back + size * size_step;
    difference() {
        union() {
            // thick section from the blade root up to the hub
            translate([blade_root - 2, jaw_back]) square([y_B - blade_root + 2, jaw_t]);
            translate([y_B, z_B]) circle(B_r);
            // joggle + blade (lead-in chamfer at the mouth)
            hull() {
                translate([blade_root - 2, jaw_back]) square([2, jaw_t]);
                translate([blade_root - 4, bb]) square([2, blade_t]);
            }
            polygon([[mouth_y + 1.2, bb], [blade_root - 2, bb], [blade_root - 2, bb + blade_t],
                     [mouth_y, bb + blade_t], [mouth_y, bb + 0.9]]);
            for (i = [0 : 5])
                translate([bite_y + (i - 2.5) * 1.2 + 0.6, bb + 0.01])
                    polygon([[-0.6, 0], [-0.45, -ridge_h], [0.6, 0]]);   // barb
            // web from hub up to the tail, and the tail the cam pushes on
            hull() {
                translate([y_B, z_B]) circle(B_r);
                translate([y_A - 4, tail_back]) square([2, jaw_t]);
            }
            translate([y_A - 4, tail_back]) square([tail_len, jaw_t]);
        }
        translate([y_B, z_B]) circle(r_mov);
    }
}
module jaw(size = JAW_SIZE) { yz_extrude(2 * jaw_hw) jaw_profile(size); }

// ---------------- FRONT HEART (pivot A, closed pose) -------------------
module heart() {
    c = round_c; steps = 4;
    difference() {
        union() {
            translate([0, 0, heart_back]) linear_extrude(height = heart_t) heart2d();
            // hub + cam behind the jaw tail
            yz_extrude(2 * ear_out) hull() {
                translate([y_A, z_A]) circle(A_r);
                translate([y_A, z_A] + (R_cam - 1) * cam_dir) circle(1);
            }
            // ears beside the jaw, joining hub to the heart (hidden by the lobes)
            for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) x_band(ear_in, ear_out) hull() {
                translate([y_A, z_A]) circle(A_r);
                translate([y_A - 5, heart_back]) square([8, 0.01]);
            }
            // stop bumps beside the jaw
            for (sx = [-1, 1])
                translate([sx * 12, 2, plate_t + 0.4])
                    cylinder(d1 = 2.4, d2 = 4.4, h = heart_back - plate_t - 0.4 + 0.01);
        }
        translate([0, y_A, z_A]) teardrop_x(r_mov, 100, -1);
        for (i = [0 : steps - 1])
            translate([0, 0, heart_front - (i+1) * c/steps])
                linear_extrude(height = c/steps + 0.002) difference() {
                    square(300, center = true);
                    offset(delta = -(steps - i) * c/steps) heart2d();
                }
    }
}

// ---------------- PIN --------------------------------------------------
pin_L = 2 * knuck_out - 0.6;
module pin() {
    intersection() {
        rotate([0, 90, 0]) cylinder(d = pin_d, h = pin_L, center = true, $fn = 48);
        cube([pin_L + 1, pin_d + 1, pin_d - 0.3], center = true);
    }
}

// ---------------- poses / outputs -------------------------------------
module heart_at(a) { translate([0, y_A, z_A]) rotate([a, 0, 0]) translate([0, -y_A, -z_A]) heart(); }
module jaw_at(a)   { translate([0, y_B, z_B]) rotate([a, 0, 0]) translate([0, -y_B, -z_B]) jaw(); }
module jaw_print(size) { translate([0, 0, jaw_hw]) rotate([0, 90, 0]) jaw(size); }

module print_plate() {
    body();
    translate([heart_w + 4, 0, heart_front]) mirror([0, 0, 1]) heart();
    for (i = [0 : 5]) translate([-heart_w/2 - 18 - (i % 3) * 15, i < 3 ? 6 : -32, 0]) jaw_print(i);
    for (i = [0, 1]) translate([0, heart_pt - 6 - i * 5, (pin_d - 0.3)/2]) pin();
}

if (PART == "assembly") {
    color("hotpink") body(); color("lightpink") jaw(); color("crimson") heart();
    color("silver") { translate([0, y_A, z_A]) pin(); translate([0, y_B, z_B]) pin(); }
} else if (PART == "open") {
    color("hotpink") body(); color("lightpink") jaw_at(-15); color("crimson") heart_at(-65);
    color("silver") { translate([0, y_A, z_A]) pin(); translate([0, y_B, z_B]) pin(); }
} else if (PART == "body")      body();
else if (PART == "jaw")         jaw_print(JAW_SIZE);
else if (PART == "jaw_asm")     jaw();
else if (PART == "heart")       translate([0, 0, heart_front]) mirror([0, 0, 1]) heart();
else if (PART == "heart_asm")   heart();
else if (PART == "pin")         translate([0, 0, (pin_d - 0.3)/2]) pin();
else                            print_plate();

echo(str("z_A=", z_A, " z_B=", z_B, " R_cam=", R_cam, " jaw_back=", jaw_back,
         " tail_back=", tail_back, " heart_back=", heart_back, " heart_front=", heart_front,
         " heart_top=", heart_top, " cleft=", cleft_y, " ring_cy=", ring_cy));
