$fn=240;

hood_ir = 2 - 0.3125 + 5;
hood_thickness = 0.125;
hood_or = hood_ir + hood_thickness;


plateWidth = 1.5;
add_trans = 1.5;

boltRad = .1440/2;


module hood_2d() {
    translate([-hood_ir,0]) intersection() {
        difference() {
            circle(hood_or);
            circle(hood_ir);
        }
        square([hood_or, hood_or]);
    }
}

module outerHood() {
    translate([-hood_ir,0]) rotate(-90) intersection() {
        difference() {
            circle(hood_or+0.25);
            circle(hood_ir);
        }
        translate([-5,0]) square([hood_or+1, hood_or+0.25]);
    }
    
}



difference() {
    outerHood();
    hood_2d();
/*
    translate([0.16,-0.5]) circle(r=boltRad);
    translate([0.01,-1.5]) circle(r=boltRad);
     translate([-0.28,-2.5]) circle(r=boltRad);
         translate([-0.21,2.5]) circle(r=boltRad);
*/
    

union() {

cutoutThickness = 1/128;

    
difference() {
    translate([-hood_ir,0])circle(r=hood_or+0.125 + cutoutThickness/2);
    translate([-hood_ir,0])circle(r=hood_or+0.125 - cutoutThickness/2);
    translate([-3,4.75]) square([100,10]);
        translate([-3,-12.5]) square([100,10]);


}
}

}

// angle = 64 deg = 1.11701
// rad = 6.8125
// arclength = 7.61 = 7 and 19/32nds