res = 80;

module gear_2d(r, tooth, teeth, ot, cr, ns, sw) {
    difference() {
        union() {
            circle(r, $fn=res);
            for(i=[1:teeth]) rotate([0,0,360*i/teeth]) translate([r,0]) polygon(tooth);
        }
        circle(r-ot, $fn=res);
    }
    circle(cr, $fn=res);
    for(i=[1:ns]) rotate([0,0,360*(i-.5)/ns]) translate([0,-sw/2]) square([r-ot,sw]);
}

function tooth(dx, dy) = [
    [-.1,-dy],
    [-.1,dy],
    [dx/2,dy],
    [3*dx/4,3*dy/4],
    [9*dx/10,3*dy/5],
    [dx,dy/4],
    [dx,-dy/4],
    [9*dx/10,-3*dy/5],
    [3*dx/4,-3*dy/4],
    [dx/2,-dy]
    ];

module gearmotor_d() {
    difference() {
        circle(3/25.4, $fn=res);
        translate([52.5/25.4,0]) square([100/25.4,100/25.4], center=true);
    }
}


module gearmotor_gear() {
    difference() {
        gear_2d(1, tooth(0.24,0.09), 18, 0.15, 0.3, 6, 0.2);
        gearmotor_d();
    }
}
module axle_gear() {
    difference() {
        gear_2d(1, tooth(0.24,0.09), 18, 0.15, 0.48, 6, 0.2);
        circle(0.5/sqrt(3), $fn=6);
    }
}
linear_extrude(height=0.25) union() {
    axle_gear();
    translate([2.27,0]) rotate([0,0,10]) gearmotor_gear();
}