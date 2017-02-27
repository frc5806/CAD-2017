backHeight = 11.5;

topWidth = 12;
bottomWidth = 8;

frontDrop = 2;

thickness = 2.375;

genFloor = false;

module trapZoid(front=false,split=false,side=false) {
    wall = 1.5;
    cutoff = 3;
    bottomRe = 1;
    
    difference() {
        polygon(points=[ [(topWidth-bottomWidth)/2,0], [(topWidth-bottomWidth)/2 + bottomWidth,0], [topWidth,backHeight], [0,backHeight]]);
        
         if (front) {
             translate([0,-1]) square([100,cutoff + 1]);
             
             translate([0,backHeight-frontDrop]) square([100,100]);
             
             if (split) {
                 if (side) square([topWidth/2,100]);
                 else translate([topWidth/2,-1]) square([100,100]);
             
             } 
             
             cutoutWidth = 3;
                              translate([topWidth/2 - cutoutWidth/2,cutoff + wall+ bottomRe+ 2.4999]) square([cutoutWidth,10]); 

             
             difference() {
                 polygon(points=[ [(topWidth-bottomWidth)/2+wall,wall], [(topWidth-bottomWidth)/2 + bottomWidth - wall,wall], [topWidth-wall,backHeight-wall], [wall,backHeight-wall]]);
                 
                 translate([0,-1]) square([100,cutoff + wall+ bottomRe+ 1]);
                                  
                 translate([0,backHeight-frontDrop-wall]) square([100,100]);

             }
         
         }
    }
}

module mainSheet() {
        
        trapZoid();

        sideHeight = sqrt(backHeight*backHeight + (topWidth-bottomWidth)*(topWidth-bottomWidth)/4);
        sideAngle = atan(2*backHeight/(topWidth-bottomWidth));


        color([0,1,0]) translate([(topWidth-bottomWidth)/2,0]) rotate(270-sideAngle) mirror([0,1]) square([thickness,sideHeight]);

        color([0,1,0]) translate([(bottomWidth + topWidth)/2,0]) rotate(sideAngle-90) square([thickness,sideHeight]);

        translate([(topWidth+bottomWidth)/2+thickness*sin(sideAngle),-thickness*cos(sideAngle)]) rotate(2*sideAngle-180 + 0.0001) translate([-(topWidth-bottomWidth)/2,0]) trapZoid(front=true,split=true);

         translate([topWidth/2,0]) mirror(1) translate([-topWidth/2,0]) translate([(topWidth+bottomWidth)/2+thickness*sin(sideAngle),-thickness*cos(sideAngle)]) rotate(2*sideAngle-180 + 0.0001) translate([-(topWidth-bottomWidth)/2,0]) trapZoid(front=true,split=true);
    
}

module reinforcements() {
    translate([-5.4,8]) rotate(20) square([3.5,1.5]);
    translate([topWidth/2,0]) mirror(1) translate([-topWidth/2-5.4,8]) rotate(20) square([3.5,1.5]);
    
    translate([-4,-0.25]) rotate(20) square([3.5,1.5]);
    translate([topWidth/2,0]) mirror(1) translate([-topWidth/2-4,-0.25]) rotate(20) square([3.5,1.5]);
}

bottomLeft = true;
translate([bottomLeft?6:0,bottomLeft?0.45:0]) { 
    mainSheet();
    reinforcements();
}
