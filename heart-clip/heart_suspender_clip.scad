// =====================================================================
//  Heart Clip  -  heart-shaped suspender-style locking clip
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
//   * JAW ARM - pivots on pin B. The heart's cam pushes its tail. The arm
//               and the heart move exactly the same at every wheel setting.
//   * BLADE   - the gripping jaw with barbed teeth; hangs on pin B between
//               the arm's cheeks.
//   * CAM     - shallow spiral on the dial shaft, in front of the blade.
//               It sets how far back the blade sits (0.3 - 5 mm trim) and
//               is self-locking: the blade's push can't turn it.
//   * WHEEL   - toothed thumbwheel on the dial shaft, at the right-hand
//               edge between the two hearts.
//   * HEART   - pivots on pin A behind the arm's tail; its cam locks past
//               dead-center. Opens by lifting the bottom edge (bevelled
//               underneath) or pressing the top backward.
//
//  Printed parts: BODY, HEART, ARM, BLADE, CAM, DIAL (shaft), WHEEL, 2x CLIP.
//  Bought: 2x steel dowel pin 3 x 25 mm.  Print FIT_TEST first.
//  PART = "assembly" | "open" | "plate" | "fit_test" | "body" | "heart"
//         | "arm" | "blade" | "cam" | "dial" | "wheel" | "clip"
//  Tuned for a Creality Ender 3 V3 SE printing PETG.
// =====================================================================

PART   = "plate";
GRIP   = 2.5;         // preview: trim thickness the wheel is set for (0.3 - 5 mm)
CAMROT = 0;           // (used only by the collision checks)

/* [Heart] */
heart_w     = 52;
heart_t     = 3.0;
heart_pt    = -18.5;
body_inset  = 1.5;
plate_t     = 2.6;
round_c     = 0.8;    // edge rounding / chamfer size

/* [Keychain ring] */
ring_hole   = 7;
ring_wall   = 3.2;
ring_t      = 2.6;    // same as the back plate, so the heart can slide down past it during assembly

/* [Jaw] */
tooth_h     = 1.0;    // big interlocking barbs: canvas is forced into a deep zigzag
tooth_p     = 2.0;    // tooth pitch
ridge_h     = 1.0;
preload     = 0.4;    // how deep the barbs interlock into the trim
grip_min    = 0.0;    // thinnest setting (with preload)
grip_max    = 5.2;    // thickest setting
blade_hw    = 5.9;    // blade half width (0.3 mm side gap: room for first-layer squish)
blade_t     = 2.8;    // stiff: carries the full clamping force
mouth_y     = -6.5;
bite_y      = -2;
y_B         = 13;
B_r         = 3.2;
cheek_in    = 6.2;
cheek_out   = 7.5;
tail_len    = 4.6;
tail_t_min  = 3.6;    // the bar the heart's cam presses: thick, it carries ~2x the clamp force

/* [Dial cam] */
y_K         = 6.5;    // cam shaft height (6.5 below B)
cam_rmin    = 3.0;    // leaves a solid wall around the 4 mm shaft
cam_sweep   = 300;    // degrees of spiral (shallow enough to self-lock; more would let its high end hit the blade at 5 mm)
shaft_r     = 2.0;    // 4 mm D-shaft: stiff enough for a firm grip
d_flat      = 0.4;    // depth of the D flat
wheel_r     = 4.0;    // gear wheel root radius (teeth reach wheel_r + 1.1)
wheel_teeth = 12;     // coarse teeth: flick one tooth = one click (easy with long nails)
wheel_x0    = 17.6;   // inner face of the wheel (hidden behind the front heart)
wheel_t     = 2.0;
clip_t      = 1.0;    // snap clips that hold the dial shaft in (no glue)
clip_or     = 3.3;
groove_r    = shaft_r - 0.5;

/* [Heart hinge + cam] */
y_A         = 21;
A_r         = 3.2;
open_lift   = 2.4;
overcenter  = 12;    // firm click: a snag can't flip the heart open
ear_in      = 7.9;
ear_out     = 9.6;
knuck_in    = 10.0;
knuck_out   = 13.5;   // hinge posts 3.5 mm thick
knuckle_r   = 3.4;

