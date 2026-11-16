// =====================================================================
//  Heart Suspender Clip  -  classic "heart pacifier clip" layout
// ---------------------------------------------------------------------
//  Hanging as used (Y up, Z toward the front):
//
//        O        keychain ring  -> clips to your bag
//     [=====]     jaw block with hinge knuckles on the sides
//      /\ /\
//     (  <3 )     heart = locking lever, hinged at its top edge
//      \   /
//       \ /       jaw mouth opens DOWNWARD behind the heart;
//                 the flowstar is clipped here and hangs below
//
//  Lift the heart up and over the top -> the cam on its hinge lets go of
//  the front jaw, which swings open. Push the flowstar's edge up into the
//  mouth, fold the heart back down: the cam rolls just past dead-center and
//  locks the front jaw onto the teeth.
//
//  Thickness: the front jaw comes in three sizes (swap it by pushing the
//  top pin out). Each covers a ~1.4 mm range because the jaw's lower blade
//  bends a little, like the steel plate in a metal clip.
//      JAW_SIZE 0 = 0 - 1.4 mm (fabric, straps)
//      JAW_SIZE 1 = 1.4 - 2.8 mm
//      JAW_SIZE 2 = 2.8 - 4.2 mm
//
//  Printed parts:  BODY, JAW, HEART, 2x PIN
//  PART = "assembly" | "open" | "body" | "jaw" | "heart" | "pin" | "plate"
// =====================================================================

PART     = "plate";
JAW_SIZE = 0;

/* [Size] */
heart_w     = 38;    // heart width
heart_t     = 3.0;   // heart thickness
block_w     = 27;    // jaw block width
block_h     = 35;    // jaw block height
plate_t     = 2.6;   // back plate thickness
round_c     = 0.8;   // soft edge size

/* [Keychain ring] */
ring_hole   = 7;
ring_wall   = 3.2;
ring_t      = 3.2;

/* [Jaw] */
tooth_h     = 0.6;   // back teeth height
ridge_h     = 0.4;   // front-jaw ridge height
preload     = 0.5;   // squeeze at the low end of each size
size_step   = 1.4;   // thickness step between jaw sizes
jaw_hw      = 10.2;  // half width of the front jaw (grip width / 2)
jaw_t       = 2.5;   // front jaw thickness at the cam
blade_t     = 1.1;   // lower blade thickness (bends ~1.4 mm at the tip)
blade_top   = 19.5;  // where the blade meets the thick part
y_B         = 30;    // front-jaw pivot height
B_r         = 3.2;

/* [Heart hinge + cam] */
y_A         = 22;    // heart pivot height
A_r         = 3.2;
open_lift   = 1.6;   // jaw swing at the cam when open (~x3 at the mouth)
overcenter  = 8;     // degrees the cam rests past dead-center
ear_hw      = 10.6;  // half width of heart hub / cam
ear_in      = 5.0;   // ears run from here out to ear_hw (hidden behind the lobes)
wall_in     = 11.0;  // inner face of the side knuckles
knuckle_r   = 3.4;

/* [Pins] */
pin_d       = 3.0;
pin_clr_wall= 0.15;
pin_clr_mov = 0.25;

$fn = 64;

// ---------------- derived -------------------------------------------
s        = heart_w / (1 + sqrt(2)/2);
heart_H  = s * (3/(2*sqrt(2)) + 0.5);
crest    = plate_t + tooth_h;                  // back teeth crest
jaw_back = crest - preload + ridge_h;          // front-jaw back plane (thin size)
jaw_front= jaw_back + jaw_t;
z_B      = plate_t + 0.3 + B_r;
z_A      = jaw_front + open_lift + A_r;
R_cam    = z_A - jaw_front;
heart_back  = z_A + A_r + 0.4;
heart_front = heart_back + heart_t;
heart_top   = y_A + 0.5;                  // lobes rise just past the hinge
heart_pt    = heart_top - heart_H;
cam_dir  = [sin(overcenter), -cos(overcenter)];
r_mov    = pin_d/2 + pin_clr_mov;
bite_y   = 4;

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
module soft_prism(h, c = round_c, steps = 4) {
    linear_extrude(height = h - c) children();
    for (i = [0 : steps - 1])
        translate([0, 0, h - c + i * c/steps])
            linear_extrude(height = c/steps + 0.001) offset(delta = -(i+1) * c/steps) children();
}
module rrect(x0, y0, w, h, r) { translate([x0, y0]) offset(r = r) offset(delta = -r) square([w, h]); }

// ---------------- BODY -------------------------------------------------
ring_cy = block_h + ring_hole/2 + 1.2;
module block2d() { rrect(-block_w/2, 0, block_w, block_h, 3); }
module ring2d() {
    hull() {
        translate([0, ring_cy]) circle(ring_hole/2 + ring_wall);
        translate([-6, block_h - 4]) square([12, 1]);
    }
}
module knuckles() {
    for (sx = [-1, 1])
        intersection() {
            translate([sx > 0 ? wall_in : -block_w/2, -1, -1]) cube([block_w/2 - wall_in, 100, 100]);
            yz_extrude(100) {      // two separate knuckles so the lobes can swing past
                hull() {
                    translate([y_A, z_A]) circle(knuckle_r);
                    translate([y_A - knuckle_r, 0]) square([2*knuckle_r, 0.01]);
                }
                hull() {
                    translate([y_B, z_B]) circle(knuckle_r);
                    translate([y_B - knuckle_r, 0]) square([2*knuckle_r, 0.01]);
                }
            }
        }
}
module back_teeth() {
    pitch = 1.2;
    for (i = [0 : 5])
        translate([0, bite_y + (i - 2.5) * pitch, plate_t - 0.01])
            yz_extrude(2 * jaw_hw) polygon([[-pitch/2, 0], [pitch/2, 0], [0, tooth_h]]);
}
module body() {
    difference() {
        union() {
            soft_prism(plate_t) block2d();
            soft_prism(ring_t) ring2d();
            knuckles();
            back_teeth();
        }
        translate([0, ring_cy, -1]) cylinder(d = ring_hole, h = 20);
        translate([0, y_A, z_A]) teardrop_x(pin_d/2 + pin_clr_wall, 100, 1);
        translate([0, y_B, z_B]) teardrop_x(pin_d/2 + pin_clr_wall, 100, 1);
    }
}

