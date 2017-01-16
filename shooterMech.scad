res = 80;

ball_diameter = 5;

wheel_or = 2;
wheel_thickness = 1;
compression = 0.125;
hood_ir = wheel_or - compression + ball_diameter; // Ball diameter
hood_thickness = 0.0625; // Assuming steel for now
hood_or = hood_ir + hood_thickness;

ball_channel_gap = 0.125;
divider_width = 0.25;
cim_divider_width = 0.25;

flywheel_rad = 5;
flywheel_thickness=0.5;
flywheel_region_width = 1.75;
hood_width = 2*(ball_diameter+ball_channel_gap) + 2*divider_width + 2*cim_divider_width + flywheel_region_width;

add_trans = 1.5;
hood_length = hood_or + add_trans; //Ensures covers all.

hood_angle = 90;

hex_bearing_or = 1.125/2;
flange_thickness = .062;

cim_length = 4.34;
cim_rad = 1.25;
versa_length = 1.654;
versa_width = 1.75;
versa_thick = 2.363;

tank_wall_thickness = 0.125;
tank_wall_height = 5;
tank_front_thickness = 0.125;

feeder_center_rad = .75;
feeder_spoke_length = 5.25;
feeder_spoke_width = 0.5;
required_feeder_rad = feeder_center_rad + feeder_spoke_length + 0.25; // +gap
feeder_num_spokes = 4;
feeder_thickness = 2;
feeder_bottom_gap = 0.5;

fuel_tank_base_width = hood_width+2*(versa_width/2+required_feeder_rad+tank_wall_thickness);
fuel_tank_length_extension = 4;
fuel_tank_base_length = 2*required_feeder_rad+2*tank_wall_thickness;
fuel_tank_base_thickness = hood_thickness;

// TRANSLATION DISTANCES:
sh_wh_yt = divider_width+(ball_diameter+ball_channel_gap+flywheel_region_width)/2;
sh_div_yt = (flywheel_region_width+divider_width)/2;
sh_cdiv_yt = (hood_width-cim_divider_width)/2;
sh_c_yt = (hood_width+cim_length+flange_thickness)/2;

// 0=nothing, 1 = 2d dividers, 2 = 2d cim dividers, 3 = 3d
rndr = 3;

// Centered by default
module rounded_rect(dimensions, rad) {
	hull() {
		translate([dimensions[0]/2-rad,dimensions[1]/2-rad]) circle(rad, $fn=res);
		translate([dimensions[0]/2-rad,rad-dimensions[1]/2]) circle(rad, $fn=res);
		translate([rad-dimensions[0]/2,dimensions[1]/2-rad]) circle(rad, $fn=res);
		translate([rad-dimensions[0]/2,rad-dimensions[1]/2]) circle(rad, $fn=res);
	}
}

module fuel_tank_base_plate() {
	color([1,1,1]) linear_extrude(height=fuel_tank_base_thickness)
		rounded_rect([fuel_tank_base_length,fuel_tank_base_width], required_feeder_rad+tank_wall_thickness);
}

module feeder() {
	color([0.5,0,0]) linear_extrude(height=feeder_thickness) union() {
		circle(feeder_center_rad, $fn=res);
		for(i=[1:feeder_num_spokes]) rotate([0,0,i*360/feeder_num_spokes])
		translate([(feeder_center_rad+feeder_spoke_length)/2,0])
		square([feeder_spoke_length+feeder_center_rad, feeder_spoke_width], center=true);
	}
}

module bag_gearmotor() {
	// 2 stages of versaplanetary.
	color([0.15,0.15,0.15]) union() {
		translate([0,0,versa_thick]) cylinder(2.795,.8,.8,$fn=res);
		translate([0,0,versa_thick/2]) cube([versa_length,versa_width,versa_thick], center=true); 
	}
}