/* [Pins] */
pin_d       = 3.0;    // STEEL dowel pins, 3 x 25 mm (printed pins would bend)
pin_L       = 25;
// Tuned for Creality Ender 3 V3 SE + PETG (holes print a little small and
// PETG oozes). Print fit_test first and adjust if needed.
pin_clr_wall= 0.00;   // steel pins press into the body's hinge posts (no glue)
pin_clr_mov = 0.30;   // pins in parts that swing (free)
shaft_clr   = 0.25;   // dial shaft in the arm
bore_clr    = 0.20;   // dial shaft in the cam's D-bore

$fn = 64;

// ---------------- derived -------------------------------------------
s        = heart_w / (1 + sqrt(2)/2);
heart_H  = s * (3/(2*sqrt(2)) + 0.5);
heart_top= heart_pt + heart_H;
crest    = plate_t + tooth_h;
z_B      = plate_t + 0.3 + B_r;
z_A      = plate_t + 0.3 + A_r;
R_cam    = A_r + open_lift;
rest_ang = 2;                                 // heart rests on its stop tabs ~2 deg past flat
// tail sits exactly where the cam lobe rests when locked: no slack in the lock
tail_back= z_A + (R_cam - 1) * cos(overcenter + rest_ang) + 1;
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
// arm front face is flat and level with the top of the shaft boss, so the arm prints face-down
tail_t   = max(tail_t_min, z_K + shaft_r + 1.3 - tail_back);
heart_back = max(tail_back + tail_t + 0.4, z_K + cam_rmax + 0.35);   // room for the dial cam
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
// spiral rise per radian, and the small extra reach of a spiral pressing a
// flat face (its high point sits just past the normal): d + b^2 / 2d
cam_b    = cam_trav / (cam_sweep * PI / 180);
function d_eff(d)    = d + cam_b * cam_b / (2 * d);
function blade_beta(d) = beta_for(d_eff(d));
function rho_for(d)  = (-90 + blade_beta(d)) - (d - cam_rmin) / cam_trav * cam_sweep;

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
        rotate(up > 0 ? 90 : -90) td_base(r);   // tip points +z (up=1) or -z (up=-1)
}
module td_base(r) { union() { circle(r); rotate(45) square(r); } }   // tip toward +y
module td2d(r, ang) { rotate(ang - 90) td_base(r); }                  // 2D teardrop, tip at angle
module yz_extrude(len) {
    rotate([90, 0, 90]) linear_extrude(height = len, center = true) children();
}
module x_band(x0, x1) { translate([(x0 + x1)/2, 0, 0]) yz_extrude(x1 - x0) children(); }
// prism whose top edge is rounded (quarter circle, radius c) in fine slices,
// so it prints as a smooth round-over instead of visible steps
module soft_prism(h, c = round_c, steps = 8, bc = 0.4) {
    // small 45 deg chamfer on the bed edge hides first-layer squish
    for (i = [0 : 3])
        translate([0, 0, i * bc / 4]) linear_extrude(height = bc / 4 + 0.001) offset(delta = -(bc - i * bc / 4)) children();
    translate([0, 0, bc]) linear_extrude(height = h - c - bc) children();
    for (i = [0 : steps - 1])
        translate([0, 0, h - c + c * sin(90 * i / steps)])
            linear_extrude(height = c * (sin(90 * (i + 1) / steps) - sin(90 * i / steps)) + 0.001)
                offset(delta = -c * (1 - cos(90 * (i + 1) / steps))) children();
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
                translate([y_K - shaft_r - 1.3, tail_back + tail_t - 0.01]) square([y_A - 4 - y_K + shaft_r + 1.3, 0.01]);
            }
            hull() { translate([y_B, z_B]) circle(B_r); translate([y_A - 4, tail_back]) square([2, tail_t]); }
            translate([y_A - 4, tail_back]) square([tail_len, tail_t]);
        }
        // arm prints face-down, so these holes' tips point to -z
        translate([y_B, z_B]) td2d(r_mov, -90);
        translate([y_K, z_K]) td2d(shaft_r + shaft_clr, -90);
    }
}
module arm() {
    for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) x_band(cheek_in, cheek_out) arm_cheek2d();
    // tail bridge across the full width (above the blade hub)
    x_band(-cheek_out, cheek_out) translate([y_A - 4, tail_back]) square([tail_len, tail_t]);
    // thick bosses outside the cheeks around the pin and dial shaft: stiffen
    // the arm and centre it between the hinge posts (0.4 mm gap each side)
    for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) x_band(cheek_out - 0.01, knuck_in - 0.4) difference() {
        intersection() {
            hull() {   // reaches the arm's flat front face, so it prints face-down
                translate([y_B, z_B]) circle(B_r);
                translate([y_K, z_K]) circle(shaft_r + 1.3);
                translate([y_K - shaft_r - 1.3, tail_back + tail_t - 0.01]) square([y_B + 2.6 - y_K + shaft_r + 1.3, 0.01]);
            }
            translate([-50, -50]) square([50 + y_B + 2.6, 100]);    // stays clear of the heart's ears
        }
        translate([y_B, z_B]) td2d(r_mov, -90);
        translate([y_K, z_K]) td2d(shaft_clr + shaft_r, -90);
    }
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
        // shallow spiral: friction holds it, so a pull can't turn it
        polygon(concat([for (a = [0 : 3 : cam_sweep]) cam_r(a) * [cos(a), sin(a)]],
                       [cam_rmin * [cos(359), sin(359)]]));
        // D-bore
        intersection() { circle(shaft_r + bore_clr); translate([-5, -5]) square([5 + shaft_r - d_flat + bore_clr, 10]); }
    }
}
module cam(rho) { translate([0, y_K, z_K]) rotate([rho, 0, 0]) yz_extrude(2 * blade_hw - 0.4) cam2d(); }
boss_out = knuck_in - 0.4;                     // outer face of the arm bosses
xL0 = -boss_out - 0.15;                        // left clip groove starts here
xL1 = xL0 - clip_t - 0.2;
xR0 = wheel_x0 + wheel_t + 0.05;               // right clip groove (outside the wheel)
xR1 = xR0 + clip_t + 0.2;
module xcyl(r, x0, x1) { translate([min(x0, x1), 0, 0]) rotate([0, 90, 0]) cylinder(r = r, h = abs(x1 - x0)); }
module dial_local() {   // axis along X at the origin; D-flat at y = shaft_r - d_flat
    intersection() {
        union() {
            xcyl(shaft_r, xL0, xR0);                     // main D-shaft
            xcyl(groove_r, xL1, xL0); xcyl(shaft_r, xL1 - 0.6, xL1);   // left groove + end
            xcyl(groove_r, xR0, xR1); xcyl(shaft_r, xR1, xR1 + 0.6);   // right groove + end
            xcyl(3.0, boss_out + 0.2, wheel_x0);         // collar: locates the shaft sideways
        }
        // the flat: keys into the cam and wheel, and lets the shaft print lying down
        translate([-30, -10, -10]) cube([60, 10 + shaft_r - d_flat, 20]);
    }
}
// snap clip (e-clip) for the shaft grooves: push it on sideways, it clicks
module clip2d() {
    difference() {
        circle(clip_or);
        circle(groove_r + 0.05);
        translate([0, -(groove_r - 0.25)]) square([clip_or + 1, 2 * (groove_r - 0.25)]);
    }
}
module clip_print() { linear_extrude(height = clip_t) clip2d(); }
module clips_local() {
    for (x0 = [xL1 + 0.1, xR0 + 0.1]) x_band(x0, x0 + clip_t) rotate(90) clip2d();
}
module dial(rho) { translate([0, y_K, z_K]) rotate([rho, 0, 0]) { dial_local(); wheel_local(); clips_local(); } }
// toothed thumbwheel: slides onto the shaft's D, held by a snap clip
module wheel2d() {
    difference() {
        union() {
            circle(wheel_r);
            for (i = [0 : wheel_teeth - 1]) rotate(i * 360 / wheel_teeth)
                hull() { translate([wheel_r - 0.5, -1.0]) square([0.5, 2.0]); translate([wheel_r + 1.1 - 0.5, 0]) circle(0.5); }
        }
        intersection() { circle(shaft_r + bore_clr); translate([-5, -5]) square([5 + shaft_r - d_flat + bore_clr, 10]); }
    }
}
module wheel_local() { x_band(wheel_x0, wheel_x0 + wheel_t) wheel2d(); }
module wheel_print() { linear_extrude(height = wheel_t) wheel2d(); }
// lying on its flat: layers run along the shaft (strong), no wobble on a bed-slinger
module dial_print() { translate([0, 0, shaft_r - d_flat]) rotate([-90, 0, 0]) dial_local(); }

