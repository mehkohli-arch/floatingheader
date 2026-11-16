// =====================================================================
//  Heart Suspender Clip  -  heart pacifier-clip style, hinge hidden,
//  with a thickness dial that is independent of opening/closing
// ---------------------------------------------------------------------
//  From the front you only see a heart with a keychain ring at the top.
//
//        O         keychain ring -> clips to your bag
//      /\ /\
//     (  <3 )      front heart = locking lever (hinge hidden behind lobes)
//      \   /       back plate  = heart-shaped body with barbed teeth
//       \ /        jaw mouth opens DOWNWARD between the two hearts;
//                  the flowstar trim clips in here and hangs below
//
//  Mechanism (side view), all hidden behind the front heart:
//   * JAW ARM  - pivots on pin B. Its tail (above B) is what the heart's
//                cam pushes. This part and the heart behave exactly the
//                same at every dial setting, so opening/closing never
//                changes.
//   * BLADE    - the gripping jaw with barbed teeth. It hangs on the same
//                pin B, between the arm's two cheeks.
//   * DIAL CAM - a spiral cam on a little shaft through the arm's cheeks,
//                sitting in front of the blade. Turning its lever sets how
//                far back the blade sits (0.6 - 5 mm grip). The spiral is
//                shallow, so the blade's push can't turn it (self-locking).
//   * HEART    - pivots on pin A behind the arm's tail; its cam locks
//                past dead-center.
//
//  Printed parts: BODY, HEART, ARM, BLADE, CAM, DIAL (shaft + lever), CAP,
//                 2x PIN
//  PART = "assembly" | "open" | "body" | "heart" | "arm" | "blade" | "cam"
//         | "dial" | "cap" | "pin" | "plate"
// =====================================================================

PART   = "plate";
GRIP   = 2.0;         // preview: trim thickness the dial is set for (0.6 - 5)

/* [Heart] */
heart_w     = 52;
heart_t     = 3.0;
heart_pt    = -18.5;
body_inset  = 1.5;
plate_t     = 2.6;
round_c     = 0.8;

/* [Keychain ring] */
ring_hole   = 7;
ring_wall   = 3.2;
ring_t      = 3.2;

/* [Jaw] */
tooth_h     = 1.0;    // big interlocking barbs: canvas is forced into a deep zigzag
tooth_p     = 2.0;    // tooth pitch
ridge_h     = 1.0;
preload     = 1.0;    // how deep the barbs interlock into the trim
grip_min    = 0.0;    // thinnest setting (with preload)
grip_max    = 5.2;    // thickest setting
blade_hw    = 6.0;    // blade half width (grip width 12 mm)
blade_t     = 1.8;
mouth_y     = -6.5;
bite_y      = -2;
y_B         = 13;
B_r         = 3.2;
cheek_in    = 6.2;
cheek_out   = 7.5;
tail_len    = 4.6;

/* [Dial cam] */
y_K         = 6.5;    // cam shaft height (6.5 below B)
cam_rmin    = 2.0;
cam_sweep   = 300;    // degrees of spiral
shaft_r     = 1.5;
lever_len   = 4.5;

/* [Heart hinge + cam] */
y_A         = 21;
A_r         = 3.2;
open_lift   = 2.4;
overcenter  = 12;    // firm click: a snag can't flip the heart open
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
crest    = plate_t + tooth_h;
z_B      = plate_t + 0.3 + B_r;
z_A      = plate_t + 0.3 + A_r;
R_cam    = A_r + open_lift;
tail_back= z_A + R_cam;
cam_dir  = [-sin(overcenter), cos(overcenter)];
r_mov    = pin_d/2 + pin_clr_mov;

// blade reference pose (beta = 0) = thinnest setting
bl_back  = crest - preload + ridge_h;          // blade back plane
bl_front = bl_back + blade_t;
arm_L    = y_B - bite_y;                       // B to teeth
tilt_k   = 1.35;                              // blade tilts, so the top teeth move less
cam_trav = tilt_k * grip_max * (y_B - y_K) / arm_L;
cam_rmax = cam_rmin + cam_trav;
z_K      = bl_front + cam_rmax;                // cam axis
heart_back = max(tail_back + 2.9, z_K + cam_rmax + 0.35);   // room for the dial cam
heart_front= heart_back + heart_t;
// blade angle for a cam radius d (rotation about B, negative = forward)
c0       = bl_front - z_B;
KBy      = y_K - y_B;  KBz = z_K - z_B;
KR       = sqrt(KBy*KBy + KBz*KBz);
Kphi     = atan2(KBz, -KBy);
function beta_for(d) = asin((d + c0) / KR) - Kphi;
// cam radius needed for a trim thickness g (closed)
function d_for(g)    = cam_rmax - tilt_k * g * (y_B - y_K) / arm_L;
function cam_r(phi)  = cam_rmin + cam_trav * phi / cam_sweep;
// dial rotation for a cam radius d: contact direction is ~straight back
function rho_for(d)  = (-90 + beta_for(d)) - (d - cam_rmin) / cam_trav * cam_sweep;

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
module x_band(x0, x1) { translate([(x0 + x1)/2, 0, 0]) yz_extrude(x1 - x0) children(); }
module soft_prism(h, c = round_c, steps = 4) {
    linear_extrude(height = h - c) children();
    for (i = [0 : steps - 1])
        translate([0, 0, h - c + i * c/steps])
            linear_extrude(height = c/steps + 0.001) offset(delta = -(i+1) * c/steps) children();
}
module rot_about(p, a) { translate([0, p[0], p[1]]) rotate([a, 0, 0]) translate([0, -p[0], -p[1]]) children(); }

