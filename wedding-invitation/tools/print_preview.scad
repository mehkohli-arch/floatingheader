// the part as it sits on the print bed (256 x 256 mm outline shown)
color([0.97,0.95,0.90]) import("../stl/envelope_invitation_body.stl");
color([0.25,0.25,0.27]) translate([-128,-128,-1.2]) difference() { cube([256,256,1]); translate([1,1,-1]) cube([254,254,3]); }
