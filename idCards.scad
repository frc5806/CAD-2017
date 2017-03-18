$fn = 100;

width = 3.25;
height = 2.125;

filletRad = 0.125;

holeIndent = 3/16;
holeDiam = 3/16;

difference() {
    hull() {
        translate([filletRad,filletRad]) circle(r=filletRad);
        translate([width-filletRad,filletRad]) circle(r=filletRad);
        translate([width-filletRad,height-filletRad]) circle(r=filletRad);
        translate([filletRad,height-filletRad]) circle(r=filletRad);
    }
    
    translate([holeIndent,height-holeIndent]) circle(r=holeDiam/2);
}
