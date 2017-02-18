$fn=100;

wall = 0.125;

flange = 0.5;

rotate([0,0,0]) difference() {
    intersection() {
        cube([3.75+wall,1.25+wall*2,7/8]);
translate([1.5,5,1+5/8+7/8]) rotate([90,0,0]) cylinder(r=2.5,h=10);
    
    }

translate([1.5,1.25+wall,1+5/8+7/8]) rotate([90,0,0]) cylinder(r=2.4,h=1.25);
    
    translate([3.28,-1,0]) cube([10,10,10]);

}


translate([0,-flange,6/8]) cube([3.28,flange,0.125]);

translate([0,1.25+2*wall,6/8]) cube([3.28,flange,0.125]);

translate([3.28,-flange,6/8]) cube([flange,1.5+flange*2,0.125]);
