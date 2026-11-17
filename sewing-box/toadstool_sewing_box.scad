// =====================================================================
//  Toadstool Sewing Box  — parametric, 3D-printable
//  Stem body ~330 W x 240 D x 290 H mm (13" x 9.5" x 11.4"); the spotted
//  cap lid brings it to ~370 mm tall.
//  Two stacks of lift-out trays with snap-on lids hang inside the top of
//  the stem; the deep bin underneath holds fabric, scissors, projects.
//
//  Render one printable part at a time:
//     openscad -D 'part="body_lower_left"' -o out.stl toadstool_sewing_box.scad
//  part = "assembly" | "exploded"
//       | "body_lower_left" | "body_lower_right"
//       | "body_upper_left" | "body_upper_right"
//       | "cap_front_left" | "cap_front_right" | "cap_back_left" | "cap_back_right"
//       | "tray_deep_grid" | "tray_deep_split"
//       | "tray_shallow_grid" | "tray_shallow_long" | "tray_lid"
// =====================================================================

part = "assembly";

/* ---------- stem (main box) ---------- */
W      = 330;    // outside width  (x)
D      = 240;    // outside front-to-back (y)
H      = 290;    // body height (z), without cap
R      = 40;     // corner radius (plan view)
WALL   = 4;      // wall thickness
FLOOR  = 4;      // floor thickness
TIER   = 165;    // body is printed in a lower and upper tier, split here (hidden by the ring)
SLEEVE = 8;      // how far the joining sleeve reaches into each tier

/* ---------- cap (lid) ---------- */
CAP_OVER = 18;   // how far the cap overhangs the stem (cap prints in 4 quarters)
CAP_H    = 95;   // dome height
CAP_P    = 2.3;  // dome "squareness" (2 = ellipse, higher = flatter top)
LIP_H    = 6;    // rim on top of the stem that keys into a groove under the cap
LIP_T    = 2;    // (it is the inner part of the stem wall, so no space is lost)
LID_CLR  = 0.3;

/* ---------- trays ---------- */
TW     = 153;    // tray body width  (x)
TD     = 208;    // tray body depth  (y)
TR     = 20;     // tray corner radius
TWALL  = 1.8;
TFLOOR = 1.6;
H_DEEP    = 60;  // lower tray in each stack (hangs on the ledge)
H_SHALLOW = 45;  // upper tray in each stack (sits on the lower tray's lid)
DIV_T  = 1.6;    // divider thickness
TX     = 80;     // tray centre offset from box centre (x)

/* ---------- snap-fit lid for trays ---------- */
TL_PLATE = 2.4;  // lid plate
SK_DEPTH = 7;    // skirt depth
SK_IN    = 0.8;  // skirt inner face offset from tray wall
SK_T     = 1.6;  // skirt thickness
BEAD     = 0.6;  // bead on tray wall (outward)
CATCH    = 0.25; // skirt catch reaches in to this offset -> 0.35 mm snap

/* ---------- lugs / ledge ---------- */
LUG_W   = 50;
LUG_OUT = 9.5;   // lug reaches this far past the tray end wall
LUG_T   = 6;
LUG_TOP = 8;     // lug top sits this far below tray rim
LEDGE   = 7;     // ledge width inside front & back walls
LEDGE_T = 4;

/* ---------- joinery ---------- */
PIN_D   = 2.0;   // holes for 1.75 mm filament "dowels"
PIN_L   = 6;     // depth each side -> cut 11 mm filament pieces

$fn = 64;

// ------------- derived stack heights -------------
// the lower tray's lugs rest on the ledge; the upper tray lid ends 2 mm below the cap
STACK_ABOVE_LEDGE = (LUG_TOP + LUG_T) + TL_PLATE + H_SHALLOW + TL_PLATE;
ZL = H - 2 - STACK_ABOVE_LEDGE;                    // ledge top height
Z_DEEP    = ZL - (H_DEEP - LUG_TOP - LUG_T);       // bottom of deep tray
Z_SHALLOW = Z_DEEP + H_DEEP + TL_PLATE;           // bottom of shallow tray
echo(str("Ledge top at z=", ZL, "  bin depth under trays=", Z_DEEP - FLOOR));

