$fn = 100;

bridgeWidth = 30;
bridgeHeight = 6;

shaftHeight = 4;

module bridge() {
    color([0.3,0.3,0.3]) difference() {
        union() {
            cube([0.5,1,bridgeHeight]);
            translate([0,0,bridgeHeight-0.5]) cube([bridgeWidth,1,0.5]);
            translate([bridgeWidth-0.5,0,0])cube([0.5,1,bridgeHeight]);
        }
        
        translate([-1,0.5,shaftHeight]) rotate([0,90,0]) cylinder(r=6/16,h=100);

        
    }
}

module igusBushing() {
    bore = 5/16;
    
    color([1,0.99,0.815]) difference() {
        translate([0,0,-1/16]) union() {
            cylinder(r=bore+1/8,h=1/16);
            cylinder(r=bore+1/16,h=3/8);
        }
        translate([0,0,-0.5])cylinder(r=bore,h=2);

    }
}

bridge();
translate([0,0.5,shaftHeight]) rotate([0,90,0]) igusBushing();
translate([bridgeWidth,0.5,shaftHeight]) rotate([0,270,0]) igusBushing();
color([0.5,0.5,0.5]) translate([-0.5,0.5,shaftHeight]) rotate([0,90,0]) cylinder(r=5/16,h=bridgeWidth+0.5+1/16);

