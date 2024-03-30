include <diabolobox.scad>;
use <conn_shapes.scad>;
use <rpi_common.scad>;
use <rpi/misc_boards.scad>;

/* [Dimensions] */
height = 16; // 0.1
thickness = 2.4; // 0.1
edge_offset = 1.5;  // 0.1
corner_radius = 1; // 0.1
fit_clearance = 0.3; // 0.05

/* [View] */
flat = false;  
show_lid = true;
show_left = true;
show_right = true;
show_back = true;
show_front = true;
show_bottom = true;
show_feet = true;
show_board = true;
explode_distance = 0.0; // [0:0.5:20]

/* [Color] */
red = 0.1; // [0:0.01:1]
green = 0.2; // [0:0.01:1]
blue = 0.3; // [0:0.01:1]
alpha = 0.4; // [0:0.01:1]


module __Customizer_Limit__ () {}

inner_dim = true;
width = 56;
depth = 68;


pillar_dia = 6;
pillar_bore_dia = 2.7;
pillar_height = 3;
pillars_coords = [[3.5, 6.5], [52.5, 6.5], [52.5, 64.5], [3.5, 64.5]];

ph = pillar_height;
pcb_th = 1.4;
pcb_top = ph + pcb_th;


if (flat == false && show_board == true) {
  rotate([0, 0, 180])
  translate([-iw - off, - id - off, ph + th])
  board_raspberrypi_model_a_plus_rev1_1();
}

visible_panels = [show_left, show_bottom, show_right, show_lid, show_back, show_front, show_feet];

arrange(visible_panels) {
  diabolize_lr("left")
  difference() {
    db_panel("left_right");
    union() {
      // power plug
      translate([off + 10.6, 1.5 + ph + pcb_th]) micro_usb_B();
      // hdmi
      translate([off + 32, 3 + ph + pcb_th]) hdmi();
      // audio
      translate([off + 53.5, 3.25 + ph + pcb_th]) audio();
    }
  }
  diabolize_bt()
    difference() {
      union() {
	db_panel("top_bottom");
	pillars();
	sd_card_guard(off, od, ow, th);
      }
    vents();
    feet_slots();
    bottom_sd_card(off, od, ow);
    // logo
    linear_extrude(0.3)
    mirror([0,1,0]) rotate([0, 0, 90]) translate([7.5 - od, -8, -0.1])
    text("▶diabolobox◀",7, "FreeMono:style=Bold", spacing=0.9);
  }
  diabolize_lr("right") db_panel("left_right");
  diabolize_bt(bottom=false)
    difference() {
    db_panel("top_bottom");
    vents();
  }
  //SD side
  difference() {    
    diabolize_fb() db_panel("front_back");
      panel_sd_card(off, ow, dh, pcb_top);
  }
  //USB side
  diabolize_fb()
  difference() {
    db_panel("front_back");
    translate([
	       31.5,    // as per datasheet
	       3        // half usb_A height
	       + fc     //
	       + ph     // pillars height
	       + pcb_th // pcb thickness
	       + 1,     // extra space between pcb and connector
	       0]) usb_A();
  }
  // Feet
  for(i=[0:3]) {translate([i*5, 0])  foot();}
}

    
