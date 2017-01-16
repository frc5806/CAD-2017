$fn=100;

height = 0.5;
carriageHeight = 0.875;

module igus(length) {
    linear_extrude(length) scale(0.0393701) import("igusProfile.dxf");
}

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

module endCap() {
    screwHeight = height;
    screwWidth = 0.375;
    innerScrewWidth = 0.2;
    xScrewDisplacement = 1.25;
    yScrewDisplacement = 1.5;

    module screwPocket(l) {
        translate([0,0.5,0]) rotate([90,0,0]) cylinder(r=screwWidth/2,h=l);
        translate([0,10,0]) rotate([90,0,0]) cylinder(r=innerScrewWidth/2,h=10);
        translate([-screwWidth/2,-l+0.5,0]) cube([screwWidth,l,10]);
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
                translate([0.1875+1.25,-0.5,0]) screwPocket(screwHeight+1);
                translate([0.1875-1.25,-0.5,0]) screwPocket(screwHeight+0.5);
            }
            
            translate([-0.25,0,0.75]) rotate([270,0,90]) igus(10);


        }
    }

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
}

module igusBolts() {
    // bolt rectange: 87mm,60mm
    igusX = 3.4252;
    igusY = 2.3622;
    translate([igusX/2,igusY/2]) circle(0.125);
    translate([-igusX/2,-igusY/2]) circle(0.125);
    translate([-igusX/2,igusY/2]) circle(0.125);
    translate([igusX/2,-igusY/2]) circle(0.125);
}

innerRadius = 5.625;
outerRadius = 6;
upperExtension = outerRadius;

module boltU() {
    boltAngle = 20;
    boltRadius = 0.085; // 8-32 bolt
    boltDist = (innerRadius+outerRadius)*3.14*boltAngle/360;

    for (i=[0:boltAngle:180]) {
        rotate(-i) translate([(outerRadius+innerRadius)/2,0]) circle(boltRadius);
    }
        
    for (i=[0:boltDist:upperExtension]) {
        translate([(outerRadius+innerRadius)/2,i]) circle(boltRadius);
        translate([-(outerRadius+innerRadius)/2,i]) circle(boltRadius);
    }
}

module butterSheet() {
    difference() {
        union() {
            circle(outerRadius);
            
            translate([innerRadius,0]) square([outerRadius-innerRadius,upperExtension]);
            translate([-outerRadius,0]) square([outerRadius-innerRadius,upperExtension]);
        }
        
        circle(innerRadius);
        translate([-innerRadius,0]) square([innerRadius*2,20]);
        translate([0,-20]) square([100,100]);
        boltU();
    }   
}

module breadSheet(split) {
    filletRadius = 2;
    difference() {
        union() {
            circle(outerRadius);
            
            translate([innerRadius,0]) square([outerRadius-innerRadius,upperExtension]);
            translate([-outerRadius,0]) square([outerRadius-innerRadius,upperExtension]);
        }
            
        translate([-innerRadius,0]) square([innerRadius*2,20]);
        boltU();
        
        if (split) {
            translate([-1.72-0.255906,3-innerRadius]) igusBolts();
            translate([0,-50]) square([100,100]);
        } else {
            translate([0,3-innerRadius]) igusBolts();
        }
    } difference() {
        translate([-innerRadius,0]) square([filletRadius,filletRadius]);
        translate([filletRadius-innerRadius,filletRadius]) circle(filletRadius);
    } if (!split) difference() {
        translate([innerRadius-filletRadius,0]) square([filletRadius,filletRadius]);
        translate([innerRadius-filletRadius,filletRadius]) circle(filletRadius);
    }
}

module onionsHaveLayers(layers=18) {    
    translate([6.125,6.125]) for (i=[0:layers/2]) {
        translate([0.4*i,0.4*i]) butterSheet();
    }
    
    translate([1+layers*0.5,13+layers*0.5])rotate(180) translate([6.125,6.125]) for (i=[0:layers/2]) {
        translate([0.4*i,0.4*i]) butterSheet();
    }
}

module cuttingTable(split=false) {
    if (!split) {
        translate([6,6]) breadSheet(split=split);
        translate([6,15]) breadSheet(split=split);
    } else {
        translate([-2,5]) rotate(-45) { 
            translate([6,6]) breadSheet(split=true);
            translate([1,6.75]) rotate(180) breadSheet(split=true);
        }         translate([-2,13.65]) rotate(-45) { 
            translate([6,6]) breadSheet(split=true);
            translate([1,7.5]) rotate(180) breadSheet(split=true);
        }
    }
}

<<<<<<< HEAD
cuttingTable(false);
=======
module renderSystem(split=false) {
    length=24;

    translate([0,0,1.75+height]) rotate([-90,0,0]) {
        endCap();
        translate([-0.5 - length,0,0]) mirror([1,0,0]) endCap();
        color([0.5,0.5,0.5]) translate([-0.25,0,0.75+carriageHeight]) rotate([270,0,90]) igus(length);
        
        if (split) {
            translate([1-length/2,-2.5,0.5]) rotate(180) linear_extrude(0.25) breadSheet(split=true);
            translate([-1-length/2,-2.5,0.5]) rotate(180) linear_extrude(0.25) mirror([1,0]) breadSheet(split=true);
            translate([1-length/2,-2.5,-1.75]) rotate(180) linear_extrude(2.25) butterSheet();
            translate([-1-length/2,-2.5,-1.75]) rotate(180) linear_extrude(2.25) mirror([1,0]) butterSheet();
            translate([1-length/2,-2.5,-2]) rotate(180) linear_extrude(0.25) breadSheet(split=true);
            translate([-1-length/2,-2.5,-2]) rotate(180) linear_extrude(0.25) mirror([1,0]) breadSheet(split=true);
        } else {
            translate([-length/2,-2.5,0.5]) rotate(180) linear_extrude(0.25) breadSheet();
            translate([-length/2,-2.5,-1.75]) rotate(180) linear_extrude(2.25) butterSheet();
            translate([-length/2,-2.5,-1.75]) rotate(180) linear_extrude(2.25) mirror([1,0]) butterSheet();
            translate([-length/2,-2.5,-2]) rotate(180) linear_extrude(0.25) breadSheet();
        }
    }
}

//butterSheet();
renderSystem(true);
//cuttingTable(true);
//onionsHaveLayers();
>>>>>>> f250b1fc3e979666dbe25af6d2c3d9f42a4dddd4