// ---------------- FRONT JAW (pivots at B, closed pose) ---------------
module jaw_profile(size) {   // (y,z)
    off = size * size_step;
    bb  = jaw_back + off;                    // blade back plane
    difference() {
        union() {
            // upper thick part: cam pushes here
            translate([blade_top - 2, jaw_back]) square([y_B - blade_top + 2, jaw_t]);
            hull() {
                translate([y_B, z_B]) circle(B_r);
                translate([y_B - 3, jaw_back]) square([3, jaw_t]);
            }
            // joggle down to the blade
            hull() {
                translate([blade_top - 2, jaw_back]) square([2, jaw_t]);
                translate([blade_top - 4, bb]) square([2, blade_t]);
            }
            // flexible blade with lead-in chamfer at the mouth
            polygon([[1.2, bb], [blade_top - 2, bb], [blade_top - 2, bb + blade_t],
                     [0, bb + blade_t], [0, bb + 1.0]]);
            // gripping ridges
            for (i = [0 : 5])
                translate([bite_y + (i - 2.5) * 1.2 + 0.6, bb + 0.01])
                    polygon([[-0.6, 0], [0.6, 0], [0, -ridge_h]]);
        }
        translate([y_B, z_B]) circle(r_mov);
    }
}
module jaw(size = JAW_SIZE) { yz_extrude(2 * jaw_hw) jaw_profile(size); }

// ---------------- HEART LEVER (closed pose) ----------------------------
module heart_outline() { heart2d(); }
module heart() {
    c = round_c; steps = 4;
    difference() {
        union() {
            translate([0, 0, heart_back]) linear_extrude(height = heart_t) heart_outline();
            yz_extrude(2 * ear_hw) {
                hull() {
                    translate([y_A, z_A]) circle(A_r);
                    translate([y_A, z_A] + (R_cam - 1) * cam_dir) circle(1);
                }
            }
            // two hidden ears join the hub to the back of the lobes
            for (sx = [-1, 1])
                translate([sx * (ear_in + ear_hw)/2, 0, 0])
                    yz_extrude(ear_hw - ear_in) hull() {
                        translate([y_A, z_A]) circle(A_r);
                        translate([y_A - 6, heart_back]) square([6 + heart_top - 0.8 - y_A, 0.01]);
                    }
            for (sx = [-1, 1])
                translate([sx * 12.3, 5, plate_t + 0.4])
                    cylinder(d1 = 2.4, d2 = 4.4, h = heart_back - plate_t - 0.4 + 0.01);
        }
        translate([0, y_A, z_A]) teardrop_x(r_mov, 100, -1);
        for (i = [0 : steps - 1])
            translate([0, 0, heart_front - (i+1) * c/steps])
                linear_extrude(height = c/steps + 0.002) difference() {
                    square(300, center = true);
                    offset(delta = -(steps - i) * c/steps) heart_outline();
                }
    }
}

// ---------------- PIN --------------------------------------------------
pin_L = block_w - 0.6;
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
    translate([block_w/2 + heart_w/2 + 4, 0, heart_front]) mirror([0, 0, 1]) heart();
    for (i = [0 : 2]) translate([-block_w/2 - 14 - i * 11, 0, 0]) jaw_print(i);
    for (i = [0, 1]) translate([0, -8 - i * 5, (pin_d - 0.3)/2]) pin();
}

if (PART == "assembly") {
    color("hotpink") body(); color("lightpink") jaw(); color("crimson") heart();
    color("silver") { translate([0, y_A, z_A]) pin(); translate([0, y_B, z_B]) pin(); }
} else if (PART == "open") {
    color("hotpink") body(); color("lightpink") jaw_at(-10); color("crimson") heart_at(-100);
    color("silver") { translate([0, y_A, z_A]) pin(); translate([0, y_B, z_B]) pin(); }
} else if (PART == "body")      body();
else if (PART == "jaw")         jaw_print(JAW_SIZE);
else if (PART == "jaw_asm")     jaw();
else if (PART == "heart")       translate([0, 0, heart_front]) mirror([0, 0, 1]) heart();
else if (PART == "heart_asm")   heart();
else if (PART == "pin")         translate([0, 0, (pin_d - 0.3)/2]) pin();
else                            print_plate();

echo(str("z_A=", z_A, " z_B=", z_B, " R_cam=", R_cam, " jaw_back=", jaw_back,
         " jaw_front=", jaw_front, " heart_back=", heart_back, " heart_front=", heart_front,
         " heart_pt=", heart_pt, " pin_L=", pin_L));
