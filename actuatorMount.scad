$fn = 50;

side = 0.551181;

difference() {
    union() {
        cylinder(r=0.375,h=0.375);
        translate([0,-0.375]) cube([0.75+0.375,0.75,0.375]);

        translate([0.375 + (0.75-side)/2,-0.375,0]) cube([side+(0.75-side)/2,0.75,0.8125]);
        
        hull() {
            translate([0,0,0.4375]) cylinder(r=0.375,h=0.375);
            translate([0,-0.375,0.4375]) cube([0.75,0.75,0.375]);
        }
    }
    
    translate([0.375 + (0.75-side)/2,-5,0.125]) cube([side,10,side]);

    
    cylinder(r=0.5/sqrt(3),h=0.25,$fn=6);
    cylinder(r=0.125,h=4);
   translate([0,0,0.625]) cylinder(r=0.3,h=4);
}

