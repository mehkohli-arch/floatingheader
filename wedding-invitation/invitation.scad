// ============================================================================
//  Lace envelope-fold invitation: Meher Kohli & Marlon Oras Hidalgo
//  Valley of Fire, Las Vegas, Nevada · May 20, 2027
//
//  One sheet that folds into its own envelope (about 6.5 x 3.5 in, the size of
//  a #6 3/4 envelope) and opens into a full 6.5 x 9.8 in page:
//
//        /\        P3  pointed top flap (monogram inside, wax seal outside)
//       /  \
//      |    |  ── fold 2
//      |    |      P2  names, date and venue
//      |    |  ── fold 1
//      |    |      P1  bottom panel: corner slits hold a 5 x 2.5 in paper card
//      |____|
//
//  To close: fold P1 up, then fold P3 down over it. Both folds are living
//  hinges (the first two printed layers). The inside of the page prints
//  face-down on the bed, so the lettering is engraved into the smooth face.
//
//  Build: tools/build.sh   Previews: tools/previews.sh
//  part = "layer_*" / "inlay" / "2d_*"  (see the bottom of the file)
// ============================================================================

use <fonts/GreatVibes-Regular.ttf>
use <fonts/Cinzel.ttf>

part = "2d_inside";

// ---------------- wording ----------------
name_1    = "Meher Kohli";
name_2    = "Marlon Oras Hidalgo";
monogram  = "M&M";
line_top  = "TOGETHER WITH THEIR FAMILIES";
line_inv  = "INVITE YOU TO CELEBRATE THEIR WEDDING";
line_date = "THURSDAY, MAY 20, 2027";
line_loc  = "VALLEY OF FIRE";
line_city = "LAS VEGAS, NEVADA";

script_font = "Great Vibes";
caps_font   = "Cinzel";

// ---------------- page ----------------
PW  = 165;      // page width = folded envelope width (6.5 in)
P1h = 86;       // bottom panel
P2h = 90;       // middle panel = folded envelope height (3.5 in)
P3h = 63;       // top flap, to the tip
P3rect = 15;    // straight part of the flap before the point
g1  = 2.5;      // hinge gaps; fold 2 is wider because it wraps over P1
g2  = 5.0;
T       = 1.2;  // sheet thickness
hinge_t = 0.4;  // living hinge = first two layers (0.2 mm each)
deboss  = 0.6;  // engraving depth on the inside face
text_grow = 0.14;

y1a = 0;          y1b = P1h;
y2a = P1h + g1;   y2b = y2a + P2h;
y3a = y2b + g2;   y3r = y3a + P3rect;   y3t = y3a + P3h;
Ytot = y3t;
seal_r = 12.5;  seal_c = [0, y3t - seal_r];  seal_t = 1.9;  relief = 0.45;

// paper details card, tucked into four corner slits on P1
insert_w = 127;  insert_h = 63.5;   // 5 x 2.5 in
insert_cy = (13 + y1b) / 2 + 0.5;
slit_d = 8;      // how far each corner tucks in

// ---------------- lace ----------------
pic_r = 1.45;  pic_step = 3.4;   // picot edge
net_out = 3.4;  net_in = 13;
hex_p = 2.25;  hex_hole = 1.62;   // ~0.63 mm threads
vine_c = (net_out + net_in) / 2;
fold_rim = 2.5;                   // solid strip along each fold

$fn = 36;

