res = 80;

ball_diameter = 5;

wheel_or = 2;
compression = 0.125;
hood_ir = wheel_or - compression + ball_diameter; // Ball diameter
hood_thickness = 0.0625; // Assuming steel for now
hood_or = hood_ir + hood_thickness;

ball_channel_gap = 0.125;
divider_width = 0.25;
cim_divider_width = 0.25;

flywheel_region_width = 1.75;
hood_width = 2*(ball_diameter+ball_channel_gap) + 2*divider_width + 2*cim_divider_width + flywheel_region_width;

add_trans = 1.5;
hood_length = hood_or + add_trans; //Ensures covers all.

hood_angle = 90;

flywheel_rad = 5;
flywheel_thickness=0.5;

hex_bearing_or = 1.125/2;

cim_length = 4.34;
cim_rad = 1.25;

module hood() {
	color([.3,0.3,.3]) union() {
	    translate([0,-hood_width/2,hood_or]) rotate([-90])
	    linear_extrude(height = hood_width) intersection() {
	        difference() {
	            circle(hood_or, $fn=res);
	            circle(hood_ir, $fn=res);
	        }
	        rotate([0,0,90-hood_angle]) square([hood_or, hood_or]);
	        square([hood_or, hood_or]);
	    }
		translate([(-add_trans)/2,0])
		linear_extrude(height=hood_thickness)
		square([add_trans,hood_width],center=true);
	}
}

module divider_2d() {
	difference() {
		union() {
			union() {
				intersection() {
					circle(hood_ir, $fn=res);
					square([hood_ir, hood_ir]);
					rotate([0,0,hood_angle-90]) square([hood_ir, hood_ir]);
				}
				theta = acos(add_trans/hood_ir);
				polygon([[0,0],[cos(hood_angle)*hood_ir,sin(hood_angle)*hood_ir],[-add_trans*sin(theta), add_trans*cos(theta)]]);
			}
			translate([0,hood_or-hood_length]) square([hood_ir, add_trans]);
			intersection() {
				circle(add_trans, $fn=res);
			}
		}
		circle(hex_bearing_or, $fn=res);
	}
}
module divider() {
	color([.75,.65,0.56]) translate([0,0,hood_ir]) rotate([90,90,0]) translate([0,0,-divider_width/2])
	linear_extrude(height=divider_width) divider_2d();
}

module cim_mount_divider_2d() {
	difference() {
		union() {
			union() {
				intersection() {
					circle(hood_ir, $fn=res);
					square([hood_ir, hood_ir]);
					rotate([0,0,hood_angle-90]) square([hood_ir, hood_ir]);
				}
				theta = acos(add_trans/hood_ir);
				polygon([[0,0],[cos(hood_angle)*hood_ir,sin(hood_angle)*hood_ir],[-add_trans*sin(theta), add_trans*cos(theta)]]);
			}
			translate([0,hood_or-hood_length]) square([hood_ir, add_trans]);
			intersection() {
				circle(add_trans, $fn=res);
			}
		}
		circle(hex_bearing_or, $fn=res);
		for(i=[1:4]) rotate([0,0,90*i]) translate([1,0]) circle(0.1, $fn=res);
	}
}
module cim_mount_divider() {
	color([.75,.65,0.56]) translate([0,0,hood_ir]) rotate([90,90,0]) translate([0,0,-cim_divider_width/2])
	linear_extrude(height=cim_divider_width) cim_mount_divider_2d();
}

module wheel() {
	color([0,0,.6]) rotate([90,0]) translate([0,0,-0.5]) linear_extrude(height=1) difference() {
		circle(wheel_or, $fn=res);
		circle(0.5/sqrt(3), $fn=6);
	}
}

module flywheel() {
	color([0.6,0.6,.6]) rotate([90]) difference() {
		union() {
			cylinder(0.5, 5, 5, center=true, $fn=res);
			cylinder(flywheel_thickness+0.43, 1.125, 1.125, center=true, $fn=res);
			for(i=[1:6]) rotate([0,0,60*i]) translate([0.75,0]) cylinder(flywheel_thickness+0.8, 0.25/sqrt(3), 0.25/sqrt(3), center=true, $fn=6);
		}
		cylinder(3, 0.5/sqrt(3), 0.5/sqrt(3), center=true, $fn=6);
	}
}

module cim_motor() {
	color([0.15,0.15,0.15]) rotate([90,0]) cylinder(cim_length, cim_rad, cim_rad, center=true, $fn=res);
}

module axle() {
	color([0.3,0.3,0.3]) rotate([90,0]) cylinder(hood_width, .5/sqrt(3), .5/sqrt(3), center=true, $fn=6);
}

// This one is not parametric for fairly obvious reasons :(
// It does not fit on a single sheet, so I have it divided into two sheets to better use material.
module layout_dividers_2d() {
	translate([add_trans+.1, add_trans+.1]) mirror([-1,1]) divider_2d();
	translate([hood_or+.8, hood_or+1.2]) rotate([0,0,-60]) divider_2d();
}
module layout_cim_mount_dividers_2d() {
	translate([add_trans+.1, add_trans+.1]) mirror([-1,1]) cim_mount_divider_2d();
	translate([hood_or+.8, hood_or+1.2]) rotate([0,0,-60]) cim_mount_divider_2d();
}
module shooter() {

	hood();

	translate([0,divider_width+(ball_diameter+ball_channel_gap+flywheel_region_width)/2,hood_or]) wheel();
	translate([0,-divider_width-(ball_diameter+ball_channel_gap+flywheel_region_width)/2,hood_or]) wheel();

	translate([0,(flywheel_region_width+divider_width)/2,hood_thickness]) divider();
	translate([0,-(flywheel_region_width+divider_width)/2,hood_thickness]) divider();
	translate([0,(hood_width-cim_divider_width)/2,hood_thickness]) cim_mount_divider();
	translate([0,-(hood_width-cim_divider_width)/2,hood_thickness]) cim_mount_divider();

	translate([0,0,hood_or]) flywheel();

	translate([0,(hood_width+cim_length+.062)/2,hood_or]) cim_motor(); // flange thickness = .062
	translate([0,-(hood_width+cim_length+.062)/2,hood_or]) cim_motor(); // flange thickness = .062
    
    translate([0,0,hood_or]) axle();
}

// 1 = 2d dividers, 2 = 2d cim dividers, 3 = 3d
rndr = 3;
if(rndr == 1) {
	layout_dividers_2d();
}
else if(rndr == 2) {
	layout_cim_mount_dividers_2d();
}
else if(rndr == 3) {
	shooter();
}