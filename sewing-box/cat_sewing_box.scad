// =====================================================================
//  "Loaf Cat" Sewing Box  — parametric, 3D-printable
//  ~330 W x 240 D x 290 H mm body (13" x 9.5" x 11.4"), ~355 mm to ear tips
//  Two stacks of lift-out trays with snap-on lids hang inside the top
//  of the box; the deep bin underneath holds fabric, scissors, projects.
//
//  Render one printable part at a time:
//     openscad -D 'part="body_lower_left"' -o out.stl cat_sewing_box.scad
//  part = "assembly" | "exploded"
//       | "body_lower_left" | "body_lower_right"
//       | "body_upper_left" | "body_upper_right"
//       | "lid_left" | "lid_right" | "ear_left" | "ear_right"
//       | "tray_deep_grid" | "tray_deep_split"
//       | "tray_shallow_grid" | "tray_shallow_long" | "tray_lid"
// =====================================================================

part = "assembly";

/* ---------- main box ---------- */
W      = 330;    // outside width  (x)
D      = 240;    // outside front-to-back (y)
H      = 290;    // body height (z), without lid
R      = 40;     // corner radius (plan view)
WALL   = 4;      // wall thickness
FLOOR  = 4;      // floor thickness
TIER   = 165;    // body is printed in a lower and upper tier, split here (hidden by the collar)
SLEEVE = 8;      // how far the joining sleeve reaches into each tier

/* ---------- lid ---------- */
LID_T   = 6;     // lid plate thickness
LIP_H   = 8;     // locating lip that drops into the box
LIP_T   = 2.4;
LID_CLR = 0.3;

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
// lower tray lug rests on the ledge; everything above it is computed so the
// upper tray lid clears the main-lid lip by 2 mm.
STACK_ABOVE_LEDGE = (LUG_TOP + LUG_T) + TL_PLATE + H_SHALLOW + TL_PLATE;
ZL = H - LIP_H - 2 - STACK_ABOVE_LEDGE;           // ledge top height
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
module eye2d() {
    difference() {
        scale([15, 19]) circle(1);
        translate([-5, 7]) circle(5.5);        // sparkle
        translate([ 5.5, -7]) circle(2.5);
    }
}
module nose2d() hull() { translate([-11, 6]) circle(4); translate([11, 6]) circle(4); translate([0,-6]) circle(4); }
module arc2d(r, t, a0, a1)
    for (a = [a0:6:a1-6]) hull() {
        translate(r*[cos(a), sin(a)]) circle(t/2, $fn=16);
        translate(r*[cos(a+6), sin(a+6)]) circle(t/2, $fn=16);
    }
module mouth2d() {
    translate([-9, 0]) arc2d(9, 3.2, 200, 360);
    translate([ 9, 0]) arc2d(9, 3.2, 180, 340);
}
module stroke2d(p, q, t) hull() { translate(p) circle(t/2, $fn=16); translate(q) circle(t/2, $fn=16); }
module whiskers2d(s) {
    stroke2d([s*86, 222], [s*121, 230], 3);
    stroke2d([s*86, 213], [s*122, 213], 3);
    stroke2d([s*86, 204], [s*121, 196], 3);
}
module paw2d() {
    hull() { translate([-12, 12]) circle(10); translate([12, 12]) circle(10); translate([0, 6]) circle(12); }
    for (x = [-15, 0, 15]) translate([x, 32 + (x == 0 ? 4 : 0)]) circle(6.5);
}
module tail2d() {
    // (y, z) on the right-hand side wall; tapers from base to tip
    pts = [[45, 8, 13], [67, 30, 12.5], [71, 58, 12], [55, 84, 11], [27, 96, 10],
           [3, 92, 9], [-9, 76, 8], [1, 62, 7.5]];
    for (i = [0:len(pts)-2]) hull() {
        translate([pts[i][0], pts[i][1]]) circle(pts[i][2]/2);
        translate([pts[i+1][0], pts[i+1][1]]) circle(pts[i+1][2]/2);
    }
}