// Fit test: print this first.
//  * block 1: 3 holes for the STEEL pin to press into (like the hinge posts):
//    -0.05 / 0.00 / +0.05 mm, and 3 holes it must turn freely in (like the
//    moving parts): +0.20 / +0.30 / +0.40 mm. Marked with 1-6 notches.
//  * block 2: D-holes for the printed 4 mm D-shaft (+0.1 / +0.2 / +0.3),
//    plus a short D-shaft piece and a snap clip to try.
fit_clr = [-0.05, 0.00, 0.05, 0.20, 0.30, 0.40];
module fit_test() {
    difference() {
        cube([52, 8, 8]);
        for (i = [0 : 5]) {
            translate([4.5 + i * 8.5, 4, 4]) rotate([0, 0, 90]) teardrop_x(pin_d/2 + fit_clr[i], 20, 1);
            for (k = [0 : i]) translate([4.5 + i * 8.5 - i * 0.6 + k * 1.2 - 0.3, -1, 7.4]) cube([0.6, 10, 1]);
        }
    }
    translate([0, 12, 0]) difference() {
        cube([32, 9, 6]);
        for (i = [0 : 2]) translate([5.5 + i * 10, 4.5, -1]) linear_extrude(height = 8)
            intersection() { circle(shaft_r + [0.1, 0.2, 0.3][i]); translate([-5, -5]) square([5 + shaft_r - d_flat + [0.1, 0.2, 0.3][i], 10]); }
        for (i = [0 : 2]) for (k = [0 : i]) translate([5.5 + i * 10 - i * 0.6 + k * 1.2 - 0.3, -1, 5.4]) cube([0.6, 1.5, 1]);
    }
    // short D-shaft piece with a clip groove (lying on its flat)
    translate([42, 16, shaft_r - d_flat]) rotate([-90, 0, 0]) intersection() {
        union() {
            xcyl(shaft_r, -7, 4); xcyl(groove_r, 4, 4 + clip_t + 0.2); xcyl(shaft_r, 4 + clip_t + 0.2, 7);
        }
        translate([-10, -10, -10]) cube([20, 10 + shaft_r - d_flat, 20]);
    }
    translate([42, 24, 0]) clip_print();
}

