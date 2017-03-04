boltRad = 1.5/16;
$fn=100;

ext = .3125 + .5-(1/16);

sweepRad = 2;

color([1,0,0]) translate([0,-0.125]) difference() {
     cube([ext,0.25,1.75]);


    for (i=[0.25,0.875,1.5]) {
                translate([.5-(1/16),-5,i]) rotate([-90,0,0]) cylinder(r=boltRad,h=10);
    }
}

pushout = 2.5 - sweepRad;
sweepAngle = 15;
wall = 0.375;

cutoffAngle = 40;
cutoffWidth = 4;

translate([ext+sweepRad,0]) difference() {
    hull() {
        color([0,1,0]) translate([-sweepRad,-0.125,0]) cube([0.5,0.25,1.75]);
        translate([pushout,0]) cylinder(r=sweepRad,h=1.75);
    }
    
    translate([-sweepRad,0,1.75]) rotate([0,sweepAngle,0]) cylinder(r=10,h=10);
    
            translate([pushout,0,-1]) cylinder(r=sweepRad-wall,h=5);

    translate([pushout - (sweepRad-wall)*cos(cutoffAngle),(sweepRad-wall)*sin(cutoffAngle),-1]) rotate(-90-cutoffAngle) cube([10,cutoffWidth,10]);


}

