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

$fn=32;
use <diabolobox/utils/rsquare.scad>;

module micro_usb_B(h=5) {
  // 8 x 3 mm
  translate([0 ,0 ,-0.01])
    hull() {
      translate([3, 0.5, 0]) cylinder(h, r=1);
      translate([-3, 0.5, 0]) cylinder(h, r=1);
      translate([-3.2, -1.5, 0]) cube([6.4, 1, h]);
   }
}
micro_usb_B();
module usb_C(h=5) {
  translate([0, 0, -0.1])
    linear_extrude(h)
    rsquare([10, 3.5], 1.2);
}

module usb_A(h=5) {
   translate([0, 0, -0.1])
   linear_extrude(h)
   rsquare([13, 6], 0.65);
}    

module double_usb_A(h=5) {
   translate([0, 0, -0.1])
   linear_extrude(h)
   rsquare([14, 15], 0.65);
}    

module ethernet(h=5) {
   translate([0, 0, -0.1])
   linear_extrude(h)
   rsquare([15, 12], 0.65);
}    

module u_hdmi(h=5) {
  translate([0, 0, -0.1])
  linear_extrude(h)
    rsquare([7.5, 3.5], 0.65);
}

module hdmi(h=5) {
  translate([0, 0, -0.1])
    linear_extrude(h)
    hull() {
    translate([-7.6, -1.05]) square([15.2, 4.1]);
    translate([-5.1, -3.05]) square([10.2, 0.0001]);
  }
}

module rca(h=5) {
  translate([0, 0, -0.1]) cylinder(h, r=4.5);
}

module audio(h=5) {
  translate([0, 0, -0.1]) cylinder(h, r=3.25);
}

module xlr(h=5) {
  translate([0, 0, -0.1]) cylinder(d=22, h=h);
}

module toslink(h=5) {
  translate([0, 0, -0.1])
  linear_extrude(h)
    rsquare([10, 10], 0.65);
}
