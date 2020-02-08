$fn=32;
// Roman Temple Demo for parametric design

/* 
// Temple 1 Parameters
baseHeight = 2;
baseWidth = 35;
baseLength = 55;
pillarRadius = 2.5;
pillarHeight = 20;
cellaWidth = 15;
cellaLength = 35;
roofHeight = 5;
roofBeamHeight = 1;
numWidthPillars = 4;
numLengthPillars = 6;
*/

// Temple 2 Parameters
baseHeight = 2;
baseWidth = 44;
baseLength = 60;
pillarRadius = 2;
pillarHeight = 16;
cellaWidth = 24;
cellaLength = 40;
roofHeight = 5;
roofBeamHeight = 1;
numWidthPillars = 6;
numLengthPillars = 8;

module fancyPillar()
{
    translate([pillarRadius, pillarRadius, baseHeight])
    {
        translate([0, 0, pillarHeight-(pillarHeight/20)])
            cylinder(r=pillarRadius, h=pillarHeight/20);
        cylinder(r=pillarRadius, h=pillarHeight/20);
        scale([0.9, 0.9, 1])
        cylinder(r=pillarRadius, h=pillarHeight);
    }
}

module pillar()
{
    translate([pillarRadius, pillarRadius, baseHeight])
        cylinder(r=pillarRadius, h=pillarHeight);
}

// Create a series of pillars
module pillarSeries(distance, numPillars, pillarRadius)
{
    numPillars  = numPillars - 1;
    pillarSpacing = (distance - pillarRadius * 2) / numPillars;
    for(pillar_idx = [0 : numPillars])
    {
        translate([pillarSpacing * pillar_idx, 0, 0]) fancyPillar();
    }
}
// Create all pillars around the perimeter
// Front Pillar Series
pillarSeries(baseWidth, numWidthPillars, pillarRadius);
// Back Pillar Series
translate([0, baseLength - pillarRadius * 2, 0])
    pillarSeries(baseWidth, numWidthPillars, pillarRadius);
translate([pillarRadius * 2, 0, 0])
    rotate([0, 0, 90])
    pillarSeries(baseLength, numLengthPillars, pillarRadius);
translate([baseWidth, 0, 0])
    rotate([0, 0, 90])
    pillarSeries(baseLength, numLengthPillars, pillarRadius);

// Central Structure
translate([baseWidth/2 - cellaWidth/2, baseLength/2 - cellaLength/2, baseHeight])
    cube([cellaWidth, cellaLength, pillarHeight]);
// Base
cube([baseWidth, baseLength, baseHeight]);

// Roof
translate([0, 0, baseHeight + pillarHeight])
    cube([baseWidth, baseLength, roofBeamHeight]);
translate([0, baseLength, baseHeight + pillarHeight + roofBeamHeight])
    rotate([90, 0, 0])
    linear_extrude(height=baseLength)
    polygon(points=[[0,0], [baseWidth,0], [baseWidth/2, roofHeight]]);