// ============================================================================
//  helpers
// ============================================================================
module stroke(pts, w=0.7) for (i=[0:len(pts)-2]) hull() {
    translate(pts[i]) circle(d=w, $fn=10); translate(pts[i+1]) circle(d=w, $fn=10);
}
module leaf(l=3, w=1.3) {
    r = (l*l/4 + w*w/4) / w;
    translate([l/2,0]) intersection() {
        translate([0, -(r - w/2)]) circle(r=r, $fn=48);
        translate([0,  (r - w/2)]) circle(r=r, $fn=48);
    }
}
module blossom(r=2.5, n=5, hole=true) difference() {
    union() for (a=[0:360/n:359]) rotate(a+90) translate([r*0.5,0]) scale([r*0.55, r*0.37]) circle(1, $fn=24);
    if (hole) circle(d=r*0.36, $fn=12);
}
cord = 0.65;
module lace_blossom(r, n=5, inner=false) {
    if (!inner) blossom(r, n, false);
    else difference() {
        for (a=[0:360/n:359]) rotate(a+90) offset(-cord) translate([r*0.5,0]) scale([r*0.55, r*0.37]) circle(1, $fn=24);
        circle(r=r*0.33, $fn=20);
    }
}
module edge_vine(L, inner=false) {        // along x, centred, symmetric about y=0
    half = 7.2;
    n = 2*floor((L - 2*16) / (2*half));
    x0 = -n*half/2;  amp = 1.5;
    if (n > 0) {
        if (!inner) stroke([for (x=[x0-1.5:0.6:-x0+1.5]) [x, amp*sin((x-x0)*180/half)]], 0.7);
        for (k=[0:n-1]) {
            s = (k%2==0) ? 1 : -1;
            translate([x0 + (k+0.5)*half, s*(amp+0.8)]) rotate(k*23) lace_blossom(3.2, 5, inner);
            if (!inner) {
                translate([x0 + k*half, 0]) rotate(s>0 ? 125 : -55) leaf(2.6, 1.05);
                translate([x0 + (k+1)*half - 0.2, 0]) rotate(s>0 ? -125 : 55) leaf(2.2, 0.95);
            }
        }
    }
}
module corner_motif(inner=false) {
    lace_blossom(4.0, 5, inner);
}
module net_holes(x0, x1, y0, y1) {
    dy = hex_p*sqrt(3)/2;
    for (j=[floor(y0/dy)-1:ceil(y1/dy)+1], i=[floor(x0/hex_p)-1:ceil(x1/hex_p)+1])
        translate([i*hex_p + (abs(j)%2)*hex_p/2, j*dy]) rotate(30) circle(d=hex_hole/cos(30), $fn=6);
}
module txt(s, size, y, font=caps_font, spacing=1) translate([0,y])
    text(s, size=size, font=font, halign="center", valign="center", spacing=spacing);
module wreath(y, r=10.8) translate([0,y]) {
    for (s=[-1,1]) scale([s,1]) {
        stroke([for (a=[-100:6:55]) [r*cos(a), r*sin(a)]], 0.55);
        for (a=[-85:15:50]) translate([r*cos(a), r*sin(a)]) rotate(a+125) leaf(2.3, 0.95);
        for (a=[-77:15:50]) translate([r*cos(a), r*sin(a)]) rotate(a+55) leaf(2.0, 0.85);
    }
    translate([0,-r]) blossom(1.7, 5, false);
}
module sprig(y, len=15) translate([0,y]) {
    for (s=[-1,1]) scale([s,1]) {
        stroke([[3.2,0],[3.2+len,0]], 0.55);
        for (k=[0:2]) translate([5.5 + k*4.5, 0]) { rotate(35) leaf(2.0,0.85); rotate(-35) leaf(2.0,0.85); }
        translate([3.2+len+0.6,0]) circle(d=1.0, $fn=12);
    }
    blossom(2.0, 5, false);
}

// ============================================================================
//  page geometry (view coords: looking at the INSIDE of the opened page)
// ============================================================================
X = PW/2;
module p1() translate([-X, y1a]) square([PW, P1h]);
module p2() translate([-X, y2a]) square([PW, P2h]);
module p3() hull() {
    translate([-X, y3a]) square([PW, P3rect]);
    translate(seal_c) circle(seal_r, $fn=72);
}
// the same panels continued past their folds, so offsets ignore fold edges
module p1x() translate([-X, y1a]) square([PW, P1h + 30]);
module p2x() translate([-X, y2a - 30]) square([PW, P2h + 60]);
module p3x() union() { p3(); translate([-X, y3a - 30]) square([PW, 30 + P3rect]); }

