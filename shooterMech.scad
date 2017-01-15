res = 80;

ball_diameter = 5;

wheel_or = 2;
compression = 0.125;
hood_ir = wheel_or - compression + ball_diameter; // Ball diameter
hood_thickness = 0.0625; // Assuming steel for now
hood_or = hood_ir + hood_thickness;

ball_channel_gap = 0.125;
divider_width = 0.25;

flywheel_region_width = 1.75;
hood_width = 2 * (ball_diameter + ball_channel_gap) + 4 * divider_width + flywheel_region_width;

add_trans = 1.5;
hood_length = hood_or + add_trans; //Ensures covers all.

hood_angle = 90;

flywheel_rad = 5;
flywheel_thickness=0.5;

module hood() {
	union() {
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

module divider(rad) {
	hex_bearing_or = 1.125/2;

	translate([0,0,hood_ir]) rotate([90,90,0]) translate([0,0,-divider_width/2])
	linear_extrude(height=divider_width) difference() {
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

module wheel() {
	rotate([90,0]) translate([0,0,-0.5]) linear_extrude(height=1) difference() {
		circle(wheel_or, $fn=res);
		circle(0.5/sqrt(3), $fn=6);
	}
}

module flywheel() {
	rotate([90]) difference() {
		union() {
			cylinder(0.5, 5, 5, center=true, $fn=res);
			cylinder(flywheel_thickness+0.43, 1.125, 1.125, center=true, $fn=res);
			for(i=[1:6]) rotate([0,0,60*i]) translate([0.75,0]) cylinder(flywheel_thickness+0.8, 0.25/sqrt(3), 0.25/sqrt(3), center=true, $fn=6);
		}
		cylinder(3, 0.5/sqrt(3), 0.5/sqrt(3), center=true, $fn=6);
	}
}

cim_length = 4.34;
cim_rad = 1.25;
module cim_motor() {
	rotate([90,0]) cylinder(cim_length, cim_rad, cim_rad, center=true, $fn=res);
}

module axle() {
	rotate([90,0]) cylinder(hood_width, .5/sqrt(3), .5/sqrt(3), center=true, $fn=6);
}

module shooter() {

	hood();

	translate([0,divider_width+(ball_diameter+ball_channel_gap+flywheel_region_width)/2,hood_ir]) wheel();
	translate([0,-divider_width-(ball_diameter+ball_channel_gap+flywheel_region_width)/2,hood_ir]) wheel();

	translate([0,(flywheel_region_width+divider_width)/2]) divider();
	translate([0,-(flywheel_region_width+divider_width)/2]) divider();
	translate([0,(hood_width-divider_width)/2]) divider();
	translate([0,-(hood_width-divider_width)/2]) divider();

	translate([0,0,hood_or]) flywheel();

	translate([0,(hood_width+cim_length+.062)/2,hood_or]) cim_motor(); // flange thickness = .062
	translate([0,-(hood_width+cim_length+.062)/2,hood_or]) cim_motor(); // flange thickness = .062
    
    translate([0,0,hood_or]) axle();
}

shooter();