// ---------------- BODY -------------------------------------------------
ring_cy = heart_top - 1.9 + ring_hole/2 + 1.0;
module ring2d() {
    hull() {
        translate([0, ring_cy]) circle(ring_hole/2 + ring_wall);
        translate([-5, y_A + A_r - 0.8]) square([10, 1]);
    }
}
module knuckle_pair() {
    hull() { translate([y_A, z_A]) circle(knuckle_r); translate([y_A - knuckle_r, 0]) square([2*knuckle_r, 0.01]); }
    hull() { translate([y_B, z_B]) circle(knuckle_r); translate([y_B - knuckle_r, 0]) square([2*knuckle_r, 0.01]); }
}
module back_teeth() {
    for (i = [0 : 4])
        translate([0, bite_y + (i - 2) * tooth_p, plate_t - 0.01])
            yz_extrude(2 * blade_hw)     // barb: steep face down, ramp up
                polygon([[-tooth_p/2, 0], [-tooth_p/2 + 0.25, tooth_h], [tooth_p/2, 0]]);
}
module body() {
    difference() {
        union() {
            soft_prism(plate_t) offset(delta = -body_inset) heart2d();
            soft_prism(ring_t) ring2d();
            x_band(knuck_in, knuck_out) knuckle_pair();
            x_band(-knuck_out, -knuck_in) knuckle_pair();
            back_teeth();
        }
        translate([0, ring_cy, -1]) cylinder(d = ring_hole, h = 20);
        translate([0, y_A, z_A]) teardrop_x(pin_d/2 + pin_clr_wall, 100, 1);
        translate([0, y_B, z_B]) teardrop_x(pin_d/2 + pin_clr_wall, 100, 1);
    }
}

// ---------------- JAW ARM (closed pose) ---------------------------------
module arm_cheek2d() {
    difference() {
        union() {
            hull() {   // flat front edge so the arm prints face-down
                translate([y_B, z_B]) circle(B_r);
                translate([y_K, z_K]) circle(shaft_r + 1.3);
                translate([y_K, tail_back + 2.5 - 0.01]) square([y_A - 4 - y_K, 0.01]);
            }
            hull() { translate([y_B, z_B]) circle(B_r); translate([y_A - 4, tail_back]) square([2, 2.5]); }
            translate([y_A - 4, tail_back]) square([tail_len, 2.5]);
        }
        translate([y_B, z_B]) circle(r_mov);
        translate([y_K, z_K]) circle(shaft_r + 0.15);
    }
}
module arm() {
    for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) x_band(cheek_in, cheek_out) arm_cheek2d();
    // tail bridge across the full width (above the blade hub)
    x_band(-cheek_out, cheek_out) translate([y_A - 4, tail_back]) square([tail_len, 2.5]);
}

// ---------------- BLADE (reference pose = thinnest) ---------------------
module blade2d() {
    difference() {
        union() {
            translate([y_B, z_B]) circle(B_r - 0.4);
            hull() {
                translate([y_B, z_B]) circle(B_r - 0.4);
                translate([y_K + 2.5, bl_back]) square([1, blade_t]);
            }
            polygon([[mouth_y + 1.2, bl_back], [y_K + 3, bl_back], [y_K + 3, bl_front],
                     [mouth_y, bl_front], [mouth_y, bl_back + 0.9]]);
            for (i = [0 : 4])     // barbs sit between the body's teeth
                translate([bite_y + (i - 2) * tooth_p + tooth_p/2, bl_back + 0.01])
                    polygon([[-tooth_p/2, 0], [-tooth_p/2 + 0.25, -ridge_h], [tooth_p/2, 0]]);
        }
        translate([y_B, z_B]) circle(r_mov);
    }
}
module blade() { yz_extrude(2 * blade_hw) blade2d(); }