module tank_wall() {
	linear_extrude(height=tank_wall_height) difference() {
		rounded_rect([fuel_tank_base_length,fuel_tank_base_width], required_feeder_rad);
		rounded_rect([fuel_tank_base_length-tank_wall_thickness,fuel_tank_base_width-tank_wall_thickness], required_feeder_rad);
		translate([tank_wall_thickness,0]) square([fuel_tank_base_length,hood_width],center=true);
	}
}

module tank_front_wall() {
	rlvnt_flywheel_rad = flywheel_rad + 0.25; //Safety gap.
	f_width = flywheel_thickness + 0.25;
	f_length = 2*rlvnt_flywheel_rad*sin(acos((tank_front_thickness+add_trans)/rlvnt_flywheel_rad));
	rlvnt_wheel_rad = wheel_or + 0.125; // Safety gap.
	w_width = wheel_thickness + 0.25; // Safety gap.
	w_length = 2*rlvnt_wheel_rad*sin(acos(add_trans/rlvnt_wheel_rad));
	width = fuel_tank_base_width-2*(tank_wall_thickness+required_feeder_rad);
	length = f_length/2 + hood_ir + 1; // Gotta have some material at the top.
	b_width = ball_channel_gap+ball_diameter;
	b_length = ball_diameter + 0.25; // Gotta have a bit of space for the ball to pass through.
	translate([0,0,length/2]) rotate([0,90]) translate([0,0,-tank_front_thickness/2]) 
	linear_extrude(height=tank_front_thickness) difference() {
		square([length,width],center=true);
		translate([length/2-hood_ir,sh_wh_yt]) square([w_length,w_width],center=true);
		translate([length/2-hood_ir,-sh_wh_yt]) square([w_length,w_width],center=true);
		translate([length/2-hood_ir,0]) square([f_length,f_width],center=true);
		translate([length/2-b_length/2,sh_wh_yt]) square([b_length,b_width],center=true);
		translate([length/2-b_length/2,-sh_wh_yt]) square([b_length,b_width],center=true);
	}
}

module tank_side_wall() {
	linear_extrude(height=tank_wall_height) difference() {
		circle(required_feeder_rad+tank_wall_thickness, $fn=res);
		circle(required_feeder_rad, $fn=res);
		square([required_feeder_rad+tank_wall_thickness,required_feeder_rad+tank_wall_thickness]);
	}
}

module feeder_inner_divider_2d() {
	fuel_safety_dist = 0;
	relvnt_ftbl = fuel_tank_base_length/2;
	theta = atan(hood_ir/(relvnt_ftbl+add_trans)) + asin((flywheel_rad+fuel_safety_dist)/sqrt(pow(relvnt_ftbl+add_trans,2)+pow(hood_ir,2)));
	polygon([[0,0],[-relvnt_ftbl,0],[-relvnt_ftbl,tank_wall_height],[0,tan(theta)*relvnt_ftbl]]);
}
module feeder_inner_divider() {
	color([.75,.65,0.56]) rotate([90,0]) translate([0,0,-divider_width/2])
	linear_extrude(height=divider_width) feeder_inner_divider_2d();
}

module fuel_tank() {
	fuel_tank_base_plate();

	translate([0,(hood_width+versa_width)/2,fuel_tank_base_thickness+feeder_bottom_gap]) feeder();
	translate([0,-(hood_width+versa_width)/2,fuel_tank_base_thickness+feeder_bottom_gap]) feeder();

	translate([0,divider_width+required_feeder_rad+flywheel_region_width/2,fuel_tank_base_thickness+feeder_bottom_gap+feeder_thickness]) bag_gearmotor();
	translate([0,-(divider_width+required_feeder_rad+flywheel_region_width/2),fuel_tank_base_thickness+feeder_bottom_gap+feeder_thickness]) bag_gearmotor();

	translate([fuel_tank_base_length/2-tank_front_thickness/2,0,fuel_tank_base_thickness]) tank_front_wall();

