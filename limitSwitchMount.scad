$fn = 30;

boltRad = 0.2010/2;

switchWidth = 5/8;
switchHeight = 9/8;

switchPush = 13/16;

boltDifY = 0.88;
boltDifX = 0.41;

screwRad = 0.138/2;

difference() {
    hull() {
        cube([3/8,1,0.75]);
        translate([1.5/8,1.5-(1.5/8)]) cylinder(r=1.5/8,h=0.75);
    }
    
    translate([0,0.125,0.125]) cube([3/8,1,0.5]);
    
    translate([1.5/8,1.5-(1.5/8),0]) cylinder(r=boltRad); 
    
    translate([0,1,0.4]) cube([10,10,(1/32)]);

}

module screwHole(x,y) { 
        translate([x,-0.125,y-(switchHeight-(0.75))/2]) rotate([90,0,0]) cylinder(r=screwRad,h=10);
    }

difference() {
    hull() {
        cube([3/8,0.001,0.75]);

        translate([0,0.125+(2.5/16)-switchPush,-(switchHeight-(0.75))/2]) cube([switchWidth,0.001,switchHeight]);
    }
    
    screwHole(switchWidth/2 - boltDifX/2,switchHeight/2 - boltDifY/2);
    screwHole(switchWidth/2 + boltDifX/2,switchHeight/2 - boltDifY/2);
    screwHole(switchWidth/2 - boltDifX/2,switchHeight/2 + boltDifY/2);
    screwHole(switchWidth/2 + boltDifX/2,switchHeight/2 + boltDifY/2);
}