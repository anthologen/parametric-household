// Holder Base Component

// Input Variables in millimetres
$fn = 64; // number of vertices a cylinder
cutInHalfView = true; // toggle true to see half view

baseRadius = 50;
baseHeight = 5;

midBevelTopRadius = 20;
midBevelBottomRadius = 25;
midBevelHeight = 5;

topTubeRadius = 10;
topTubeHeight = 20;

holeRadius = 8;
holeDepth = 25;
holeEdgeFromRadius = 5; // Counting from the edge towards the centre

centreMarkerRadius = 1;
centreMarkerHeight = 1;

module baseModel() {
    union() {
        // Top
        translate([0,0,baseHeight+midBevelHeight])
            cylinder(r=topTubeRadius, h=topTubeHeight);
        // Middle
        translate([0,0,baseHeight])
            cylinder(r2=midBevelTopRadius, r1=midBevelBottomRadius, h=midBevelHeight);
        // Base 
        cylinder(r=baseRadius, h=baseHeight);
    }
}

module holeShape() {
    difference() {
        cylinder(r=holeRadius, h=holeDepth);
        translate([-holeRadius, -holeRadius, 0])
            cube([holeRadius*2, holeEdgeFromRadius, holeDepth]);
     }
}

totalHeight = baseHeight+midBevelHeight+topTubeHeight;
difference() {
    baseModel();
    translate([0,0,totalHeight-holeDepth])
        holeShape();
    cylinder(r=centreMarkerRadius, h=centreMarkerHeight);
    if(cutInHalfView) {
        translate([0,-baseRadius,0])
            cube([baseRadius,baseRadius*2,totalHeight]);
    }
}