// outer (non-fold) edges, as [from, to]
V_l = [[-X, y3r], [seal_c[0] - seal_r*0.6, seal_c[1] + seal_r*0.2]];
outer_edges = [
    [[-X, y1a], [ X, y1a]],                       // bottom
    [[-X, y1a], [-X, y1b]], [[X, y1a], [X, y1b]], // P1 sides
    [[-X, y2a], [-X, y2b]], [[X, y2a], [X, y2b]], // P2 sides
    [[-X, y3a], [-X, y3r]], [[X, y3a], [X, y3r]], // P3 sides
    [[-X, y3r], [-9, seal_c[1] + 4.5]], [[X, y3r], [9, seal_c[1] + 4.5]]   // the V
];
module along(e, step, start=0) {
    d = e[1] - e[0];  L = norm(d);
    for (i=[0:floor((L-start)/step)]) translate(e[0] + d*((start + i*step)/L)) children();
}
module picots() for (e=outer_edges) along(e, pic_step) circle(r=pic_r, $fn=16);
module eyelets() for (e=outer_edges) let(d=e[1]-e[0], u=d/norm(d), n=[-u[1],u[0]])
    along(e, pic_step, pic_step/2) translate(n*(n*([0,Ytot/2]-e[0]) > 0 ? 1 : -1)*2.0) circle(d=1.0, $fn=12);

module sheet_outline() {
    p1(); p2(); p3();
    intersection() { picots(); union() { offset(pic_r) p1(); offset(pic_r) p2(); offset(pic_r) p3(); } }
}

// lace net band, per panel, kept clear of the folds
module band(pnl) {
    if (pnl==1) intersection() { difference() { offset(-net_out) p1x(); offset(-net_in) p1x(); } translate([-X, y1a]) square([PW, P1h - fold_rim]); }
    if (pnl==2) intersection() { difference() { offset(-net_out) p2x(); offset(-net_in) p2x(); } translate([-X, y2a + fold_rim]) square([PW, P2h - 2*fold_rim]); }
    if (pnl==3) intersection() { difference() { offset(-net_out) p3x(); offset(-net_in) p3x(); translate(seal_c) circle(seal_r + 1); }
                                 translate([-X, y3a + fold_rim]) square([PW, P3h]); }
}
module bands() { band(1); band(2); band(3); }

// floral vines in the band
module vine_on(p, q, inner) {
    d = q - p;  L = norm(d);  u = d/L;  n = [-u[1], u[0]];
    s = (n*([0, Ytot/2] - p) > 0) ? 1 : -1;
    translate((p+q)/2 + n*s*vine_c) rotate(atan2(u[1], u[0])) edge_vine(L, inner);
}
module vines(inner=false) {
    vine_on([-X, y1a], [X, y1a], inner);
    for (s=[-1,1]) {
        vine_on([s*X, y1a + 14], [s*X, y1b], inner);
        vine_on([s*X, y2a], [s*X, y2b], inner);
        vine_on([s*X, y3r - 6], [s*16, seal_c[1] + 1], inner);
    }
    for (s=[-1,1]) translate([s*(X - vine_c), vine_c]) corner_motif(inner);
}

// corner slits for the paper card
module slits() for (sx=[-1,1], sy=[-1,1]) {
    c = [sx*insert_w/2, insert_cy + sy*insert_h/2];
    a = c + [-sx*(slit_d + 1.6), 0];  b = c + [0, -sy*(slit_d + 1.6)];
    hull() { translate(a + [sx*1.6,0]*0.0) circle(d=0.9, $fn=10); translate(b) circle(d=0.9, $fn=10); }
}

// everything cut through the sheet
module through() {
    eyelets();
    difference() { intersection() { bands(); net_holes(-X, X, 0, Ytot); } vines(); }
    intersection() { bands(); vines(true); }
    slits();
}

