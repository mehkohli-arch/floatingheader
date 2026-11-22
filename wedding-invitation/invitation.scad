// ============================================================================
//  Lace wedding invitation: Meher Kohli & Marlon Oras Hidalgo
//  Valley of Fire, Las Vegas, Nevada · May 20, 2027
//
//  5 x 7 in card, printed FACE-DOWN. Fine tulle-net lace border with a floral
//  vine, an arched centre panel with engraved lettering, and four corner
//  pockets on the back for a 4 x 6 in paper details card. Four flaps on living
//  hinges fold over the front into an envelope closed by a monogram seal.
//  Build the print files with tools/build.sh, previews with tools/previews.sh.
//
//  part = "body"   card (colour 1: ivory / white)  -> run tools/build.sh
//  part = "inlay"  engraved lettering + motifs, 0.6 mm (colour 2: gold), optional
//  part = "2d_plate", "2d_engraved"  flat artwork for previews
//  part = "preview_back"  3D look at the back + pockets
// ============================================================================

use <fonts/GreatVibes-Regular.ttf>
use <fonts/Cinzel.ttf>

part = "body";

// ---------------- wording ----------------
name_1    = "Meher Kohli";
name_2    = "Marlon Oras Hidalgo";
monogram  = "M&M";
line_top  = "TOGETHER WITH THEIR FAMILIES";
line_date = "MAY 20, 2027";
line_loc  = "VALLEY OF FIRE";
line_city = "LAS VEGAS, NEVADA";

script_font = "Great Vibes";
caps_font   = "Cinzel";

// ---------------- card ----------------
W = 127;  H = 178;  T = 1.6;
deboss    = 0.6;    // engraving depth (3 layers at 0.2 mm)
text_grow = 0.14;   // thickens hairlines just enough to print

// ---------------- paper insert & pockets (back) ----------------
insert_w = 101.6;  insert_h = 152.4;   // 4 x 6 in
clear = 0.75;  paper_gap = 0.7;  pk_flap_t = 0.9;  wall_w = 2.0;  leg = 16;

// ---------------- lace ----------------
sc_r = 2.3;  sc_step = 4.3;   // scalloped edge
net_out = 3.8;                // tulle net band (from card edge)
net_in  = 15.5;
hex_p   = 2.25;                // net pitch
hex_hole= 1.62;               // hole across flats -> ~0.63 mm threads
vine_c  = 9.65;               // vine centre line (from card edge)

$fn = 36;

// ============================================================================
module rrect(w, h, r) offset(r) square([w-2*r, h-2*r], center=true);

module stroke(pts, w=0.7) for (i=[0:len(pts)-2]) hull() {
    translate(pts[i]) circle(d=w, $fn=10); translate(pts[i+1]) circle(d=w, $fn=10);
}

