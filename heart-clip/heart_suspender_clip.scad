// =====================================================================
//  Heart Suspender Clip  -  heart pacifier-clip style, hinge hidden,
//  with a thickness dial
// ---------------------------------------------------------------------
//  From the front you only see a heart with a keychain ring at the top.
//  Everything else sits behind it:
//
//        O         keychain ring -> clips to your bag
//      /\ /\
//     (  <3 )      front heart = locking lever (hinge hidden behind lobes)
//      \   /       back plate  = heart-shaped body with teeth
//       \ /        jaw mouth opens DOWNWARD between the two hearts;
//                  the flowstar trim clips in here and hangs below
//
//  Mechanism (side view): the front jaw pivots on the DIAL PIN (B). Below
//  B it is the gripping blade; above B it has a short tail. The front heart
//  pivots on pin A, behind that tail, and its cam pushes the tail forward,
//  which swings the blade back onto the teeth. Lift the heart's point out
//  and up to release; fold it flat and the cam locks past dead-center.
//
//  THICKNESS DIAL: the dial pin has an off-center middle. The little lever
//  on its end (on the right side, between the two hearts) clicks into 5
//  positions; each moves the jaw pivot, which shifts the jaw's gripping
//  edge by ~1.15 mm. Set it with the heart open:
//      1 (lever up)        0   - 0.6 mm  thin fabric
//      2                   0.6 - 1.7 mm  single canvas layer / hemmed edge
//      3 (lever forward)   1.7 - 2.9 mm
//      4                   2.9 - 4.0 mm  folded canvas
//      5 (lever down)      4.0 - 5.2 mm  folded canvas over a seam
//
//  Teeth on both jaws are one-way barbs (flat face down): the trim slides
//  in easily, and a pull digs the teeth in harder.
//
//  Printed parts: BODY, HEART, JAW, DIAL pin, CAP, PIN (for A)
//  PART = "assembly" | "open" | "body" | "heart" | "jaw" | "dial" | "cap"
//         | "pin" | "plate"
// =====================================================================

PART  = "plate";
DIAL  = 2;            // 0..4 = dial positions 1..5 (for previews)

/* [Heart] */
heart_w     = 52;
heart_t     = 3.0;
heart_pt    = -18.5;  // y of the heart's point
body_inset  = 1.5;
plate_t     = 2.6;
round_c     = 0.8;

/* [Keychain ring] */
ring_hole   = 7;
ring_wall   = 3.2;
ring_t      = 3.2;

/* [Jaw] */
tooth_h     = 0.7;
ridge_h     = 0.6;
preload     = 0.6;    // crest overlap at the tightest dial setting
jaw_hw      = 7.5;
jaw_t       = 2.5;
up_back     = 4.2;    // back face of the jaw's thick part (nominal)
blade_t     = 1.0;
blade_root  = 9;
mouth_y     = -6;
bite_y      = -2;
y_B         = 13;     // dial pin axis
z_P         = 7.1;
B_r         = 3.4;    // jaw hub radius
tail_len    = 4.6;

/* [Dial] */
ecc         = 0.75;   // eccentric offset of the dial pin
dial_ang    = [0, 60, 90, 120, 180];
ecc_r       = 1.75;   // eccentric section radius
shaft_r     = 2.45;   // dial pin radius in the right knuckle
end_r       = 1.2;    // dial pin radius in the left knuckle
arm_len     = 4.8;
det_r       = 3.3;    // detent radius

/* [Heart hinge + cam] */
y_A         = 21;
A_r         = 3.2;
open_lift   = 2.4;
overcenter  = 8;
ear_in      = 7.9;
ear_out     = 9.6;
knuck_in    = 10.0;
knuck_out   = 12.5;
knuckle_r   = 3.4;
knuckleB_r  = 4.0;

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
z_A      = plate_t + 0.3 + A_r;
R_cam    = A_r + open_lift;
tail_back= z_A + R_cam;
tail_front = tail_back + jaw_t;
heart_back = tail_front + 0.4;
heart_front= heart_back + heart_t;
cam_dir  = [-sin(overcenter), cos(overcenter)];
r_mov    = pin_d/2 + pin_clr_mov;
y_C      = y_A + R_cam * cam_dir[0];            // cam contact on the tail
lever_k  = (y_C - bite_y) / (y_C - y_B);       // mouth travel per pivot travel
g_mid    = ecc * lever_k - preload;            // crest gap at the middle setting
blade_bb = crest + g_mid + ridge_h;            // blade back plane (nominal)