// =====================================================================
//  2D helpers
// =====================================================================
module rrect(w, d, r, o=0) offset(r=r+o) square([w-2*r, d-2*r], center=true);
module outline(o=0)   rrect(W, D, R, o);
module t_outline(o=0) rrect(TW, TD, TR, o);

module prism(z0, z1) translate([0,0,z0]) linear_extrude(z1-z0) children();
module slice(z) translate([0,0,z]) linear_extrude(0.01) children();

// =====================================================================
//  Cute details (2D, drawn in the plane of the wall they sit on)
// =====================================================================
module eye2d() difference() {
    scale([15, 19]) circle(1);
    translate([-5, 7]) circle(5.5);          // sparkle
    translate([5.5, -7]) circle(2.5);
}
module arc2d(r, t, a0, a1)
    for (a = [a0:6:a1-6]) hull() {
        translate(r*[cos(a), sin(a)]) circle(t/2, $fn=16);
        translate(r*[cos(a+6), sin(a+6)]) circle(t/2, $fn=16);
    }
module smile2d() arc2d(14, 3.6, 200, 340);
module blade2d(x, lean, h) hull() { translate([x - 4, 0]) square([8, 1]); translate([x + lean, h]) circle(1.6, $fn=16); }
module grass2d() { blade2d(-9, -10, 24); blade2d(0, 2, 34); blade2d(9, 11, 26); }
module baby_shroom2d(spots=true) {
    translate([-8, 0]) square([16, 34]);                      // stem
    translate([0, 30]) difference() {                        // cap
        scale([28, 20]) circle(1);
        translate([-40, -40]) square([80, 40]);
        if (spots) { translate([-11, 8]) circle(4); translate([6, 12]) circle(3.2); translate([16, 4]) circle(2.6); }
    }
}

// emboss a 2D (x,z) shape outward from the front face
module on_front(depth) translate([0, -D/2 + 0.01, 0]) rotate([90, 0, 0]) linear_extrude(depth) children();
// emboss a 2D (y,z) shape outward from the right / left side faces
module on_right(depth) translate([W/2 - 0.01, 0, 0]) rotate([90, 0, 90]) linear_extrude(depth) children();
module on_left(depth)  translate([-W/2 + 0.01, 0, 0]) rotate([90, 0, -90]) linear_extrude(depth) children();

module details() {
    // face just under the cap
    for (s = [-1, 1]) {
        on_front(1.8) translate([s*48, 246]) eye2d();
        on_front(0.8) translate([s*80, 222]) scale([1.6, 1]) circle(11);      // blush
    }
    on_front(1.6) translate([0, 238]) smile2d();
    // grass tufts along the base
    for (g = [[-95, 1], [-70, 0.8], [60, 0.9], [100, 1.1]]) on_front(2.0) translate([g[0], 0]) scale(g[1]) grass2d();
    // a baby toadstool on each side
    on_right(2.2) translate([20, 0]) baby_shroom2d();
    on_right(2.0) translate([-30, 0]) scale(0.8) grass2d();
    on_left(2.2)  translate([-15, 0]) scale(0.8) baby_shroom2d();
    on_left(2.0)  translate([30, 0]) grass2d();
}

// =====================================================================
//  Stem (body)
// =====================================================================
RING   = 16;       // mushroom "ring" band height (its top edge = tier seam)
RING_T = 3;
module ring() {
    hull() { slice(TIER - RING) outline(-0.5); slice(TIER - RING + RING_T) outline(RING_T); }
    prism(TIER - RING + RING_T, TIER - 0.05) outline(RING_T);
}

