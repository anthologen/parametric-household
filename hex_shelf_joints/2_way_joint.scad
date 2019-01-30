include <joint_commons.scad>;

module angledJoint(gapThickness, wallThickness, wallHeight, bottomThickness, armLength)
{
    // Arm 1
    arm(gapThickness, wallThickness, wallHeight, bottomThickness, armLength);
    armWidth = (2*wallThickness) + gapThickness;
    // Extra long side of arm
    translate([0, -armWidth/sqrt(3), bottomThickness])
        cube([wallThickness, armWidth/sqrt(3), wallHeight]);
    
    translate([(2*wallThickness)+gapThickness, 0, 0])
        rotate([0,0,-120])
        {
            // Arm 2
            arm(gapThickness, wallThickness, wallHeight, bottomThickness, armLength);
            // Extra long side of other arm
            translate([gapThickness+wallThickness, -armWidth/sqrt(3), bottomThickness])
                cube([wallThickness, armWidth/sqrt(3), wallHeight]);
        }
     // Bottom Wedge
     translate([armWidth, 0, 0])
        rotate([0,0,150])
        wedge(armWidth, bottomThickness);
     // Wall Wedge
     translate([armWidth,0, bottomThickness])
        rotate([0,0,150])
        wedge(wallThickness, wallHeight);
}

gapThickness = 3;
wallThickness = 2;
wallHeight = 10;
bottomThickness = 2;
armLength = 10;

angledJoint(gapThickness, wallThickness, wallHeight, bottomThickness, armLength);