function arm_dir(t) = [cos(t), sin(t)];        // (y,z)
function ecc_off(t) = ecc * [sin(t), -cos(t)]; // (y,z)

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
module x_band(x0, x1) {
    translate([(x0 + x1)/2, 0, 0]) yz_extrude(x1 - x0) children();
}
module soft_prism(h, c = round_c, steps = 4) {
    linear_extrude(height = h - c) children();
    for (i = [0 : steps - 1])
        translate([0, 0, h - c + i * c/steps])
            linear_extrude(height = c/steps + 0.001) offset(delta = -(i+1) * c/steps) children();
}
module at_yz(p) { translate([0, p[0], p[1]]) children(); }

// ---------------- BODY -------------------------------------------------
ring_cy = heart_top - 1.9 + ring_hole/2 + 1.0;
module ring2d() {
    hull() {
        translate([0, ring_cy]) circle(ring_hole/2 + ring_wall);
        translate([-5, y_A + A_r - 0.8]) square([10, 1]);
    }
}
module knuckle_pair(r_B) {
    hull() { translate([y_A, z_A]) circle(knuckle_r); translate([y_A - knuckle_r, 0]) square([2*knuckle_r, 0.01]); }
    hull() { translate([y_B, z_P]) circle(r_B); translate([y_B - r_B, 0]) square([2*r_B, 0.01]); }
}
module back_teeth() {
    pitch = 1.2;
    for (i = [0 : 5])
        translate([0, bite_y + (i - 2.5) * pitch, plate_t - 0.01])
            yz_extrude(2 * jaw_hw)       // barb: steep face down, ramp up
                polygon([[-pitch/2, 0], [-pitch/2 + 0.15, tooth_h], [pitch/2, 0]]);
}
module body() {
    difference() {
        union() {
            soft_prism(plate_t) offset(delta = -body_inset) heart2d();
            soft_prism(ring_t) ring2d();
            x_band(knuck_in, knuck_out) knuckle_pair(knuckleB_r);
            x_band(-knuck_out, -knuck_in) knuckle_pair(knuckleB_r);
            back_teeth();
        }
        translate([0, ring_cy, -1]) cylinder(d = ring_hole, h = 20);
        translate([0, y_A, z_A]) teardrop_x(pin_d/2 + pin_clr_wall, 100, 1);
        // dial pin: big hole on the right (dial side), small on the left
        translate([(knuck_in + knuck_out)/2, y_B, z_P]) teardrop_x(shaft_r + 0.15, knuck_out - knuck_in + 2, 1);
        translate([-(knuck_in + knuck_out)/2, y_B, z_P]) teardrop_x(end_r + 0.1, knuck_out - knuck_in + 2, 1);
        // detent dimples on the right knuckle's outer face
        for (t = dial_ang) at_yz([y_B, z_P] + det_r * arm_dir(t))
            translate([knuck_out, 0, 0]) sphere(r = 0.55, $fn = 24);
    }
}

// ---------------- FRONT JAW (drawn with its hub at [y_B, z_P]) -------
module jaw_profile() {
    bb = blade_bb;
    difference() {
        union() {
            translate([blade_root - 2, up_back]) square([y_B - blade_root + 2, jaw_t]);
            translate([y_B, z_P]) circle(B_r);
            hull() {
                translate([blade_root - 2, up_back]) square([2, jaw_t]);
                translate([blade_root - 4, bb]) square([2, blade_t]);
            }
            polygon([[mouth_y + 1.2, bb], [blade_root - 2, bb], [blade_root - 2, bb + blade_t],
                     [mouth_y, bb + blade_t], [mouth_y, bb + 0.9]]);
            for (i = [0 : 5])
                translate([bite_y + (i - 2.5) * 1.2 + 0.6, bb + 0.01])
                    polygon([[-0.6, 0], [-0.45, -ridge_h], [0.6, 0]]);   // barb
            hull() {
                translate([y_B, z_P]) circle(B_r);
                translate([y_A - 4, tail_back]) square([2, jaw_t]);
            }
            translate([y_A - 4, tail_back]) square([tail_len, jaw_t]);
        }
        translate([y_B, z_P]) circle(ecc_r + 0.25);
    }
}
module jaw() { yz_extrude(2 * jaw_hw) jaw_profile(); }

// jaw placed on the dial pin at setting t, tail resting on the cam
function jaw_dz(t)  = ecc_off(t)[1];
function jaw_psi(t) = -atan(jaw_dz(t) / (y_C - y_B));
module jaw_set(t, extra = 0) {
    o = ecc_off(t);
    hub = [y_B, z_P] + o;
    at_yz(hub) rotate([jaw_psi(t) + extra, 0, 0]) at_yz(-[y_B, z_P]) jaw();
}