module ledge() {
    for (s = [-1, 1]) intersection() {
        prism(0, H) outline(-WALL + 0.01);
        mirror([0, s < 0 ? 1 : 0, 0]) hull() {
            translate([-W/2, D/2 - WALL - LEDGE, ZL - LEDGE_T]) cube([W, LEDGE + WALL, LEDGE_T]);
            translate([-W/2, D/2 - WALL - 0.01, ZL - LEDGE_T - LEDGE]) cube([W, WALL, 0.01]);   // 45° gusset
        }
    }
}

module body_full(with_details=true) {
    if (with_details) body_details();
    difference() {
        prism(0, H) outline();
        prism(FLOOR, H + 1) outline(-WALL);
    }
    // key rim on top (inner 2 mm of the wall, sticks up into the cap groove)
    difference() { prism(H - 0.01, H + LIP_H) outline(-WALL + LIP_T); prism(H - 1, H + LIP_H + 1) outline(-WALL); }
    ledge();
    ring();
}
module body_details() intersection() { details(); translate([-W, -D, 0]) cube([2*W, 2*D, H]); }

module sleeve(x_side) intersection() {
    union() {
        difference() { prism(TIER - SLEEVE, TIER)              outline(-WALL + 0.01); prism(TIER - SLEEVE - 1, TIER + 1)   outline(-WALL - 2); }
        difference() { prism(TIER - 0.01, TIER + SLEEVE - 0.5) outline(-WALL - 0.25); prism(TIER - 1, TIER + SLEEVE + 1)   outline(-WALL - 2); }
    }
    half_box(x_side, -1, H + 10);
}

module half_box(x_side, z0, z1) translate([x_side < 0 ? -W : 0, -D, z0]) cube([W, 2*D, z1 - z0]);

module pin_holes(pts_yz) for (p = pts_yz)
    translate([0, p[0], p[1]]) rotate([0, 90, 0]) cylinder(d=PIN_D, h=2*PIN_L, center=true, $fn=16);

FRONT_Y = -(D/2 - WALL/2);
module body_piece(x_side, tier) {
    z0 = tier == 0 ? -1 : TIER;
    z1 = tier == 0 ? TIER : H + LIP_H + 10;
    zs = tier == 0 ? [20, 60, 100, 140] : [TIER + 20, TIER + 55, TIER + 100, H - 12];
    difference() {
        union() {
            intersection() { body_full(); half_box(x_side, z0, z1); }
            if (tier == 0) sleeve(x_side);
        }
        pin_holes([for (z = zs) [FRONT_Y, z]]);
        pin_holes([for (z = zs) [-FRONT_Y, z]]);
        if (tier == 0) pin_holes([for (y = [-85, -30, 30, 85]) [y, FLOOR/2]]);
        if (tier == 1) pin_holes([for (y = [-1, 1]) [y*(D/2 - WALL - LEDGE/2), ZL - LEDGE_T/2]]);
    }
}

// =====================================================================
//  Cap (lid): solid spotted dome, prints right-side up with no supports
// =====================================================================
CAP_STEPS = 16;
function cap_s(t) = pow(1 - pow(t, CAP_P), 1/CAP_P);    // plan scale at height fraction t

module dome(grow=0) hull() {
    slice(H) outline(CAP_OVER - 2);                          // small bevel underneath
    for (k = [0:CAP_STEPS]) {
        t = min(k / CAP_STEPS, 0.995);
        s = cap_s(t);
        sx = s * (W/2 + CAP_OVER + grow) / (W/2 + CAP_OVER);
        sy = s * (D/2 + CAP_OVER + grow) / (D/2 + CAP_OVER);
        translate([0, 0, H + 2 + t*(CAP_H - 2 + grow)]) linear_extrude(0.01) scale([sx, sy]) outline(CAP_OVER);
    }
}

