//include <diabolobox.scad>;

module rpi_sd_card_slot(h=5.15, depth=6) {
  dia = 17;
  front = 18;
  cut = dia - depth;
    translate([0, -cut -0.1])
    difference() {
      hull() {
	  cube([front, cut, h]);
	  translate([front/2, dia/2])
	    cylinder(h=h, d=dia);
        }
      translate([-front/2, -0.1, -0.1])
	cube([2*front, cut + 0.2, h+0.2]);
    }
};

module bottom_sd_card(off, od, ow) {
  translate([ow/2 - 9, od + 0.01, -0.1])
    mirror([0,1,0])
    rpi_sd_card_slot(depth=off + 3);
}

module sd_card_guard(off, od, ow, th) {
  translate([ow/2 - 9, od - off - 3, th]) cube([18, 3, 1.4]);
}

module panel_sd_card(off, ow, dh, h) {
  rotate([-90, 0, 0])
    translate([dh - off + ow/2 - 9, -off, -0.01]) 
    rpi_sd_card_slot(h=h, depth=off + 3);
}

rpi_sd_card_slot(depth=4);
