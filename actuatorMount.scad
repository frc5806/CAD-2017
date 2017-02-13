$fn = 50;

side = 0.47;

module actuatorMount() {
    difference() {
        union() {
            cylinder(r=0.375,h=(0.5+.625)/2);
            translate([0,-0.375]) cube([0.75+0.375,0.75,(0.5+.625)/2]);

            translate([0.375 + (0.75-side)/2,-0.375,0]) cube([side+(0.75-side)/2,0.75,0.8125]);
            
            hull() {
                translate([0,0,0.6]) cylinder(r=0.375,h=0.212);
                translate([0,-0.375,0.6]) cube([0.75,0.75,0.212]);
            }
        }
        
        translate([0.375 + (0.75-side)/2,-5,0.1875]) cube([side,10,side]);

        
        cylinder(r=0.5/sqrt(3),h=0.375,$fn=6);
        cylinder(r=0.125,h=4);
    }
}

//actuatorMount();

module nettingMount(holes) {
    difference() {
        hull() {
            cylinder(r=0.35,h=0.75);
            translate([0,0,0.5]) cylinder(r=0.6,h=0.25);
        }
        
        cylinder(r=0.5/sqrt(3),h=0.5,$fn=6);
        cylinder(r=0.125,h=4);
        
        for (i=[0:360/holes:360]) {
        rotate(i )translate([0.48,0]) cylinder(r=0.125/2,h=10);
        }

    }
}

nettingMount(8);