// lettering & ornaments engraved into the inside face
module lettering() offset(r=text_grow) {
    // P3, the flap: monogram
    txt(monogram, 3.6, y3a + 26.2, script_font, 0.95);
    // P2: names
    c2 = (y2a + y2b)/2;
    txt(line_top, 2.5,  c2 + 33, spacing=1.25);
    txt(name_1,   9.6,  c2 + 22.5, script_font);
    txt("&",      5.6,  c2 + 12.5, script_font);
    txt(name_2,   8.3,  c2 + 3, script_font);
    txt(line_inv, 2.4,  c2 - 8.5, spacing=1.15);
    txt(line_date,3.1,  c2 - 21.5, spacing=1.3);
    txt(line_loc, 2.8,  c2 - 28.8, spacing=1.4);
    txt(line_city,2.3,  c2 - 34.6, spacing=1.4);
}
module engraved() {
    lettering();
    wreath(y3a + 26, 9.7);
    sprig((y2a + y2b)/2 - 15, 15);
    // a fine frame line on P2, a dotted line framing the card on P1
    c2 = (y2a + y2b)/2;
    translate([0, c2]) difference() {
        offset(2) square([PW - 2*net_in - 4 - 4, P2h - 2*fold_rim - 4 - 4], center=true);
        offset(1.65) square([PW - 2*net_in - 4 - 4, P2h - 2*fold_rim - 4 - 4], center=true);
    }
    for (s=[-1,1]) translate([s*(X - net_in - 2), c2]) rotate(90) blossom(1.6, 5, false);
}

// ============================================================================
//  3D (print coords: mirror-x of view coords, centred on the bed)
// ============================================================================
module to_print() translate([0, -Ytot/2]) mirror([1,0]) children();
module sheet2d() difference() { sheet_outline(); through(); }

module hinges2d() {
    translate([-X + 6, y1b - 2.5]) square([PW - 12, g1 + 5]);
    translate([-X + 6, y2b - 2.5]) square([PW - 12, g2 + 5]);
}

// wax-seal medallion on the OUTSIDE of the flap (the print's top face).
// Art is drawn rotated 180 degrees so it reads upright once the flap folds down.
module seal_disc() translate(seal_c)
    polygon([for (a=[0:3:357]) let(r = seal_r + 0.45*sin(7*a) + 0.25*sin(13*a+40)) [r*cos(a), r*sin(a)]]);
module seal_art() translate(seal_c) rotate(180) mirror([1,0]) {
    difference() { circle(r=seal_r-1.6); circle(r=seal_r-2.3); }
    scale(0.78) wreath(0);
    offset(r=0.1) text(monogram, size=3.4, font=script_font, halign="center", valign="center", spacing=0.95);
}

if (part == "layer_face") to_print() linear_extrude(deboss) difference() { sheet2d(); engraved(); }
if (part == "layer_main") to_print() translate([0,0,deboss]) linear_extrude(T - deboss) sheet2d();
if (part == "layer_hinge") to_print() linear_extrude(hinge_t) hinges2d();
if (part == "layer_seal") to_print() { linear_extrude(seal_t) seal_disc(); translate([0,0,seal_t]) linear_extrude(relief) seal_art(); }
if (part == "inlay") to_print() linear_extrude(deboss) intersection() { engraved(); sheet2d(); }

// ---------------- 2D views for the previews ----------------
// open: the inside of the page
if (part == "2d_inside")   sheet2d();
if (part == "2d_engraved") intersection() { engraved(); sheet2d(); }
if (part == "2d_hinges")   hinges2d();
if (part == "2d_card")     translate([0, insert_cy]) difference() {   // paper card, corners tucked
    square([insert_w, insert_h], center=true);
    for (sx=[-1,1], sy=[-1,1]) translate([sx*insert_w/2, sy*insert_h/2]) rotate(45) square(slit_d*sqrt(2), center=true);
}
// closed: seen from the front of the envelope (flap side). Folding a panel
// about a horizontal fold reflects it in y (x stays as on the inside view).
f1 = y1b + g1/2;  f2 = y2b + g2/2;
module fold(f) translate([0, 2*f]) mirror([0,1]) children();
if (part == "2d_closed_back")  p2();                          // middle panel, outside
if (part == "2d_closed_p1")    fold(f1) sheet2d_p1();
if (part == "2d_closed_p3")    fold(f2) sheet2d_p3();
if (part == "2d_closed_seal")  fold(f2) seal_disc();
if (part == "2d_closed_sealart") fold(f2) seal_art();
module sheet2d_p1() intersection() { sheet2d(); translate([-X-5, -5]) square([PW+10, y1b + 5]); }
module sheet2d_p3() intersection() { sheet2d(); translate([-X-5, y3a]) square([PW+10, P3h + 5]); }
