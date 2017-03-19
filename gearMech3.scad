res = 80;

gear_diam = 11;
gear_thick = 2;

gm_width = 16;
gm_length = 6;

shovel_thick = 0.03125;
top_thick = 0.25;
side_thick = 0.25;
ef_gear_thick = gear_thick+0.125; // Extra thickness

shovel_length = gm_length+side_thick;
shovel_width = gm_width+2*side_thick;

module shovel_2d() {
    translate([0,-shovel_width/2]) square([shovel_length, shovel_width]);
}
module shovel() {
    color([0.4,0.4,0.4]) linear_extrude(height=shovel_thick) shovel_2d();
}

module top_2d() {
    translate([0,-shovel_width/2]) square([shovel_length, shovel_width]);
}
module top() {
    color([0.75,0.65,0.56]) linear_extrude(height=top_thick) top_2d();
}

module back_2d() {
    square([ef_gear_thick, shovel_width], center=true);
}
module back() {
    color([0.75,0.65,0.56]) {
        rotate([0,-90,0]) translate([ef_gear_thick/2,0,-side_thick])
        linear_extrude(height=side_thick) back_2d();
    }
}

module side_2d() {
    square([gm_length,ef_gear_thick]);
}
module l_side() {
    color([0.75,0.65,0.56]) {
        rotate([90,0]) translate([0,0,-side_thick])
        linear_extrude(height=side_thick) side_2d();
    }
}
module r_side() {
    color([0.75,0.65,0.56]) {
        rotate([90,0])
        linear_extrude(height=side_thick) side_2d();
    }
}

module gearmech() {
    shovel();
    
    translate([side_thick,gm_width/2,shovel_thick]) l_side();
    translate([side_thick,-gm_width/2,shovel_thick]) r_side();

    translate([0,0,shovel_thick]) back();
    
    translate([0,0,shovel_thick+ef_gear_thick]) top();
}
gearmech();