// spots: [x, y, radius] in plan view; they are raised 1.6 mm and follow the dome
SPOTS = [[0, 5, 30], [-100, -40, 22], [105, -30, 24], [-75, 75, 17], [80, 78, 19],
         [-30, -100, 16], [45, -112, 13], [-140, 30, 15], [150, 40, 14],
         [-160, -95, 11], [160, -95, 12], [10, 112, 12]];
SPOT_C = [0, 0, H - 80];          // spots are projected out from this point
function spot_z(x, y) = let(rho = max(abs(x) / (W/2 + CAP_OVER), abs(y) / (D/2 + CAP_OVER)))
                        H + 2 + (CAP_H - 2) * pow(1 - pow(min(rho, 0.99), CAP_P), 1/CAP_P);
module spot_rays() for (sp = SPOTS) {
    v = [sp[0], sp[1], spot_z(sp[0], sp[1])] - SPOT_C;
    translate(SPOT_C) rotate([0, acos(v[2]/norm(v)), atan2(v[1], v[0])])
        cylinder(r=sp[2], h=norm(v) + 40);
}
module spots() intersection() { dome(1.6); spot_rays(); }

module cap_groove() difference() {
    prism(H - 1, H + LIP_H + 0.5) outline(-WALL + LIP_T + LID_CLR);
    prism(H - 2, H + LIP_H + 2) outline(-WALL - LID_CLR);
}
module cap_full(with_spots=true) difference() {
    union() { dome(); if (with_spots) spots(); }
    cap_groove();
}
module quarter_box(x_side, y_side)
    translate([x_side < 0 ? -W : 0, y_side < 0 ? -D : 0, H - 1]) cube([W, D, CAP_H + 20]);
module pin_holes_y(pts_xz) for (p = pts_xz)
    translate([p[0], 0, p[1]]) rotate([90, 0, 0]) cylinder(d=PIN_D, h=2*PIN_L, center=true, $fn=16);
module cap_piece(x_side, y_side) difference() {
    intersection() { cap_full(); quarter_box(x_side, y_side); }
    pin_holes([for (y = [-115, -60, -20, 20, 60, 115]) [y, H + 12]]);
    pin_holes([for (y = [-70, -25, 25, 70]) [y, H + 45]]);
    pin_holes_y([for (x = [-160, -110, -60, -20, 20, 60, 110, 160]) [x, H + 12]]);
    pin_holes_y([for (x = [-110, -50, 50, 110]) [x, H + 45]]);
}

// =====================================================================
//  Trays + snap lid
// =====================================================================
module bead(h) {          // raised snap bead around the outside of the tray rim
    hull() { slice(h - 5.4) t_outline(0); slice(h - 4.7) t_outline(BEAD); }
    hull() { slice(h - 4.7) t_outline(BEAD); slice(h - 4.0) t_outline(0); }
}
module lug(h) for (s = [-1, 1]) mirror([0, s < 0 ? 1 : 0, 0]) hull() {
    translate([-LUG_W/2, TD/2 - 1, h - LUG_TOP - LUG_T]) cube([LUG_W, LUG_OUT + 1, LUG_T]);
    translate([-LUG_W/2, TD/2 - 1, h - LUG_TOP - LUG_T - 4]) cube([LUG_W, 1, 0.01]);   // small 45° root
}
module dividers(h, nx, ny) intersection() {
    prism(0, h - 1) t_outline(-TWALL + 0.01);
    union() {
        iw = TW - 2*TWALL; id = TD - 2*TWALL;
        for (i = [1:1:nx-1]) translate([-iw/2 + i*iw/nx - DIV_T/2, -TD/2, 0]) cube([DIV_T, TD, h - 1]);
        for (j = [1:1:ny-1]) translate([-TW/2, -id/2 + j*id/ny - DIV_T/2, 0]) cube([TW, DIV_T, h - 1]);
    }
}
module tray(h, nx, ny) {
    difference() {
        prism(0, h) t_outline();
        prism(TFLOOR, h + 1) t_outline(-TWALL);
    }
    bead(h);
    lug(h);
    dividers(h, nx, ny);
}

