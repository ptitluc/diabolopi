/* This file is part of Diabolopi - customizable raspberry pi cases
Copyright (C) 2024  Luc Milland

Diabolopi is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation, either version 3
of the License, or (at your option) any later version.

Diabolopi is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Diabolopi. If not, see <https://www.gnu.org/licenses/> */

include <diabolobox/diabolobox.scad>;
use <utils/conn_shapes.scad>;
use <utils/rpi_common.scad>;
use <rpi/misc_boards.scad>;

/* [Dimensions] */
height = 43;         // 0.1
thickness = 2.4;     // 0.1
edge_offset = 1.5;   // 0.1
corner_radius = 1;   // 0.1
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
red = 0.66;   // [0:0.01:1]
green = 0.26; // [0:0.01:1]
blue = 0.18;  // [0:0.01:1]
alpha = 1;    // [0:0.01:1]

module __Customizer_Limit__ () {}

inner_dim  = true; // case size based on the pcb size
width  = 56.5;     // length on X axis + 0.5mm fit clearance
depth  = 88.7;     // length on Y axis + 0.5mm fit clearance

pillar_dia = 6;
pillar_bore_dia = 5;
pillar_height = 3;
pillars_coords = [[3.5, 26.7], [52.5, 26.7], [52.5, 84.8], [3.5, 84.8]];

ph = pillar_height;
pcb_th = 1.4;
pcb_top = ph + pcb_th;

//                          left panel connectors positions
//               | offset | specs |  corr. | half shape | top pcb  | corr.
power_plug_pos = [  off   + 10.6  +   0.25 ,    3/2     + pcb_top  +   0   ];
hdmi_pos       = [  off   + 32    +   0.25 ,    6.1/2   + pcb_top  +   0   ];
audio_pos      = [  off   + 53    +   0.75 ,    3.25    + pcb_top  -  0.5  ];
jack_hb_pos    = [  off   + 16.75 +   0.25 ,   10/2     + pcb_top  + 8.75  ];
rca_L_hb_pos   = [  off   + 34    +   0.25 ,    9/2     + pcb_top  + 14.75 ];
rca_R_hb_pos   = [  off   + 51.17 +   0.25 ,    9/2     + pcb_top  + 14.75 ];

if (flat == false && show_board == true) {
  rotate([0, 0, 180])
  translate([-iw - off, - id - off, ph + th])
    board_raspberrypi_3_model_b();
  color("rosybrown", 1)
    translate([77, 119.45, 16.4])
    rotate([0, 0, -90])
      import("./resources/hifiberry-dac-plus-adc-1.2.stl");
}

visible_panels = [show_left, show_bottom, show_right, show_lid, show_back, show_front, show_feet];

arrange(visible_panels) {
  diabolize_lr("left")
    difference() {
    db_panel("left_right");
    union() {
      translate(power_plug_pos) micro_usb_B();
      translate(hdmi_pos) hdmi();
      translate(audio_pos) audio();
      translate(jack_hb_pos) audio();
      translate(rca_L_hb_pos) rca();
      translate(rca_R_hb_pos) rca();
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
	translate([43.25, pcb_top + 0.6, -0.01]) cube([6, 0.6, th + 0.02]);
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