// emboss a 2D (x,z) shape outward from the front face
module on_front(depth) translate([0, -D/2 + 0.01, 0]) rotate([90, 0, 0]) linear_extrude(depth) children();
// emboss a 2D (y,z) shape outward from the right side face
module on_right(depth) translate([W/2 - 0.01, 0, 0]) rotate([90, 0, 90]) linear_extrude(depth) children();

module face() {
    for (s = [-1, 1]) {
        on_front(1.8) translate([s*56, 240]) eye2d();
        on_front(1.6) whiskers2d(s);
        on_front(0.8) translate([s*70, 206]) scale([1.6, 1]) circle(10);     // blush
        on_front(2.2) translate([s*50, 0]) paw2d();
    }
    on_front(2.0) translate([0, 222]) nose2d();
    on_front(1.6) translate([0, 209]) mouth2d();
    // bell hanging from the collar
    on_front(3.0) translate([0, TIER - COLLAR - 13]) difference() {
        union() { circle(13); translate([0, 12]) circle(4); }
        translate([-8, -1.2]) square([16, 2.4]);
        translate([0, -6]) circle(2.5);
    }
}

// =====================================================================
//  Body
// =====================================================================
COLLAR = 14;       // collar band height (its top edge = tier seam)
COLLAR_T = 2.5;
module collar() {
    hull() { slice(TIER - COLLAR) outline(-0.5); slice(TIER - COLLAR + COLLAR_T) outline(COLLAR_T); }
    prism(TIER - COLLAR + COLLAR_T, TIER - 0.05) outline(COLLAR_T);
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

module body_full(details=true) {
    if (details) body_details();
    difference() {
        prism(0, H) outline();
        prism(FLOOR, H + 1) outline(-WALL);
    }
    ledge();
    collar();
}
module body_details() {
    intersection() { face(); translate([-W, -D, 0]) cube([2*W, 2*D, H]); }
    on_right(2.2) tail2d();
}

module sleeve(x_side) intersection() {
    union() {
        difference() { prism(TIER - SLEEVE, TIER)          outline(-WALL + 0.01); prism(TIER - SLEEVE - 1, TIER + 1)          outline(-WALL - 2); }
        difference() { prism(TIER - 0.01, TIER + SLEEVE - 0.5) outline(-WALL - 0.25); prism(TIER - 1, TIER + SLEEVE + 1)  outline(-WALL - 2); }
    }
    half_box(x_side, -1, H + 10);
}

module half_box(x_side, z0, z1) translate([x_side < 0 ? -W : 0, -D, z0]) cube([W, 2*D, z1 - z0]);

module pin_holes(pts_yz) for (p = pts_yz)
    translate([0, p[0], p[1]]) rotate([0, 90, 0]) cylinder(d=PIN_D, h=2*PIN_L, center=true, $fn=16);

FRONT_Y = -(D/2 - WALL/2);
module body_piece(x_side, tier) {
    z0 = tier == 0 ? -1 : TIER;
    z1 = tier == 0 ? TIER : H + 10;
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
//  Main lid (with ears)
// =====================================================================
EAR_X  = 100;
EAR_T  = 12;
EAR_Y0 = -D/2 + 12;                 // front face of ear
PEG    = 5.6;
PEG_X  = [-24, 24];

module ear2d(s) hull() {
    translate([-48, 0]) square([96, 1]);
    translate([s*12, 66]) circle(10);
}
module ear(s) {
    // modelled in place: base at z = 0, front face at y = 0, thickness along +y
    difference() {
        translate([0, EAR_T, 0]) rotate([90, 0, 0]) linear_extrude(EAR_T) ear2d(s);
        translate([0, -0.01, 0]) rotate([-90, 0, 0]) mirror([0,1,0])
            linear_extrude(1.6) offset(-10) ear2d(s);                           // inner-ear recess
    }
    for (x = PEG_X) translate([x - PEG/2, EAR_T - PEG, -3.8]) cube([PEG, PEG, 3.81]);
}
module ear_sockets() for (s = [-1, 1], x = PEG_X)
    translate([s*EAR_X + x - (PEG + 0.4)/2, EAR_Y0 + EAR_T - PEG - 0.2, H + LID_T - 4.2]) cube([PEG + 0.4, PEG + 0.4, 5]);

module lid_full() {
    difference() {
        union() {
            hull() { prism(H, H + LID_T - 2) outline(); slice(H + LID_T - 0.01) outline(-2); }
            difference() { prism(H - LIP_H, H + 0.01) outline(-WALL - LID_CLR); prism(H - LIP_H - 1, H + 1) outline(-WALL - LID_CLR - LIP_T); }
        }
        ear_sockets();
    }
}
module lid_piece(x_side) difference() {
    intersection() { lid_full(); half_box(x_side, H - LIP_H - 1, H + LID_T + 1); }
    pin_holes([for (y = [-90, -35, 35, 90]) [y, H + 3]]);
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

module button2d() difference() {
    circle(17);
    circle(14.5);
}
module tray_lid(h=0) {   // modelled in place on a tray of height h
    difference() {
        union() {
            prism(h, h + TL_PLATE) t_outline(SK_IN + SK_T);
            prism(h - SK_DEPTH, h) t_outline(SK_IN + SK_T);
            // pry tab over one lug
            translate([-10, TD/2, h - SK_DEPTH]) cube([20, 8, 2]);
        }
        prism(h - 5.6, h + 0.01) t_outline(SK_IN);
        hull() { slice(h - SK_DEPTH - 0.01) t_outline(SK_IN); slice(h - SK_DEPTH + 0.55) t_outline(CATCH); }
        hull() { slice(h - SK_DEPTH + 0.55) t_outline(CATCH); slice(h - SK_DEPTH + 0.85) t_outline(CATCH); }
        hull() { slice(h - SK_DEPTH + 0.85) t_outline(CATCH); slice(h - 5.6 + 0.01) t_outline(SK_IN); }
        // debossed sewing-button motif
        translate([0, 0, h + TL_PLATE - 0.8]) linear_extrude(1) {
            button2d();
            for (a = [45:90:315]) rotate(a) translate([5, 0]) circle(2.6);
        }
    }
}

// =====================================================================
//  Assembly / part selection
// =====================================================================
C_BODY = "#f2c9a0"; C_FACE = "#5a3b2e"; C_LID = "#f2c9a0"; C_EAR = "#f2c9a0";
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
module whole_lid() {
    color(C_LID) lid_full();
    for (s = [-1, 1]) color(C_EAR) translate([s*EAR_X, EAR_Y0, H + LID_T]) ear(s);
}

if (part == "assembly") {
    color(C_BODY) body_full(false); color(C_FACE) body_details();
    tray_set();
    whole_lid();
}
else if (part == "exploded") {
    color(C_BODY) body_full(false); color(C_FACE) body_details();
    tray_set(80);
    translate([0, 0, 260]) whole_lid();
}
else if (part == "body_lower_left")  body_piece(-1, 0);
else if (part == "body_lower_right") body_piece( 1, 0);
else if (part == "body_upper_left")  translate([0, 0, -TIER]) body_piece(-1, 1);
else if (part == "body_upper_right") translate([0, 0, -TIER]) body_piece( 1, 1);
// lid halves flipped so the top face prints on the bed
else if (part == "lid_left")  translate([0, 0, H + LID_T]) rotate([180, 0, 0]) lid_piece(-1);
else if (part == "lid_right") translate([0, 0, H + LID_T]) rotate([180, 0, 0]) lid_piece( 1);
// ears print lying on their back face
else if (part == "ear_left")  rotate([-90, 0, 0]) translate([0, -EAR_T, 0]) ear(-1);
else if (part == "ear_right") rotate([-90, 0, 0]) translate([0, -EAR_T, 0]) ear( 1);
else if (part == "tray_deep_grid")    tray(H_DEEP, 3, 4);
else if (part == "tray_deep_split")   tray(H_DEEP, 1, 2);
else if (part == "tray_shallow_grid") tray(H_SHALLOW, 2, 3);
else if (part == "tray_shallow_long") tray(H_SHALLOW, 3, 1);
// tray lid flipped: top on the bed
else if (part == "tray_lid") translate([0, 0, TL_PLATE]) rotate([180, 0, 0]) tray_lid(0);