module leaf(l=3, w=1.3) {   // pointed vesica leaf, base at origin, along +x
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

// ---------------- edge ----------------
module along_edges() {
    nx = round((W-2*sc_r)/sc_step);  ny = round((H-2*sc_r)/sc_step);
    for (s=[-1,1]) {
        for (i=[0:nx]) translate([-(W-2*sc_r)/2 + i*(W-2*sc_r)/nx, s*(H/2-sc_r)]) children();
        for (i=[1:ny-1]) translate([s*(W/2-sc_r), -(H-2*sc_r)/2 + i*(H-2*sc_r)/ny]) children();
    }
}
module outline() union() { square([W-2*sc_r, H-2*sc_r], center=true); along_edges() circle(r=sc_r); }
module eyelets() along_edges() circle(d=1.0, $fn=12);

// ---------------- tulle net ----------------
module net_holes(x0=-W/2, x1=W/2, y0=-H/2, y1=H/2) {
    dy = hex_p*sqrt(3)/2;
    for (j=[floor(y0/dy)-1:ceil(y1/dy)+1], i=[floor(x0/hex_p)-1:ceil(x1/hex_p)+1])
        translate([i*hex_p + (abs(j)%2)*hex_p/2, j*dy]) rotate(30) circle(d=hex_hole/cos(30), $fn=6);
}
module net_band() difference() {
    square([W-2*net_out, H-2*net_out], center=true);
    square([W-2*net_in,  H-2*net_in ], center=true);
}

// ---------------- floral vine (cutwork motifs sitting on the net) ----------------
// inner=false -> the solid silhouette of every motif (clears the net)
// inner=true  -> the openings inside the petals (cut back out), leaving
//                0.65 mm outlined petals like a lace cordonnet
cord = 0.65;

module lace_blossom(r, n=5, inner=false) {
    if (!inner) blossom(r, n, false);
    else difference() {
        for (a=[0:360/n:359]) rotate(a+90) offset(-cord) translate([r*0.5,0]) scale([r*0.55, r*0.37]) circle(1, $fn=24);
        circle(r=r*0.33, $fn=20);
    }
}

// one edge, drawn along x, inward = +y, centred on the vine line
module edge_vine(L, inner=false) {
    half = 7.2;
    n = 2*floor((L - 2*16) / (2*half));
    x0 = -n*half/2;
    amp = 1.5;
    if (!inner) stroke([for (x=[x0-1.5:0.6:-x0+1.5]) [x, amp*sin((x-x0)*180/half)]], 0.7);
    for (k=[0:n-1]) {
        xc = x0 + (k+0.5)*half;
        s  = (k%2==0) ? 1 : -1;
        translate([xc, s*(amp+0.8)]) rotate(k*23) lace_blossom(3.2, 5, inner);
        if (!inner) {
            translate([x0 + k*half, 0]) rotate(s>0 ? 125 : -55) leaf(2.6, 1.05);
            translate([x0 + (k+1)*half - 0.2, 0]) rotate(s>0 ? -125 : 55) leaf(2.2, 0.95);
        }
    }
    if (!inner) for (e=[-1,1]) translate([e*(-x0+1.8), 0]) circle(d=1.2, $fn=16);
}

module corner_motif(inner=false) {
    lace_blossom(4.3, 6, inner);
    if (!inner) for (a=[0:60:300]) rotate(a) translate([4.6,0]) circle(d=0.9, $fn=12);
}

module lace_motifs(inner=false) {
    for (s=[-1,1]) {
        translate([0, s*(H/2 - vine_c)]) scale([1,-s]) edge_vine(W, inner);
        translate([s*(W/2 - vine_c), 0]) rotate(90) scale([1, s]) edge_vine(H, inner);
    }
    for (sx=[-1,1], sy=[-1,1]) translate([sx*(W/2-vine_c), sy*(H/2-vine_c)]) corner_motif(inner);
}

// ---------------- arched centre panel ----------------
p_in = 20.5;                 // panel inset
p_w  = W - 2*p_in;
arch_r = 58;
p_top = H/2 - p_in;
shoulder = p_top - (arch_r - sqrt(arch_r*arch_r - p_w*p_w/4));
module panel_shape(o=0) offset(o) union() {
    translate([-p_w/2, -(H/2-p_in)]) square([p_w, shoulder + H/2 - p_in]);
    intersection() {
        translate([0, p_top - arch_r]) circle(r=arch_r, $fn=240);
        translate([-p_w/2, shoulder-1]) square([p_w, 40]);
    }
}
module panel_line() {
    difference() { panel_shape(0.32); panel_shape(-0.32); }
    difference() { panel_shape(-1.5); panel_shape(-1.85); }
    // small blossoms where the arch meets the walls and at the apex
    translate([0, p_top]) blossom(2.1, 5, false);
    for (s=[-1,1]) translate([s*p_w/2, shoulder]) circle(d=1.6);
}

// ---------------- lettering & ornaments ----------------
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

module lettering() offset(r=text_grow) {
    txt(monogram,  3.8,  43.0, script_font, 0.95);
    txt(line_top,  2.5,  25.5,   spacing=1.28);
    txt(name_1,    9.0,  15.5, script_font);
    txt("&",       5.4,   6.0, script_font);
    txt(name_2,    7.1,  -3.5, script_font);
    txt(line_date, 3.5, -27, spacing=1.4);
    txt(line_loc,  3.0, -36,   spacing=1.45);
    txt(line_city, 2.5, -42.5, spacing=1.45);
}

module engraved() {
    lettering();
    wreath(42.5);
    sprig(-15);
    sprig(-53, 9);
    panel_line();
}

module inner_picots() {
    nx = round((W-2*net_in)/3.2);  ny = round((H-2*net_in)/3.2);
    for (s=[-1,1]) {
        for (i=[0:nx]) translate([-(W/2-net_in) + i*(W-2*net_in)/nx, s*(H/2-net_in)]) circle(r=1.25, $fn=20);
        for (i=[0:ny]) translate([s*(W/2-net_in), -(H/2-net_in) + i*(H-2*net_in)/ny]) circle(r=1.25, $fn=20);
    }
}

module through() {
    eyelets();
    difference() { intersection() { net_band(); net_holes(); } lace_motifs(); inner_picots(); }
    lace_motifs(true);
}

// ============================================================================
module plate2d() difference() { outline(); through(); }

module card_body() {
    mirror([1,0,0]) difference() {
        linear_extrude(T) plate2d();
        translate([0,0,-1]) linear_extrude(deboss+1) engraved();
    }
    pockets();
}
module inlay() mirror([1,0,0]) linear_extrude(deboss) intersection() { engraved(); plate2d(); }

module pocket() {
    a = insert_w/2 + clear;  b = insert_h/2 + clear;
    linear_extrude(paper_gap) difference() {
        translate([a-leg-1, b-leg-1]) square([leg+1+wall_w, leg+1+wall_w]);
        translate([a-leg-2, b-leg-2]) square([leg+2, leg+2]);
    }
    translate([0,0,paper_gap]) linear_extrude(pk_flap_t) difference() {
        polygon([[a+wall_w, b+wall_w], [a-leg, b+wall_w], [a+wall_w, b-leg]]);
        translate([a + wall_w - (leg+wall_w)/3 + 0.6, b + wall_w - (leg+wall_w)/3 + 0.6]) blossom(3.4, 5, false);
    }
}
module pockets() translate([0,0,T]) for (sx=[-1,1], sy=[-1,1]) scale([sx,sy,1]) pocket();

// ============================================================================
//  ENVELOPE: four lace flaps joined to the card by living hinges (0.4 mm
//  strips on the bed layer). They fold over the front: sides, bottom, then
//  the top flap with its monogram seal. Coordinates below are print coords.
// ============================================================================
env_t   = 1.0;            // flap thickness
hinge_t = 0.4;            // living hinge = first two layers
g_side = 2.0;  g_bot = 2.8;  g_top = 4.0;   // hinge gaps (grow with the stack)
side_h = 62;   bot_h = 79;   top_h = 80;     // flap depths
seal_r = 12.5;  seal_t = 1.8;  relief = 0.45;
rim = 2.2;

function hy_top() = H/2 + g_top/2;
side_bw = H/2 - 3;   tb_bw = W/2 - 3;

module dot(p, r=0.01) translate(p) circle(r, $fn=8);

// flap outlines in print coords, plus their free edges for picots/vines
module top_shape() hull() { dot([-tb_bw, H/2+g_top]); dot([tb_bw, H/2+g_top]); translate(seal_c()) circle(seal_r-0.5, $fn=72); }
function seal_c() = [0, H/2 + g_top + top_h - seal_r];
module bot_shape() hull() { dot([-tb_bw, -H/2-g_bot]); dot([tb_bw, -H/2-g_bot]); translate([0, -H/2-g_bot-bot_h+5]) circle(5); }
module side_shape(s) hull() { dot([s*(W/2+g_side), -side_bw]); dot([s*(W/2+g_side), side_bw]); translate([s*(W/2+g_side+side_h-5), 0]) circle(5); }

band_w = 13.5;   // width of the lace trim along each flap's free edges

function flap_tip(w) = w=="top" ? seal_c() : w=="bot" ? [0, -H/2-g_bot-bot_h+5]
                     : [(w=="right"?1:-1)*(W/2+g_side+side_h-5), 0];
function flap_base(w) = w=="top" ? [[-tb_bw, H/2+g_top], [tb_bw, H/2+g_top]]
                      : w=="bot" ? [[-tb_bw, -H/2-g_bot], [tb_bw, -H/2-g_bot]]
                      : let(x=(w=="right"?1:-1)*(W/2+g_side)) [[x, -side_bw], [x, side_bw]];
function flap_inner(w) = (flap_base(w)[0] + flap_base(w)[1] + flap_tip(w))/3;

module flap_edges(w, mode) {
    tip = flap_tip(w);
    tip_skip = w=="top" ? seal_r + 1.5 : 5;
    for (p = flap_base(w)) {
        d = tip - p;  L = norm(d) - tip_skip;  u = d/norm(d);
        nrm0 = [-u[1], u[0]];
        nrm = (nrm0*(flap_inner(w) - p) > 0) ? nrm0 : -nrm0;     // points into the flap
        if (mode=="picot")
            for (i=[1:floor(L/3.3)]) translate(p + u*(i*3.3)) circle(r=1.3, $fn=16);
        else if (mode=="eyelet")
            for (i=[1:floor(L/3.3)-1]) translate(p + u*(i*3.3) + nrm*3.0) circle(d=1.1, $fn=14);
        else
            translate(p + u*(L*0.5 + 1) + nrm*(rim + 5.4)) rotate(atan2(u[1], u[0]))
                edge_vine(L*0.78 + 32 - 14, mode=="inner");
    }
}

module flap_shape(w) {
    if (w=="top") top_shape();
    if (w=="bot") bot_shape();
    if (w=="left")  side_shape(-1);
    if (w=="right") side_shape(1);
}

module hinge_band(which) {   // solid strip along the hinge edge of a flap
    if (which=="top") translate([-W/2, H/2+g_top]) square([W, 3]);
    if (which=="bot") translate([-W/2, -H/2-g_bot-3]) square([W, 3]);
    if (which=="left")  translate([-W/2-g_side-3, -H/2]) square([3, H]);
    if (which=="right") translate([ W/2+g_side,   -H/2]) square([3, H]);
}

module base_extension(w) {   // continues the flap past its hinge so the trim skips the hinge edge
    b = flap_base(w);  t = flap_tip(w);
    u = (b[0]+b[1])/2 - t;  ext = u/norm(u)*40;
    polygon([b[0], b[1], b[1]+ext, b[0]+ext]);
}

module lace_zone(w) difference() {      // where the net goes
    offset(-rim) flap_shape(w);
    offset(-band_w) union() { flap_shape(w); base_extension(w); }
    hinge_band(w);
    if (w=="top") translate(seal_c()) circle(seal_r+1);
}

module flap_lace(w) {
    tip = flap_tip(w);
    difference() {
        union() { flap_shape(w); intersection() { offset(1.4) flap_shape(w); flap_edges(w, "picot"); } }
        if (w != "top") difference() { flap_edges(w, "eyelet"); hinge_band(w); }
        if (w == "top") difference() {
            intersection() {
                lace_zone(w);
                net_holes(tip[0] < 0 ? tip[0]-8 : -W/2-8, tip[0] > 0 ? tip[0]+8 : W/2+8,
                          tip[1] < 0 ? tip[1]-8 : -H/2-8, tip[1] > 0 ? tip[1]+8 : H/2+8);
            }
            flap_edges(w, "vine");
        }
        if (w == "top") intersection() { lace_zone(w); flap_edges(w, "inner"); }
    }
}

module hinge_strip(which) {
    if (which=="top") translate([-tb_bw+6, H/2-1.4]) square([2*tb_bw-12, g_top+1.4+2.5]);
    if (which=="bot") translate([-tb_bw+6, -H/2-g_bot-2.5]) square([2*tb_bw-12, g_bot+1.4+2.5]);
    if (which=="left")  translate([-W/2-g_side-2.5, -side_bw+6]) square([g_side+1.4+2.5, 2*side_bw-12]);
    if (which=="right") translate([ W/2-1.4,        -side_bw+6]) square([g_side+1.4+2.5, 2*side_bw-12]);
}

// wax-seal medallion (print coords; art is pre-rotated 180 deg so it reads
// upright once the top flap is folded down)
module seal_disc() translate(seal_c())
    polygon([for (a=[0:3:357]) let(r = seal_r + 0.45*sin(7*a) + 0.25*sin(13*a+40)) [r*cos(a), r*sin(a)]]);
module seal_art() translate(seal_c()) rotate(180) {
    difference() { circle(r=seal_r-1.6); circle(r=seal_r-2.3); }
    scale(0.78) wreath(0);
    offset(r=0.1) text(monogram, size=3.4, font=script_font, halign="center", valign="center", spacing=0.95);
}

flaps = ["left", "right", "bot", "top"];

module env_flaps3d() {
    for (w=flaps) linear_extrude(env_t) flap_lace(w);
    for (w=flaps) linear_extrude(hinge_t) hinge_strip(w);
    linear_extrude(seal_t) seal_disc();
    translate([0,0,seal_t]) linear_extrude(relief) seal_art();
}

// 2D views as seen from the FRONT (viewer coords = mirror-x of print coords)
module fold_view(which) {   // flap folded closed
    if (which=="top")   translate([0,  2*(H/2+g_top/2)]) rotate(180) children();
    if (which=="bot")   translate([0, -2*(H/2+g_bot/2)]) rotate(180) children();
    if (which=="right") translate([-2*(W/2+g_side/2), 0]) children();
    if (which=="left")  translate([ 2*(W/2+g_side/2), 0]) children();
}

if (part == "layer_flaps") env_flaps3d();
if (part == "2d_flaps_open") mirror([1,0]) { for (w=flaps) flap_lace(w); seal_disc(); }
if (part == "2d_hinges_open") mirror([1,0]) for (w=flaps) hinge_strip(w);
for (w=flaps) if (part == str("2d_fold_", w)) fold_view(w) flap_lace(w);
if (part == "2d_fold_seal") fold_view("top") seal_disc();
if (part == "2d_fold_sealart") fold_view("top") seal_art();

if (part == "body")        card_body();   // full model (slow CGAL in OpenSCAD 2021; build.sh is faster)
// fast layer exports, merged by tools/build.sh
if (part == "layer_face")  mirror([1,0,0]) linear_extrude(deboss) difference() { plate2d(); engraved(); }
if (part == "layer_main")  mirror([1,0,0]) translate([0,0,deboss]) linear_extrude(T-deboss) plate2d();
if (part == "layer_pockets") pockets();
if (part == "inlay")       inlay();
if (part == "2d_plate")    plate2d();
if (part == "2d_engraved") intersection() { engraved(); plate2d(); }
if (part == "preview_back") {
    color([0.97,0.95,0.90]) card_body();
    color([0.86,0.66,0.60]) translate([0,0,T+0.15]) linear_extrude(0.3) square([insert_w, insert_h], center=true);
}
