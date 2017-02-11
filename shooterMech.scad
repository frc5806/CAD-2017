res = 240;

ball_diameter = 5;

wheel_or = 2;
wheel_thickness = 1;
compression = 0.3125;
hood_ir = wheel_or - compression + ball_diameter; // Ball diameter
echo("Hood IR", hood_ir);
hood_thickness = 0.125;
hood_or = hood_ir + hood_thickness;

ball_channel_gap = 1/16;
divider_width = 0.125;
cim_divider_width = .125;

flywheel_rad = 5;
flywheel_thickness=0.5;
flywheel_region_width = 1.75;
hood_width = 2*(ball_diameter+ball_channel_gap) + 2*divider_width + 2*cim_divider_width + flywheel_region_width;
echo("Hood width", hood_width);

add_trans = 1.5;
hood_length = hood_or + add_trans; //Ensures covers all.

hood_angle = 90;

hex_bearing_or = 1.12/2;
flange_thickness = .062;

feeder_center_rad = .75;
feeder_spoke_length = 5.125;
feeder_spoke_width = 0.5;
required_feeder_rad = feeder_center_rad + feeder_spoke_length + 0.25; // +gap
feeder_num_spokes = 4;
feeder_thickness = 2;
feeder_bottom_gap = 0.5;

tank_wall_height = 5;

cim_length = 4.34;
cim_rad = 1.25;
versa_length = 1.654;
versa_width = 1.75;
versa_thick = 2.363;
versa_z_trans = hood_ir-(feeder_thickness+feeder_bottom_gap);
versa_holder_thick = tank_wall_height-(feeder_thickness+feeder_bottom_gap);

tank_wall_thickness = 0.125;
tank_front_thickness = tank_wall_thickness;

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

tfw_rlvnt_flywheel_rad = flywheel_rad + 0.25; //Safety gap.
tfw_f_width = flywheel_thickness + 0.25;
tfw_f_length = 2*flywheel_rad+0.125;
tfw_rlvnt_wheel_rad = wheel_or + 0.75; // Safety gap.
tfw_w_width = wheel_thickness + 0.25; // Safety gap.
tfw_w_length = 2*tfw_rlvnt_wheel_rad*sin(acos(add_trans/tfw_rlvnt_wheel_rad));
tfw_width = fuel_tank_base_width-2*(tank_wall_thickness+required_feeder_rad);
tfw_length = 2*hood_ir;
tfw_b_width = ball_channel_gap+ball_diameter;
tfw_b_length = ball_diameter + 0.25; // Gotta have a bit of space for the ball to pass through.
tfw_bottom_extension = 1+hood_thickness;
module tank_front_wall_2d() {
    hole_rad = 3/16;
    hole_dist = 1/2;
	difference() {
        // Main piece.
		translate([tfw_bottom_extension/2,0]) square([tfw_length+tfw_bottom_extension,tfw_width],center=true);
        // Wheel openings
		translate([tfw_length/2-hood_ir,sh_wh_yt]) square([tfw_w_length,tfw_w_width],center=true);
		translate([tfw_length/2-hood_ir,-sh_wh_yt]) square([tfw_w_length,tfw_w_width],center=true);
        // Flywheel opening
		translate([tfw_length/2-hood_ir,0]) square([tfw_f_length,tfw_f_width],center=true);
        // Ball channel openings
		translate([tfw_length/2-tfw_b_length/2,sh_wh_yt]) square([tfw_b_length,tfw_b_width],center=true);
		translate([tfw_length/2-tfw_b_length/2,-sh_wh_yt]) square([tfw_b_length,tfw_b_width],center=true);
        // Cim divider slots.
		translate([tfw_length/2-feeder_thickness-feeder_bottom_gap-versa_holder_thick/2,sh_cdiv_yt]) square([versa_holder_thick,divider_width],center=true);
		translate([tfw_length/2-feeder_thickness-feeder_bottom_gap-versa_holder_thick/2,-sh_cdiv_yt]) square([versa_holder_thick,divider_width],center=true);
        // Inner divider slots.
		translate([tfw_length/2-tank_wall_height/2,sh_div_yt]) square([tank_wall_height,divider_width],center=true);
		translate([tfw_length/2-tank_wall_height/2,-sh_div_yt]) square([tank_wall_height,divider_width],center=true);
        // Bottom holes.
        translate([tfw_length/2+tfw_bottom_extension-hole_dist,0]) circle(hole_rad, $fn=res);
        translate([tfw_length/2+tfw_bottom_extension-hole_dist,-tfw_width/2+hole_dist]) circle(hole_rad, $fn=res);
        translate([tfw_length/2+tfw_bottom_extension-hole_dist,tfw_width/2-hole_dist]) circle(hole_rad, $fn=res);
        // Additional weight-saving cutouts.
        ws_width = tfw_width/2-flywheel_region_width/2-divider_width;
        ws_length = tfw_length-hood_ir-tfw_w_length/2-0.75;
        translate([-tfw_length/2,-tfw_width/2]) square([ws_length,ws_width]);
        translate([-tfw_length/2,tfw_width/2-ws_width]) square([ws_length,ws_width]);
	}
}
//tank_front_wall_2d();
module tank_front_wall() {
    color([1,1,1]) translate([0,0,tfw_length/2]) rotate([0,90]) translate([0,0,-tank_front_thickness/2]) 
	linear_extrude(height=tank_front_thickness) tank_front_wall_2d();
}
module tank_side_wall() {
	color([.3,0.3,.3]) linear_extrude(height=tank_wall_height) difference() {
		circle(required_feeder_rad+tank_wall_thickness, $fn=res);
		circle(required_feeder_rad, $fn=res);
		square([required_feeder_rad+tank_wall_thickness,required_feeder_rad+tank_wall_thickness]);
	}
}
module fuel_tank() {
	fuel_tank_base_plate();