// ---------------- DIAL PIN (assembly frame, setting t) ---------------
module dial(t) {
    o = ecc_off(t);
    // lever arm with detent bump, outside the right knuckle
    x_band(knuck_out + 0.2, knuck_out + 2.7) translate([y_B, z_P]) hull() {
        circle(shaft_r + 0.15);
        translate(arm_len * arm_dir(t)) circle(2.0);
    }
    at_yz([y_B, z_P] + det_r * arm_dir(t)) translate([knuck_out + 0.2, 0, 0]) sphere(r = 0.5, $fn = 24);
    // shaft in the right knuckle
    at_yz([y_B, z_P]) rotate([0, 90, 0]) translate([0, 0, knuck_in - 0.1])
        cylinder(r = shaft_r, h = knuck_out + 0.3 - knuck_in + 0.1);
    // eccentric in the jaw hub
    at_yz([y_B, z_P] + o) rotate([0, 90, 0]) translate([0, 0, -knuck_in + 0.1])
        cylinder(r = ecc_r, h = 2 * knuck_in - 0.1);
    // small end in the left knuckle, sticks out 1.5 mm for the cap
    at_yz([y_B, z_P]) rotate([0, 90, 0]) translate([0, 0, -knuck_out - 1.5])
        cylinder(r = end_r, h = knuck_out + 1.5 - knuck_in + 0.2);
}
module cap() {
    difference() {
        cylinder(d = 6, h = 1.6);
        translate([0, 0, 0.4]) cylinder(r = end_r + 0.02, h = 5);
    }
}

// ---------------- FRONT HEART (pivot A, closed pose) -------------------
module heart() {
    c = round_c; steps = 4;
    difference() {
        union() {
            translate([0, 0, heart_back]) linear_extrude(height = heart_t) heart2d();
            yz_extrude(2 * ear_out) hull() {
                translate([y_A, z_A]) circle(A_r);
                translate([y_A, z_A] + (R_cam - 1) * cam_dir) circle(1);
            }
            for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) x_band(ear_in, ear_out) hull() {
                translate([y_A, z_A]) circle(A_r);
                translate([y_A - 5, heart_back]) square([8, 0.01]);
            }
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

// ---------------- PIN A --------------------------------------------------
pin_L = 2 * knuck_out - 0.6;
module pin() {
    intersection() {
        rotate([0, 90, 0]) cylinder(d = pin_d, h = pin_L, center = true, $fn = 48);
        cube([pin_L + 1, pin_d + 1, pin_d - 0.3], center = true);
    }
}

// ---------------- poses / outputs -------------------------------------
module heart_at(a) { translate([0, y_A, z_A]) rotate([a, 0, 0]) translate([0, -y_A, -z_A]) heart(); }
// print poses
module dial_print() {   // standing up, lever flat on the bed
    translate([0, 0, knuck_out + 2.7]) rotate([0, 90, 0]) translate([0, -y_B, -z_P]) dial(90);
}
module jaw_print() { translate([0, 0, jaw_hw]) rotate([0, 90, 0]) jaw(); }

module print_plate() {
    body();
    translate([heart_w + 4, 0, heart_front]) mirror([0, 0, 1]) heart();
    translate([-heart_w/2 - 18, 6, 0]) jaw_print();
    translate([-heart_w/2 - 10, -24, 0]) dial_print();
    translate([-heart_w/2 - 2, -40, 0]) cap();
    translate([0, heart_pt - 6, (pin_d - 0.3)/2]) pin();
}

t_set = dial_ang[DIAL];
if (PART == "assembly") {
    color("hotpink") body(); color("lightpink") jaw_set(t_set); color("crimson") heart();
    color("silver") { translate([0, y_A, z_A]) pin(); dial(t_set); }
    color("silver") translate([-knuck_out - 1.6, y_B, z_P]) rotate([0, 90, 0]) cap();
} else if (PART == "open") {
    color("hotpink") body(); color("lightpink") jaw_set(t_set, -12); color("crimson") heart_at(-65);
    color("silver") { translate([0, y_A, z_A]) pin(); dial(t_set); }
} else if (PART == "body")      body();
else if (PART == "heart")       translate([0, 0, heart_front]) mirror([0, 0, 1]) heart();
else if (PART == "heart_asm")   heart();
else if (PART == "jaw")         jaw_print();
else if (PART == "jaw_asm")     jaw_set(t_set);
else if (PART == "dial")        dial_print();
else if (PART == "dial_asm")    dial(t_set);
else if (PART == "cap")         cap();
else if (PART == "pin")         translate([0, 0, (pin_d - 0.3)/2]) pin();
else                            print_plate();

echo(str("lever_k=", lever_k, " g_mid=", g_mid, " blade_bb=", blade_bb, " y_C=", y_C,
         " gaps per setting=", [for (t = dial_ang) g_mid + jaw_dz(t) * lever_k],
         " heart_back=", heart_back, " heart_front=", heart_front));
