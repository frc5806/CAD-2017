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
upperExtension = outerRadius-.3325;
frontUpperExtension = outerRadius/2;

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

module sliverSheet() {
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

module frontSheet(split) {
    w = outerRadius - 2.375;
    h = outerRadius - .875;
    filletRadius = 2;
    difference() {
        union() {
            circle(outerRadius);
            square([outerRadius,frontUpperExtension]);
        }
        translate([0,frontUpperExtension]) square([100,100]);
     
        boltU();
        translate([0,50]) square([w*2,100], center=true);
        polygon([for(i=[1:360]) [w*cos(i),h*sin(i)]])
        circle(w);
        translate([-100,-50]) square([100,100]);
    }
}

module backSheet() {
    filletRadius = 2;
    
    fudgeFactor = 2;
    difference() {
        union() {
            hull() {
            circle(outerRadius);
            square([outerRadius,upperExtension]);
            
            translate([0,-9.5+fudgeFactor]) square([4.5,4]);
            }
        }
        translate([0,upperExtension]) square([100,100]);
     
        boltU();
        translate([-3,-4.375]) difference() {
            w=4; h=2.875;
            union() {
                square([w,h]);
                translate([w,h]) circle(h);
            }
            translate([0,h]) square([100,100]);
        }
        translate([2.25,-8+fudgeFactor]) igusBolts();
        translate([-100,-50]) square([100,100]);
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
    mirror([-1,1,0]) {
        translate([.125,12.25]) rotate(0) { 
            //translate([6,6]) frontSheet();
            translate([0.1,5.75]) backSheet();
            translate([3.75,-3.5]) rotate(-30) backSheet();
            
            translate([2.5,-6.5]) rotate(60) motorPlate(0.8125,1.4375);
            translate([1,-3]) motorPlate(0,7/8);

        }
        translate([.125,22]) rotate(0) { 
            //translate([6,6]) frontSheet();
            //translate([6,-14.5]) backSheet();
        }
    }
}

module renderSystem(split=false) {
    length=24;

    translate([0,0,1.75+height]) rotate([-90,0,0]) {
        endCap();
        translate([-0.5 - length,0,0]) mirror([1,0,0]) endCap();
        color([0.5,0.5,0.5]) translate([-0.25,0,0.75+carriageHeight]) rotate([270,0,90]) igus(length);
        
        if (split) {
            translate([1-length/2,-2.5,0.5]) rotate(180) linear_extrude(0.25) frontSheet(split=true);
            translate([-1-length/2,-2.5,0.5]) rotate(180) linear_extrude(0.25) mirror([1,0]) frontSheet(split=true);
            translate([1-length/2,-2.5,-1.75]) rotate(180) linear_extrude(2.25) sliverSheet();
            translate([-1-length/2,-2.5,-1.75]) rotate(180) linear_extrude(2.25) mirror([1,0]) sliverSheet();
            translate([1-length/2,-2.5,-2]) rotate(180) linear_extrude(0.25) frontSheet(split=true);
            translate([-1-length/2,-2.5,-2]) rotate(180) linear_extrude(0.25) mirror([1,0]) frontSheet(split=true);
        } else {
            translate([-length/2,-2.5,0.5]) rotate(180) linear_extrude(0.25) sliverSheet();
            translate([-length/2,-2.5,-1.75]) rotate(180) linear_extrude(2.25) sliverSheet();
            translate([-length/2,-2.5,-1.75]) rotate(180) linear_extrude(2.25) mirror([1,0]) frontSheet();
            translate([-length/2,-2.5,-2]) rotate(180) linear_extrude(0.25) frontSheet();
        }
    }
}

module motorPlate(x,y,rot) {
    difference() {
        hull() {
            translate([x-0.5,-1-y]) square([1,1+y]);
            circle(r=0.75);
            rotate(rot) translate([1.5,0]) circle(r=0.75);
        }
    
        circle(r=0.325);
        
        rotate(rot) {
            translate([0,0.492]) circle(r=0.0788);
            translate([0,-0.492]) circle(r=0.0788);
        }
        
        rotate(rot) for (i=[-0.25:0.5:0.25]) { hull() {
            translate([0.75,i]) circle(r=0.07);
            translate([2,i]) circle(r=0.07);
        }}
        
        translate([x,-y-0.25]) circle(r=.098);
        translate([x,-y-0.75]) circle(r=.098);
        
    }
}



//butterSheet(true);
//breadSheet(true);
//renderSystem(false);
//cuttingTable();
//onionsHaveLayers();

//motorPlate(0.75+(3/16),1.6875-(1/4)-(1/16),0);
motorPlate(0,5/16,90);