$fn = 50;

side = 0.472;

module actuatorMount(length=3,holes=false,filletRad = 1/16) {
    difference() {
       hull() { 
        cube([0.5,length,1]);
               translate([0.0984252+side+0.75+0.125-filletRad,length]) {
       translate([0,0,filletRad]) rotate([90,0,0]) cylinder(r=filletRad,h=length);
       translate([0,0,1-filletRad]) rotate([90,0,0]) cylinder(r=filletRad,h=length);
    }    
       }
        
        translate([0.75+0.0984252,-1,(1-side)/2]) cube([side,10,side]);
        
        translate([-0.25,-1,0.125]) cube([1,10,0.75]);

        if (holes) {
            translate([0.375,0.5]) cylinder(r=0.125/2,h=10);
            translate([0.375,length-0.5]) cylinder(r=0.125/2,h=10);
        }
    }
    

}

//actuatorMount();

module nettingMount(holes) {
    difference() {
        hull() {
            cylinder(r=0.35,h=0.75);
            translate([0,0,0.5]) cylinder(r=0.6,h=0.25);
        }
        
        cylinder(r=0.5/sqrt(3),h=0.5,$fn=6);
        cylinder(r=0.125,h=4);
        
        for (i=[0:360/holes:360]) {
        rotate(i )translate([0.48,0]) cylinder(r=0.125/2,h=10);
        }

    }
}

actuatorMount(length=2);

