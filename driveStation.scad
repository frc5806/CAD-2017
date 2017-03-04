$fn=100;

showFrames = true;

module button() {
    circle(r=1.125/2);
}

module rocker() {
    circle(r=0.25);
    if (showFrames) square([0.5,1],center=true);
}

module miniButton() {
    circle(r=0.125);
}

module slider() {
    boltRad = 0.0629921;
    boltSpace = 3.14961;
    
    translate([0,boltSpace/2]) circle(r=boltRad);
    translate([0,-boltSpace/2]) circle(r=boltRad);
    
    square([0.0551181,2.67717],center=true);
    
    //square([0.25,3.46457],center=true);
}

module lifter() {
    rotate(90) slider();
    translate([-1,1.25]) button();
    translate([1,1.25]) button();
}

module gearMech() {
    rowSpacing = 1.5;
    for (i=[-3:2:3]) translate([i,0]) button();
        
    for (i=[-1:2:1]) {
        translate([i*3,-rowSpacing]) button();
        translate([i*1.5,-rowSpacing]) button();
    }
}

module robot() {
    rotate(90) lifter();
    translate([-5/8,0]) miniButton();
}

module shooter() {
    rSpacing = 2;
    cSpacing = 2;
    
    for (r=[-rSpacing/2:rSpacing:rSpacing/2]) for (c=[-cSpacing/2:cSpacing:cSpacing/2]) translate([r,c]) button();
    
    translate([2.25,0]) slider();
    translate([0,-2.25]) rotate(90) slider();
    
    translate([0,0]) rocker();
}

module lcd() {
    square([4.72441,3.07087],center=true);
}

module layout() {
    translate([2.25,1]) lifter();
    translate([4.25,7.75]) gearMech();
    translate([12.25,2.75]) robot();
    translate([6.75,3.25]) shooter();
    translate([11,6.75]) lcd();
    
    translate([0.75,3.25]) square([4,2]);
}

module frame() {
    dimX = 14;
    dimY = 9;
    
    filletRad = 0.375;
    
    boltRad = 0.196/2;
    
    skirt = 3/8;
    
    difference() {
        hull() {
            translate([filletRad,filletRad]) circle(r=filletRad);
            translate([dimX-filletRad,filletRad]) circle(r=filletRad);
            translate([dimX-filletRad,dimY-filletRad]) circle(r=filletRad);
            translate([filletRad,dimY-filletRad]) circle(r=filletRad);
        }
        
        
        for (i=[skirt:(dimX-2*skirt)/3:dimX-skirt]) for (j=[skirt:dimY-2*skirt:dimY-skirt]) translate([i,j]) circle(r=boltRad);
                
        translate([skirt,skirt + (dimY-2*skirt)/2]) circle(r=boltRad);
        translate([dimX-skirt,skirt + (dimY-2*skirt)/2]) circle(r=boltRad);
        
    }

}

difference() {
    frame();
    layout();
}