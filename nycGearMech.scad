$fn = 100;

bridgeWidth = 30;
bridgeHeight = 6;

module bridge() {
    color([0.2,0.2,0.2]) {
    cube([0.5,1,bridgeHeight]);
    translate([0,0,bridgeHeight-0.5]) cube([bridgeWidth,1,0.5]);
    translate([bridgeWidth-0.5,0,0])cube([0.5,1,bridgeHeight]);
    }
}

bridge();