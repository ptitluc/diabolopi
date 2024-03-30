include <diabolobox/diabolobox.scad>;
use <conn_shapes.scad>;
use <rpi_common.scad>;
use <rpi/misc_boards.scad>;

/* [Dimensions] */
height = 21;            // 0.1
thickness = 2.4;        // 0.1
edge_offset = 1.5;      // 0.1
corner_radius = 1;      // 0.1
fit_clearance = 0.3;    // 0.05

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
red = 0.04; // [0:0.01:1]
green = 0.51; // [0:0.01:1]
blue = 1; // [0:0.01:1]
alpha = 1; // [0:0.01:1]

module __Customizer_Limit__ () {}

inner_dim  = true;      // are width, depth and height external or internal dimensions ?
width  = 56;          // length on X axis
depth  = 88.2;          // length on Y axis

  
pillar_dia = 6;
pillar_bore_dia = 2.7;
pillar_height = 3;
pillars_coords = [[3.5, 26.7], [52.5, 26.7], [52.5, 84.8], [3.5, 84.8]];

ph = pillar_height;
pcb_th = 1.4;
pcb_top = ph + pcb_th;

//                          left panel connectors positions
//               | offset  | specs | corr. | half shape| top pcb  | corr.
power_plug_pos = [  off   + 11.2  +   0   ,   3.5/2   + pcb_top +   0  ];
u_hdmi_1_pos   = [  off   +  26   +   0   ,   3.5/2   + pcb_top +   0  ];
u_hdmi_2_pos   = [  off   + 39.5  +   0   ,   3.5/2   + pcb_top +   0  ];
audio_pos      = [  off   + 54    +   0   ,   3.25    + pcb_top +   0  ];


if (flat == false && show_board == true) {
  rotate([0, 0, 180])
  translate([-iw - off, - id - off, ph + th])
    board_raspberrypi_4_model_b();
}

visible_panels = [show_left, show_bottom, show_right, show_lid, show_back, show_front, show_feet];

arrange(visible_panels) {

////////// Left panel

  diabolize_lr()
  difference() {
    db_panel("left_right");
    union() {
      translate(power_plug_pos) usb_C();
      translate(u_hdmi_1_pos) u_hdmi();
      translate(u_hdmi_2_pos) u_hdmi();
      translate(audio_pos) audio();
    }
  }

////////// Bottom
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
      mirror([0,1,0])
      rotate([0, 0, 90])
      translate([7.5 - od, -8, -0.1])
      text("▶diabolobox◀",7, "FreeMono:style=Bold", spacing=0.9);
  }

/////////// right panel
 
  diabolize_lr() db_panel("left_right");
  //
  // lid
  //
  diabolize_bt(bottom=false)
    difference() {
    db_panel("top_bottom");
    hex_vents();
  }
  //
  // back panel
  //
  difference() {
    diabolize_fb()
    difference() {
      db_panel("front_back");
      // status led
      translate([7, ph + 1.4, -0.01])
      cube([6, 0.7, th + 0.02]);
    }
    // sd slot
    panel_sd_card(off, ow, dh, pcb_top);
  }
  //USB side
  diabolize_fb()
  difference() {
    db_panel("front_back");
    translate([9, 7.5 + pcb_th + ph + 1, 0]) double_usb_A();
    translate([27, 7.5 + pcb_th + ph + 1, 0]) double_usb_A();
    translate([45.75, 6 + ph + pcb_th + 1, 0]) ethernet();
  }
  // Feet
  for(i=[1:1:4]) {translate([i*5, -10])  foot();}
}

    