module cam_print() { linear_extrude(height = 2 * blade_hw - 0.4) cam2d(); }

// ---------------- FRONT HEART (pivot A, closed pose) -------------------
module heart() {
    c = round_c; steps = 8;
    difference() {
        union() {
            translate([0, 0, heart_back]) linear_extrude(height = heart_t) heart2d();
            yz_extrude(2 * ear_out) hull() {
                translate([y_A, z_A]) circle(A_r);
                translate([y_A, z_A] + (R_cam - 1) * cam_dir) circle(1);
            }
            for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) x_band(ear_in, ear_out) hull() {
                translate([y_A, z_A]) circle(A_r);
                translate([y_A - 5, heart_back]) square([11, 0.01]);   // deep where it meets the heart: strong against yanks
            }
            // hidden stop tabs on the ears: rest on the back plate when closed
            for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) x_band(ear_in, ear_out) hull() {
                translate([y_A, z_A]) circle(A_r);
                translate([y_A - 3.7, plate_t + 0.12]) square([1.7, 0.01]);   // close to the hinge: clears the spacer rings
            }
        }
        translate([0, y_A, z_A]) teardrop_x(r_mov, 100, -1);
        // 1 mm relief on the inside face over the grip cam and wheel: the
        // heart rests ~2 deg past flat, which tips this area towards them
        translate([0, 0, heart_back - 0.01]) linear_extrude(height = 1.01)
            intersection() {
                offset(delta = -2) heart2d();
                translate([-(wheel_x0 + wheel_t + clip_t + 1.5), y_K - wheel_r - 2.5]) square([2 * (wheel_x0 + wheel_t + clip_t + 1.5), wheel_r * 2 + 6]);
            }
        // bevel on the BACK edge of the lower half: a fingertip or nail
        // catches under it to lift the heart (not visible from the front)
        for (i = [0 : 14])
            translate([0, 0, heart_back + i * 0.1 - 0.01])
                linear_extrude(height = 0.1 + 0.01) difference() {
                    intersection() { square(300, center = true); translate([-150, -150]) square([300, 150 + y_B]); }
                    offset(delta = -(1.5 - i * 0.1)) heart2d();
                }
        for (i = [0 : steps - 1])
            translate([0, 0, heart_front - (i+1) * c/steps])
                linear_extrude(height = c/steps + 0.002) difference() {
                    square(300, center = true);
                    offset(delta = -(steps - i) * c/steps) heart2d();
                }
    }
}

