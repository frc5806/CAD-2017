headRad = (7/16)/sqrt(3);

difference() {
    translate([0,0,5/8]) sphere(r=5/8,$fn=100);

cylinder(r=headRad, h=6/8, $fn=6);
    
    cylinder(r=10,h=1/16);

}