module tray_lid(h=0) {   // modelled in place on a tray of height h
    difference() {
        union() {
            prism(h, h + TL_PLATE) t_outline(SK_IN + SK_T);
            prism(h - SK_DEPTH, h) t_outline(SK_IN + SK_T);
            translate([-10, TD/2, h - SK_DEPTH]) cube([20, 8, 2]);       // pry tab over one lug
        }
        prism(h - 5.6, h + 0.01) t_outline(SK_IN);
        hull() { slice(h - SK_DEPTH - 0.01) t_outline(SK_IN); slice(h - SK_DEPTH + 0.55) t_outline(CATCH); }
        hull() { slice(h - SK_DEPTH + 0.55) t_outline(CATCH); slice(h - SK_DEPTH + 0.85) t_outline(CATCH); }
        hull() { slice(h - SK_DEPTH + 0.85) t_outline(CATCH); slice(h - 5.6 + 0.01) t_outline(SK_IN); }
        // debossed little toadstool on top
        translate([0, 0, h + TL_PLATE - 0.8]) linear_extrude(1) translate([0, -20]) baby_shroom2d(false);
    }
}

// =====================================================================
//  Assembly / part selection
// =====================================================================
C_STEM = "#f6ecd8"; C_DETAIL = "#6b4a3a"; C_CAP = "#d9453b"; C_SPOT = "#fffaf0";
C_TRAY = ["#f4a7b9", "#a7d8f4", "#c9e6a1", "#fde59a"];

module tray_set(explode=0) {
    for (s = [-1, 1]) {
        translate([s*TX, 0, Z_DEEP + explode*1.0]) {
            color(C_TRAY[s < 0 ? 0 : 1]) tray(H_DEEP, s < 0 ? 3 : 1, s < 0 ? 4 : 2);
            color("white") translate([0, 0, explode*0.3]) tray_lid(H_DEEP);
        }
        translate([s*TX, 0, Z_SHALLOW + explode*1.7]) {
            color(C_TRAY[s < 0 ? 2 : 3]) tray(H_SHALLOW, s < 0 ? 2 : 3, s < 0 ? 3 : 1);
            color("white") translate([0, 0, explode*0.3]) tray_lid(H_SHALLOW);
        }
    }
}
module whole_cap() { color(C_CAP) cap_full(false); color(C_SPOT) difference() { spots(); cap_groove(); } }
module whole_body() { color(C_STEM) body_full(false); color(C_DETAIL) body_details(); }

if (part == "assembly") { whole_body(); tray_set(); whole_cap(); }
else if (part == "exploded") { whole_body(); tray_set(80); translate([0, 0, 260]) whole_cap(); }
else if (part == "body_lower_left")  body_piece(-1, 0);
else if (part == "body_lower_right") body_piece( 1, 0);
else if (part == "body_upper_left")  translate([0, 0, -TIER]) body_piece(-1, 1);
else if (part == "body_upper_right") translate([0, 0, -TIER]) body_piece( 1, 1);
// cap halves print right-side up, flat underside on the bed
else if (part == "cap_front_left")  translate([0, 0, -H]) cap_piece(-1, -1);
else if (part == "cap_front_right") translate([0, 0, -H]) cap_piece( 1, -1);
else if (part == "cap_back_left")   translate([0, 0, -H]) cap_piece(-1,  1);
else if (part == "cap_back_right")  translate([0, 0, -H]) cap_piece( 1,  1);
else if (part == "tray_deep_grid")    tray(H_DEEP, 3, 4);
else if (part == "tray_deep_split")   tray(H_DEEP, 1, 2);
else if (part == "tray_shallow_grid") tray(H_SHALLOW, 2, 3);
else if (part == "tray_shallow_long") tray(H_SHALLOW, 3, 1);
// tray lid flipped: top on the bed
else if (part == "tray_lid") translate([0, 0, TL_PLATE]) rotate([180, 0, 0]) tray_lid(0);