// ---------------- PIN ----------------------------------------------------
// steel dowel pin (bought, not printed) - shown in previews only
module pin() { rotate([0, 90, 0]) cylinder(d = pin_d, h = pin_L, center = true, $fn = 48); }

// ---------------- poses / outputs -------------------------------------
module heart_at(a) { rot_about([y_A, z_A], a) heart(); }
// the whole jaw group (arm + blade + cam + dial) for a grip setting g and
// an extra opening angle (negative = open)
module jaw_group(g, open_a = 0) {
    d = d_for(g); b = blade_beta(d); r = rho_for(d);
    rot_about([y_B, z_B], open_a) {
        color("lightpink") arm();
        color("pink") rot_about([y_B, z_B], b) blade();
        color("silver") { cam(r); dial(r); }
    }
}

module print_plate() {
    body();
    translate([heart_w + 4, 0, heart_front]) mirror([0, 0, 1]) heart();
    // small parts to the left of the body
    translate([-heart_w/2 - 14, 0, tail_back + tail_t]) mirror([0, 0, 1]) arm();      // face down
    translate([-heart_w/2 - 18, -44, blade_hw]) rotate([0, 90, 0]) blade();          // on its side
    translate([-heart_w/2 - 14, -14, 0]) cam_print();                                 // flat
    translate([-heart_w/2 - 22, -58, 0]) dial_print();
    translate([-heart_w/2 - 60, -14, 0]) wheel_print();
    for (i = [0, 1]) translate([-heart_w/2 - 32 - i * 9, -14, 0]) clip_print();
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
else if (PART == "arm")         translate([0, 0, tail_back + tail_t]) mirror([0, 0, 1]) arm();   // face down
else if (PART == "arm_asm")     arm();
else if (PART == "blade")       translate([0, 0, blade_hw]) rotate([0, 90, 0]) blade();
else if (PART == "blade_asm")   rot_about([y_B, z_B], blade_beta(d_for(GRIP))) blade();
else if (PART == "cam")         cam_print();
else if (PART == "cam_asm")     cam(rho_for(d_for(GRIP)));
else if (PART == "dial")        dial_print();
else if (PART == "fit_test")    fit_test();
else if (PART == "pins_asm")    { translate([0, y_A, z_A]) pin(); translate([0, y_B, z_B]) pin(); }
else if (PART == "cam_rot")     cam(CAMROT);
else if (PART == "dial_rot")    dial(CAMROT);
else if (PART == "dial_asm")    dial(rho_for(d_for(GRIP)));
else if (PART == "shaft_asm")   translate([0, y_K, z_K]) rotate([rho_for(d_for(GRIP)), 0, 0]) dial_local();
else if (PART == "wheel")       wheel_print();
else if (PART == "clip")        clip_print();
else                            print_plate();

echo(str("spiral rise ", cam_b, " mm/rad; pressure angle at r_min: ", atan(cam_b / cam_rmin), " deg"));
echo(str("cam ", cam_rmin, "-", cam_rmax, " z_K=", z_K, " beta(thin)=", beta_for(d_for(grip_min)),
         " beta(thick)=", beta_for(d_for(grip_max)), " heart_back=", heart_back, " heart_front=", heart_front));
