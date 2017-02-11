res = 80;

feeder_center_rad = .75;
feeder_spoke_length = 5.25;
feeder_spoke_width = 0.5;
feeder_num_spokes = 5;
feeder_thickness = 2;

feeder_width = 0.5;

feeder_holder_length = .5;

module center_2d_frame() {
    theta = 180*(feeder_num_spokes-2)/feeder_num_spokes;
    rad = feeder_center_rad/sin(theta/2);
    wid = 2*feeder_center_rad/tan(theta/2);
    circle(rad, $fn=feeder_num_spokes);
    for(i=[1:feeder_num_spokes])  rotate([0,0,i*360/feeder_num_spokes]) translate([-feeder_center_rad-feeder_holder_length/2,0]) square([feeder_holder_length, wid], center=true);
}

module center_2d() {
    difference() {
        center_2d_frame();
        rotate([0,0,30]) circle(0.5/sqrt(3), $fn=6);
    }
}

center_2d();