	translate([0,(hood_width+versa_width)/2,fuel_tank_base_thickness+feeder_bottom_gap]) feeder();
	translate([0,-(hood_width+versa_width)/2,fuel_tank_base_thickness+feeder_bottom_gap]) feeder();

	translate([0,divider_width+required_feeder_rad+flywheel_region_width/2,fuel_tank_base_thickness+feeder_bottom_gap+feeder_thickness]) bag_gearmotor();
	translate([0,-(divider_width+required_feeder_rad+flywheel_region_width/2),fuel_tank_base_thickness+feeder_bottom_gap+feeder_thickness]) bag_gearmotor();

	translate([fuel_tank_base_length/2-tank_front_thickness/2,0,fuel_tank_base_thickness]) tank_front_wall();

	translate([0,required_feeder_rad+tank_wall_thickness-fuel_tank_base_width/2,fuel_tank_base_thickness]) tank_side_wall();
	translate([0,-(required_feeder_rad+tank_wall_thickness-fuel_tank_base_width/2),fuel_tank_base_thickness]) mirror([0,1]) tank_side_wall();
}

module hood_2d() {
    intersection() {
        difference() {
            circle(hood_or, $fn=res);
            circle(hood_ir, $fn=res);
        }
        rotate([0,0,90-hood_angle]) square([hood_or, hood_or]);
        square([hood_or, hood_or]);
    }
    translate([-add_trans,hood_ir]) square([add_trans,hood_thickness]);
}
module hood() {
	color([.3,0.3,.3]) translate([0,-hood_width/2,hood_or]) rotate([-90]) linear_extrude(height=hood_width) hood_2d();
}

module divider_2d() {
	difference() {
		union() {
			intersection() {
                circle(hood_ir, $fn=res);
                translate([-hood_ir,0]) square([2*hood_ir, hood_ir]);
            }
			translate([-hood_ir,hood_or-hood_length]) square([2*hood_ir, add_trans]);
			translate([hood_ir-tank_wall_height,-fuel_tank_base_length/2-add_trans]) square([tank_wall_height, fuel_tank_base_length/2]);
		}
		circle(hex_bearing_or, $fn=res);
	}
}
module divider() {
	color([.75,.65,0.56]) translate([0,0,hood_ir]) rotate([90,90,0]) translate([0,0,-divider_width/2])
	linear_extrude(height=divider_width) divider_2d();
}

