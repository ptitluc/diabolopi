include <diabolobox.scad>;
use <conn_shapes.scad>;
use <rpi_common.scad>;
use <diabolo.scad>;
use <rpi/misc_boards.scad>;

/* [Dimensions] */
height = 43; // 0.1
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
red = 1; // [0:0.01:1]
green = 0.75; // [0:0.01:1]
blue = 0.18; // [0:0.01:1]
alpha = 1; // [0:0.01:1]

module __Customizer_Limit__ () {}

inner_dim  = true;      // are width, depth and height external or internal dimensions ?
width  = 56;          // length on X axis
depth  = 88.2;          // length on Y axis

pillar_dia = 6;
pillar_bore_dia = 4.5;
pillar_height = 3;
pillars_coords = [[3.5, 26.7], [52.5, 26.7], [52.5, 84.8], [3.5, 84.8]];

ph = pillar_height;
pcb_th = 1.4;
pcb_top = ph + pcb_th;

//                          left panel connectors positions
//               | offset | specs | corr. | half shape| top pcb  | corr.
power_plug_pos = [  off   + 10.6  +   0   ,   3/2     + pcb_top  +   0  ];
hdmi_pos       = [  off   +  32   +   0   ,   6.1/2   + pcb_top  +   0  ];
audio_pos      = [  off   + 53    +   0.5 ,   3.25    + pcb_top  -  0.5 ];
spdif_pos      = [  off   +  14   +  -0.5 ,   10/2    + pcb_top  + 14.5 ];
aes_ebu_pos    = [  off   + 40    +   0   ,   23/2    + pcb_top  + 13.5 ];

if (flat == false && show_board == true) {
  rotate([0, 0, 180])
  translate([-iw - off, - id - off, ph + th])
    board_raspberrypi_3_model_b();
}

visible_panels = [show_left, show_bottom, show_right, show_lid, show_back, show_front, show_feet];

arrange(visible_panels) {
  diabolize_lr()
    difference() {
    db_panel("left_right");
    union() {
      translate(power_plug_pos) micro_usb_B();
      translate(hdmi_pos) hdmi();
      translate(audio_pos) audio();
      translate(spdif_pos) toslink();
      translate(aes_ebu_pos) xlr();

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
  diabolize_lr() db_panel("left_right");
  diabolize_bt(bottom=false)
    difference() {
    db_panel("top_bottom");
    translate([41, 16, + th + 0.01])
    rotate([180, 0, 90])
    linear_extrude(th + 0.02)
      import("./resources/Bass_clef_with_note.svg");
  }
  //SD side
  difference() {    
    diabolize_fb()
      difference() {
	db_panel("front_back");
	// status led
	translate([43, pcb_top + 0.6, -0.01]) cube([6, 0.6, th + 0.02]);
	// digi+ power
	translate([30.5, pcb_top + 19, -0.01]) cylinder(d=7, h=th+0.02);
      }
      panel_sd_card(off, ow, dh, pcb_top);
  }
  //USB side
  diabolize_fb()
   difference() {
    db_panel("front_back");
    translate([10.25, pcb_top + 6 + 1, 0]) ethernet();
    translate([29, pcb_top + 7.5 + 1, 0]) double_usb_A();
    translate([47, pcb_top + 7.5 + 1, 0]) double_usb_A();
  }
  // Feet
  for(i=[0:3]) {translate([i*5, 0, ])  foot();}
}
