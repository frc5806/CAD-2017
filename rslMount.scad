$fn=100;

holeRad = 0.45;
bagRad = 1.591/2;

length = 1.5;

wall = 3/16;
gap = 1/16;

boltRad = 0.1;
boltHeadRad = 3/16;

height = 3;

difference() {
    hull() {
        cylinder(r=bagRad+wall,h=length);
        
        translate([-wall,0,0]) cube([wall*2,bagRad+wall+0.5,length]);
    }
     
    cylinder(r=bagRad,h=length);
    translate([-gap/2,0,0]) cube([gap,10,length]);
    

    translate([-5,bagRad+wall+0.25,0.375]) rotate([90,0,90]) cylinder(r=boltRad,h=100);

    translate([-5,bagRad+wall+0.25,length-0.375]) rotate([90,0,90]) cylinder(r=boltRad,h=100);

        translate([wall,bagRad+wall+0.25,0.375]) rotate([90,0,90]) cylinder(r=boltHeadRad,h=100);

    translate([wall,bagRad+wall+0.25,length-0.375]) rotate([90,0,90]) cylinder(r=boltHeadRad,h=100);

    translate([-wall,bagRad+wall+0.25,length-0.375]) rotate([90,0,-90]) cylinder(r=boltHeadRad,h=100);

    translate([-wall,bagRad+wall+0.25,0.375]) rotate([90,0,-90]) cylinder(r=boltHeadRad,h=100);
}


translate([-bagRad,0,0]) rotate(180) cube([wall,height,length]);
translate([bagRad+wall,0,0]) rotate(180) cube([wall,height,length]);

difference() {
    translate([-bagRad-wall,wall-height,0]) rotate(270) cube([wall,bagRad*2+wall*2,length]);

    translate([0,0.01+wall-height,length/2]) rotate([90,0,0]) cylinder(r=holeRad,h=10);
}