module cim_mount_divider_2d() {
	versa_bolt_l = 1.0;
	versa_bolt_t = 1.75;
	versa_bolt_rad = 0.19/2;
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
            ext_length = required_feeder_rad+tank_wall_thickness+versa_length/2;
			translate([versa_z_trans-versa_thick/2,-add_trans-ext_length/2])
			difference() {
				translate([(versa_thick-versa_holder_thick)/2,0]) square([versa_holder_thick,ext_length], center=true);
				translate([versa_bolt_t/2,(versa_length-versa_bolt_l-ext_length)/2]) circle(versa_bolt_rad, $fn=res);
				translate([-versa_bolt_t/2,(versa_length+versa_bolt_l-ext_length)/2]) circle(versa_bolt_rad, $fn=res);
				translate([versa_bolt_t/2,(versa_length+versa_bolt_l-ext_length)/2]) circle(versa_bolt_rad, $fn=res);
				translate([-versa_bolt_t/2,(versa_length-versa_bolt_l-ext_length)/2]) circle(versa_bolt_rad, $fn=res);
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
	color([0,0,.6]) rotate([90,0]) translate([0,0,-wheel_thickness/2]) linear_extrude(height=wheel_thickness) difference() {
		circle(wheel_or, $fn=res);
		circle(0.5/sqrt(3), $fn=6);
	}
}

module flywheel() {
	color([0.6,0.6,.6]) rotate([90]) difference() {
		union() {
			cylinder(0.5, 5, 5, center=true, $fn=res);
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
	rotate(180) translate([add_trans-8.5, add_trans-8.5]) mirror([-1,1]) divider_2d();
    mirror([-1,1]) translate([hood_or-2.8, hood_or+9.95]) rotate([0,0,0]) divider_2d();
}
module layout_cim_mount_dividers_2d() {
    gap = 0.125;
    theta = 100;
    translate([11.6,4.4]) rotate([0,0,theta]) union() {
        translate([tank_wall_height+gap/2-hood_ir,add_trans+(required_feeder_rad+tank_wall_thickness)/2]) cim_mount_divider_2d();
        rotate([0,0,180]) translate([tank_wall_height+gap/2-hood_ir,add_trans+gap+(required_feeder_rad+tank_wall_thickness+versa_length)/2]) cim_mount_divider_2d();
    }
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
function flatten(l) = [for(a=l) for(b=a) b] ;
function cat(l1, l2) = [for(i=[0:len(l1)+len(l2)-1]) i<len(l1)?l1[i]:l2[i-len(l1)]];
module zig_zag(l, n, d, b) {
    poly1 = flatten([for(i=[0:2*l/n-1]) [[-l+i*n,i%2==0?-d/2:d/2],[-l+(i+1)*n,i%2==0?-d/2:d/2]]]);
    poly2 = b?[[l,100],[-l,100]]:[[l,-100],[-l,-100]];
    poly = cat(poly1,poly2);
    polygon(poly);
}
//*
rndr = 9;
if(rndr == 1) {
    layout_dividers_2d();
}
else if(rndr == 2) {
    layout_cim_mount_dividers_2d();
}
else if(rndr == 3) {
	shooter();
    translate([-add_trans-fuel_tank_base_length/2,0]) fuel_tank();
}
else if(rndr == 4){
    layout_dividers_2d();
    layout_cim_mount_dividers_2d();
}
else if(rndr == 5) {
    mirror([-1,1]) {
        translate([3.6,17.2]) cim_mount_divider_2d();
        translate([6.8,6.8]) rotate([0,0,180]) cim_mount_divider_2d();
        translate([17.3,17.2]) divider_2d();
        translate([17.3,7.6]) rotate([0,0,180]) divider_2d();
        translate([7,31.2]) tank_front_wall_2d();
    }
}
else if(rndr == 6) {
    intersection() {
        tank_front_wall_2d();
        zig_zag(20,.41,.41,true); 
    }
}
else if(rndr == 7) {
    intersection() {
        tank_front_wall_2d();
        zig_zag(20,.41,.41,false);
    }
}
else if(rndr == 8) {
    translate([add_trans,0]) hood_2d();
}
else if(rndr == 9) {
	hood();

	translate([0,sh_div_yt,hood_thickness]) divider();
	translate([0,-sh_div_yt,hood_thickness]) divider();
	translate([0,sh_cdiv_yt,hood_thickness]) cim_mount_divider();
	translate([0,-sh_cdiv_yt,hood_thickness]) cim_mount_divider();
    
    translate([-tank_front_thickness/2-add_trans,0,fuel_tank_base_thickness]) tank_front_wall();
}
//*/
