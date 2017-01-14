$fn=100;


module pulley() {
    //render(convexity=2)
    difference() {
        union() {
            rotate([-90,0,0]) cylinder(r=1,h=0.0625);
            rotate([-90,0,0]) cylinder(r=0.875,h=0.5);
            translate([0,0.4375,0]) rotate([-90,0,0]) cylinder(r=1,h=0.0625);
        } difference() {
            scale(0.0393701) import("windowMotor.stl");
            translate([0,0.25,0]) rotate([-90,0,0]) cylinder(r=10,h=10);
        } translate([0.635,0.25,-5]) cylinder(r=0.05,h=10);
        rotate([-90,0,0]) cylinder(r=0.125,h=10);
    }
}

module igus(length) {
    linear_extrude(length) scale(0.0393701) import("igusProfile.dxf");
}

height = 3;
screwHeight = height;
screwWidth = 0.375;
innerScrewWidth = 0.2;
xScrewDisplacement = 1.25;
yScrewDisplacement = 1.5;
carriageHeight = 0.875;


module screwPocket() {
    rotate([90,0,0]) cylinder(r=screwWidth/2,h=10);
    translate([0,10-screwHeight,0]) rotate([90,0,0]) cylinder(r=innerScrewWidth/2,h=10);
    translate([-screwWidth/2,-screwHeight,0]) cube([screwWidth,screwHeight,10]);
}

module base() {
    difference() {
        union() {
            cylinder(r=1.75,h=1);
            translate([-1.375,0,0]) cube([3.125,1.75+height,1]);
        } translate([-1.375,-5,-1]) rotate([0,0,90]) cube([10,10,10]);
        translate([0,0,0.125]) cylinder(r=0.25,h=10);
        translate([0,0,-1]) cylinder(r=0.1875,h=10);
        
        
        translate([0,height+1.5,0.5]) {
            translate([0.1875+1.25,0,0]) screwPocket();
            translate([0.1875-1.25,0,0]) screwPocket();
        }

    }
}
//


color([0.5,0.5,0.5]) translate([-0.25,0,0.75+carriageHeight]) rotate([270,0,90]) igus(10);

difference() {
    union() {
        translate([0,0,carriageHeight]) base();

        translate([0,-xScrewDisplacement,0]) cylinder(r=0.25,h=carriageHeight);
        translate([0,xScrewDisplacement,0]) cylinder(r=0.25,h=carriageHeight);
        translate([yScrewDisplacement,0,0]) cylinder(r=0.25,h=carriageHeight);
    }
    
    translate([0,-xScrewDisplacement,-1]) cylinder(r=0.126,h=10);
        translate([0,xScrewDisplacement,-1]) cylinder(r=0.126,h=10);
        translate([yScrewDisplacement,0,-1]) cylinder(r=0.126,h=10);
    
}


//0.1875 hole
//0.125 height