	//translate([fuel_tank_base_length/2,-(divider_width+flywheel_region_width)/2,fuel_tank_base_thickness]) feeder_inner_divider();
	//translate([fuel_tank_base_length/2,(divider_width+flywheel_region_width)/2,fuel_tank_base_thickness]) feeder_inner_divider();

	translate([0,required_feeder_rad+tank_wall_thickness-fuel_tank_base_width/2,fuel_tank_base_thickness]) tank_side_wall();
	translate([0,-(required_feeder_rad+tank_wall_thickness-fuel_tank_base_width/2),fuel_tank_base_thickness]) mirror([0,1]) tank_side_wall();
}

if(rndr == 3) translate([-add_trans-fuel_tank_base_length/2,0]) fuel_tank();

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
				theta = 90-acos(add_trans/hood_ir);
				polygon([[0,0],
					[cos(hood_angle)*hood_ir,sin(hood_angle)*hood_ir],
					[-(add_trans+sin(hood_angle)*hood_ir)*tan(theta), -add_trans],
					[0, -add_trans]]);
			}
			translate([0,hood_or-hood_length]) square([hood_ir, add_trans]);
			//circle(add_trans, $fn=res);
		}
		circle(hex_bearing_or, $fn=res);
	}
}
module divider() {
	color([.75,.65,0.56]) translate([0,0,hood_ir]) rotate([90,90,0]) translate([0,0,-divider_width/2])
	linear_extrude(height=divider_width) divider_2d();
}

module cim_mount_divider_2d() {
	versa_holder_thick = 2;
	difference() {
		union() {
			union() {
				intersection() {
					circle(hood_ir, $fn=res);
					square([hood_ir, hood_ir]);
					rotate([0,0,hood_angle-90]) square([hood_ir, hood_ir]);
				}
				theta = 90-acos(add_trans/hood_ir);
				polygon([[0,0],
					[cos(hood_angle)*hood_ir,sin(hood_angle)*hood_ir],
					[-(add_trans+sin(hood_angle)*hood_ir)*tan(theta), -add_trans],
					[0, -add_trans]]);
			}
			translate([0,hood_or-hood_length]) square([hood_ir, add_trans]);
			translate([hood_ir-(feeder_thickness+feeder_bottom_gap+versa_thick/2),-(add_trans+required_feeder_rad+tank_wall_thickness)/2])
				square([versa_holder_thick, add_trans+required_feeder_rad+tank_wall_thickness+versa_length],center=true);
		}
		circle(hex_bearing_or, $fn=res);
		for(i=[1:4]) rotate([0,0,90*i]) translate([1,0]) circle(0.1, $fn=res);
	}
}
//cim_mount_divider_2d();
module cim_mount_divider() {
	color([.75,.65,0.56]) translate([0,0,hood_ir]) rotate([90,90,0]) translate([0,0,-cim_divider_width/2])
	linear_extrude(height=cim_divider_width) cim_mount_divider_2d();
}

module wheel() {
	color([0,0,.6]) rotate([90,0]) translate([0,0,-wheel_thickness/2]) linear_extrude(height=wheel_thickness) difference() {
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

	translate([0,sh_wh_yt,hood_or]) wheel();
	translate([0,-sh_wh_yt,hood_or]) wheel();

	translate([0,sh_div_yt,hood_thickness]) divider();
	translate([0,-sh_div_yt,hood_thickness]) divider();
	translate([0,sh_cdiv_yt,hood_thickness]) cim_mount_divider();
	translate([0,-sh_cdiv_yt,hood_thickness]) cim_mount_divider();

	translate([0,0,hood_or]) flywheel();

	translate([0,sh_c_yt,hood_or]) cim_motor();
	translate([0,-sh_c_yt,hood_or]) cim_motor();
    
    translate([0,0,hood_or]) axle();
}

//*

if(rndr == 1) {
	layout_dividers_2d();
}
else if(rndr == 2) {
	layout_cim_mount_dividers_2d();
}
else if(rndr == 3) {
	shooter();
}
//*/