// ---------------- DIAL CAM + SHAFT --------------------------------------
module cam2d() {
    difference() {
        polygon([for (a = [0 : 5 : cam_sweep]) cam_r(a) * [cos(a), sin(a)],
                 cam_rmin * [cos(359), sin(359)]]);
        // D-bore
        intersection() { circle(shaft_r + 0.12); translate([-5, -5]) square([5 + shaft_r - 0.25 + 0.12, 10]); }
    }
}
module cam(rho) { translate([0, y_K, z_K]) rotate([rho, 0, 0]) yz_extrude(2 * blade_hw - 0.4) cam2d(); }
module dial(rho) {
    translate([0, y_K, z_K]) rotate([rho, 0, 0]) {
        // D-shaft through both cheeks, out 1.5 mm on the left for the cap
        intersection() {
            rotate([0, 90, 0]) translate([0, 0, -cheek_out - 1.5]) cylinder(r = shaft_r, h = 2 * cheek_out + 1.5 + 0.2);
            translate([-30, -5, -5]) cube([60, 5 + shaft_r - 0.25, 10]);
        }
        // lever outside the right cheek
        x_band(cheek_out + 0.2, cheek_out + 2.0) hull() {
            circle(shaft_r + 0.9);
            translate(lever_len * [cos(150), sin(150)]) circle(1.4);
        }
    }
}
module cam_print() { linear_extrude(height = 2 * blade_hw - 0.4) cam2d(); }
module cap() {
    difference() {
        cylinder(d = 5, h = 1.6);
        translate([0, 0, 0.4]) cylinder(r = shaft_r + 0.02, h = 5);
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
            // hidden stop tabs on the ears: rest on the back plate when closed
            for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) x_band(ear_in, ear_out) hull() {
                translate([y_A, z_A]) circle(A_r);
                translate([y_A - 6, plate_t + 0.12]) square([2.5, 0.01]);
            }
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

// ---------------- PIN ----------------------------------------------------
pin_L = 2 * knuck_out - 0.6;
module pin() {
    intersection() {
        rotate([0, 90, 0]) cylinder(d = pin_d, h = pin_L, center = true, $fn = 48);
        cube([pin_L + 1, pin_d + 1, pin_d - 0.3], center = true);
    }
}

// ---------------- poses / outputs -------------------------------------
module heart_at(a) { rot_about([y_A, z_A], a) heart(); }
// the whole jaw group (arm + blade + cam + dial) for a grip setting g and
// an extra opening angle (negative = open)
module jaw_group(g, open_a = 0) {
    d = d_for(g); b = beta_for(d); r = rho_for(d);
    rot_about([y_B, z_B], open_a) {
        color("lightpink") arm();
        color("pink") rot_about([y_B, z_B], b) blade();
        color("silver") { cam(r); dial(r); translate([-cheek_out - 1.6, y_K, z_K]) rotate([0, 90, 0]) cap(); }
    }
}

module print_plate() {
    body();
    translate([heart_w + 4, 0, heart_front]) mirror([0, 0, 1]) heart();
    // small parts to the left of the body
    translate([-heart_w/2 - 12, 0, tail_back + 2.5]) mirror([0, 0, 1]) arm();          // face down
    translate([-heart_w/2 - 18, -44, blade_hw]) rotate([0, 90, 0]) blade();          // on its side
    translate([-heart_w/2 - 14, -14, 0]) cam_print();                                 // flat
    translate([-heart_w/2 - 24, -14, cheek_out + 2.0]) rotate([0, 90, 0]) translate([0, -y_K, -z_K]) dial(-60);
    translate([-heart_w/2 - 32, -14, 0]) cap();
    for (i = [0, 1]) translate([0, heart_pt - 6 - i * 5, (pin_d - 0.3)/2]) pin();
}

if (PART == "assembly") {
    color("hotpink") body(); jaw_group(GRIP); color("crimson") heart();
    color("silver") { translate([0, y_A, z_A]) pin(); translate([0, y_B, z_B]) pin(); }
} else if (PART == "open") {
    color("hotpink") body(); jaw_group(GRIP, -12); color("crimson") heart_at(-65);
    color("silver") { translate([0, y_A, z_A]) pin(); translate([0, y_B, z_B]) pin(); }
} else if (PART == "body")      body();
else if (PART == "heart")       translate([0, 0, heart_front]) mirror([0, 0, 1]) heart();
else if (PART == "heart_asm")   heart();
else if (PART == "arm")         translate([0, 0, tail_back + 2.5]) mirror([0, 0, 1]) arm();   // face down
else if (PART == "arm_asm")     arm();
else if (PART == "blade")       translate([0, 0, blade_hw]) rotate([0, 90, 0]) blade();
else if (PART == "blade_asm")   rot_about([y_B, z_B], beta_for(d_for(GRIP))) blade();
else if (PART == "cam")         cam_print();
else if (PART == "cam_asm")     cam(rho_for(d_for(GRIP)));
else if (PART == "dial")        translate([0, 0, cheek_out + 2.0]) rotate([0, 90, 0]) translate([0, -y_K, -z_K]) dial(-60);
else if (PART == "dial_asm")    dial(rho_for(d_for(GRIP)));
else if (PART == "cap")         cap();
else if (PART == "pin")         translate([0, 0, (pin_d - 0.3)/2]) pin();
else                            print_plate();

echo(str("cam ", cam_rmin, "-", cam_rmax, " z_K=", z_K, " beta(thin)=", beta_for(d_for(grip_min)),
         " beta(thick)=", beta_for(d_for(grip_max)), " heart_back=", heart_back, " heart_front=", heart_front));
