$fn = 30;

boltRad = 1.5/16;
headRad = 1.5/8;

module flankStructure(offset) {
    translate([offset,-0.25]) cube([0.75,0.5,1.75]);

}

module flankCutout(offset) {
    translate([offset,-0.25]) {
        translate([0,0.125,-0.0625]) cube([1,0.25,2]);
        
        for (i=[0.25,0.875,1.5]) {
            translate([.5-(1/16),-5,i]) rotate([-90,0,0]) cylinder(r=boltRad,h=10);
            
            translate([.5-(1/16),0,i]) rotate([90,0,0]) cylinder(r=headRad,h=10);
            
            translate([.5-(1/16),0.5,i]) rotate([-90,0,0]) cylinder(r=headRad,h=10);

        }
    }
}

module agitator(spokes=4) {
    difference() {
        for (i=[0:(360/spokes):360]) {
            rotate(i) hull() {
                cylinder(r=0.4,h=1.75);
                flankStructure(0.5); 
            }
        }
        
        cylinder(h=1.5+(1/16),r=0.28865,$fn=6);
        cylinder(r=0.125,h=10);

        for (i=[0:(360/spokes):360]) {
            rotate(i) flankCutout(0.5);
        }
    }
}

agitator(3);