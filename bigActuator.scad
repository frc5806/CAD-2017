$fn=100;

bagBoltCircleRad = 0.984/2;
bagBoltRad = 0.0787;
bagBoltHeadRad = 0.18;

fitFactor = 0.01;

nutDiag = (9/16)/sqrt(3);

module base() {
    difference() {
        translate([0,0,0.5]) cube([1.5,1.5,1],center=true);
        translate([0,0,0.625]) cube([1,1,1],center=true);

        for (i=[0,180,180]) {
            rotate(i) translate([bagBoltCircleRad,0,0]) {
                cylinder(r=bagBoltRad,h=0.25);
                translate([0,0,0.125]) cylinder(r=bagBoltHeadRad,h=10);
            }
        }
        
        translate([0.375,2,0.625]) rotate([90,0,0]) cylinder(r=0.125/2,h=10);
    translate([-0.375,2,0.625]) rotate([90,0,0]) cylinder(r=0.125/2,h=10);
        
        cylinder(r=0.3,h=10);

    }
}

module carriage() {
    difference() {
        linear_extrude(1.25) difference() {
            square([1-1/8-fitFactor,1-1/8-fitFactor],center=true);
        }
        
        linear_extrude(0.5) for (i=[0:90:360]) {
                rotate(i) translate([(1-1/8-fitFactor)/2,(1-1/8-fitFactor)/2]) circle(r=0.25);
            }
        
        translate([0,0,0.26]) {
            translate([0,5,0]) cube([9/16,10,21/64],center=true);
            rotate(30) cylinder(r=nutDiag,h=21/64,$fn=6,center=true);
        }
        
        translate([0,0,0.75]) linear_extrude(10) difference() {
            square([3/4,3/4],center=true);
            square([3/4-1/8,3/4-1/8],center=true);
        }
        
        cylinder(r=1.6/8,h=10);
        
        translate([0.5-(1/16)-fitFactor/2,0,0.25]) rotate([-90,0,90]) cylinder(r=0.125,h=0.125);
    }
}

module igusBolts(r=0.125) {
    // bolt rectange: 87mm,60mm
    igusX = 3.4252;
    igusY = 2.3622;
    translate([igusX/2,igusY/2]) circle(r);
    translate([-igusX/2,-igusY/2]) circle(r);
    translate([-igusX/2,igusY/2]) circle(r);
    translate([igusX/2,-igusY/2]) circle(r);
}


height = 0;

minHeight = 0.25;

nutClearanceRad = 0.5;
nutClearanceLength = 1.5;

edgeAddition = 0.625;

mountAngle = 30;

module igusMount() {
    difference() {
        union() {
            translate([-1-(height/2),0,0.5]) cube([3.4252+edgeAddition+2+height,2.3622+edgeAddition,1],center=true);
            
        }
        
        translate([-(3.4252+edgeAddition)/2,-3,1]) rotate([0,atan((1-minHeight)/(3.4252+edgeAddition)),0]) cube([10,10,10]);
        
        translate([-(3.4252+edgeAddition)/2,nutClearanceLength/2,0]) rotate([90,0,0]) cylinder(r=nutClearanceRad,h=nutClearanceLength);

        translate([0,0,-1]) linear_extrude(5) igusBolts();
        
        translate([0,0,0.25]) linear_extrude(5) igusBolts(r=0.25);
        
        translate([-height-0.75-(3.4252+edgeAddition)/2,0.5]) rotate([180,90+mountAngle,0]) translate([0,0,-1]) cube([1,1,20]);
        
        translate([-1-height-(3.4252+edgeAddition)/2,-(2.3622+edgeAddition)/2,0]) rotate([0,180,0]) {
                translate([0.5,1+(2.3622+edgeAddition)/2,-5]) cylinder(r=0.125,h=10);
            translate([0.5,-1+(2.3622+edgeAddition)/2,-5]) cylinder(r=0.125,h=10);
        }
        
          translate([-1-height-(3.4252+edgeAddition)/2,-(2.3622+edgeAddition)/2]) rotate([0,180,0]) {
            hexRad = (7/16)/sqrt(3) + 0.01;
            translate([0.5,1+(2.3622+edgeAddition)/2,1.75-12.25]) cylinder(r=hexRad,h=10,$fn=6);
            translate([0.5,-1+(2.3622+edgeAddition)/2,1.75-12.25]) cylinder(r=hexRad,h=10,$fn=6);
        }
    }
}

module actuatorClamp() {
    difference() {
        translate([-1-height-(3.4252+edgeAddition)/2,-(2.3622+edgeAddition)/2,0]) rotate([0,180,0]) {
            difference() {
                cube([1,2.3622+edgeAddition,1.25]);
                
                translate([0.5,1+(2.3622+edgeAddition)/2,-5]) cylinder(r=0.125,h=10);
                translate([0.5,-1+(2.3622+edgeAddition)/2,-5]) cylinder(r=0.125,h=10);
            }
        }

        translate([-height-0.75-(3.4252+edgeAddition)/2,0.5]) rotate([180,90+mountAngle,0]) translate([0,0,-1]) cube([1,1,20]);
    }
}



actuatorClamp();
igusMount();
//carriage();
//base();


