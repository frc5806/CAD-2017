$fn = 100;

boltCircleRad = 0.293;
boltRad = 0.105/2;

wallWidth = 3/64;

module spacer() {
    difference() {
        circle(r=boltCircleRad+boltRad+wallWidth);
        
        circle(r=boltCircleRad-boltRad-wallWidth);
        
        translate([boltCircleRad,0]) circle(r=boltRad);
        translate([-boltCircleRad,0]) circle(r=boltRad);
    }
}

spacer();