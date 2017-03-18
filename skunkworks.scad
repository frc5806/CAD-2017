width = 16;
length = 20;
height = 20;

innerH = 6;

boxWidth = 1;
boxHeight = 2;

// http://www.andymark.com/Banebots-p/am-2876.htm
// https://www.armabot.com/products/rs7-encoder
// or 
boxLength = (2*(width-boxWidth*2) + 2*length);
weight = .1052 * boxLength + 0.5 * 4 + 0.8 *4;


echo(weight);

cube([boxWidth,length,boxHeight]);

translate([boxWidth,innerH]) cube([width-boxWidth*2,boxWidth,boxHeight]);

translate([boxWidth,length-boxWidth-innerH]) cube([width-boxWidth*2,boxWidth,boxHeight]);

translate([width-boxWidth,0]) cube([boxWidth,length,boxHeight]);

wheelInset = 2.5;

module gearMotor() {
    color([0.8,0.8,0.8]) translate([-1.1-boxWidth,0.75,0.75]) rotate([0,90,0]) cylinder(r=2,h=1,$fn=100);
    color([0.8,0.8,0.8]) cube([1+2.602,1.5,1.5]);
}

translate([1,wheelInset-0.75,0.25]) gearMotor();

translate([width-boxWidth,0.75+wheelInset,0.25]) rotate(180) gearMotor();

translate([1,length-0.75-wheelInset,0.25]) gearMotor();

translate([width-boxWidth,length+0.75-wheelInset,0.25]) rotate(180) gearMotor();

rampLength = sqrt(length*length + (height-boxHeight)*(height-boxHeight));

color([0.1,0.1,0.1,0.3]) {
translate([0,0,boxHeight]) rotate([atan((height-boxHeight)/length),0,0]) cube([width,rampLength,0.25]);

translate([0,length,0]) cube([width,0.25,height]);
}