res = 80;

ball_diameter = 5;

wheel_or = 2;
compression = 0.125;
hood_ir = wheel_or - compression + ball_diameter; // Ball diameter
hood_thickness = 0.0625; // Assuming steel for now
hood_or = hood_ir + hood_thickness;

ball_channel_gap = 0.125;
divider_width = 0.125;

hood_width = 2 * (ball_diameter + ball_channel_gap) + 3 * divider_width;

add_trans = 1;
hood_length = hood_or + add_trans; //Ensures covers all.

module hood() {
	union() {
	    translate([0,-hood_width/2,hood_or]) rotate([-90])
	    linear_extrude(height = hood_width) intersection() {
	        difference() {
	            circle(hood_or, $fn=res);
	            circle(hood_ir, $fn=res);
	        }
	        square([hood_or, hood_or]);
	    }
		translate([(-add_trans)/2,0])
		linear_extrude(height=hood_thickness)
		square([add_trans,hood_width],center=true);
	}
}

//hood();

module divider(rad) {
	hex_bearing_or = 1.125/2;

	translate([0,0,hood_ir]) rotate([90,90,0]) translate([0,0,-divider_width/2])
	linear_extrude(height=divider_width) difference() {
		union() {
			intersection() {
				circle(hood_ir, $fn=res);
				union() {
					square([hood_ir, hood_ir]);
					theta = acos(add_trans/hood_ir);
					polygon([[0,0],[0,hood_ir],[-add_trans*sin(theta), add_trans*cos(theta)]]);
				}
			}
			translate([0,hood_or-hood_length]) square([hood_ir, add_trans]);
			intersection() {
				circle(add_trans, $fn=res);
			}
		}
		circle(hex_bearing_or, $fn=res);
	}
}

//divider();

// odeled after complaint wheel (am3-480):
module wheel() {

}

module hex_axle(diameter, length) {
    cylinder(length, diameter/sqrt(3), diameter/sqrt(3), $fn=6);
}

module shooter() {
    
}