include <joint_commons.scad>;

module armWithWedge(gapThickness, wallThickness, wallHeight, bottomThickness, armLength)
{
    union()
    {
        arm(gapThickness, wallThickness, wallHeight, bottomThickness, armLength);
        rotate([0,0,-90]) wedge(wallThickness, bottomThickness+wallHeight);
    }
}

module tripleJoint(gapThickness, wallThickness, wallHeight, bottomThickness, armLength) {
        // Construct arms
        armWithWedge(gapThickness, wallThickness, wallHeight, bottomThickness, armLength);
        translate([(2*wallThickness)+gapThickness, 0, 0])
            rotate([0,0,-120])
            {
                armWithWedge(gapThickness, wallThickness, wallHeight, bottomThickness, armLength);
                translate([(2*wallThickness)+gapThickness, 0, 0])
                    rotate([0,0,-120])
                    armWithWedge(gapThickness, wallThickness, wallHeight, bottomThickness, armLength);
            }
        // Construct bottom centre
        hull()
        {
            wedge(wallThickness, bottomThickness);
            translate([(2*wallThickness)+gapThickness, 0, 0])
                rotate([0,0,-120])
                {
                    wedge(wallThickness, bottomThickness);
                    translate([(2*wallThickness)+gapThickness, 0, 0])
                        rotate([0,0,-120])
                        wedge(wallThickness, bottomThickness);
                }
        }
}

gapThickness = 3;
wallThickness = 2;
wallHeight = 10;
bottomThickness = 2;
armLength = 10;

tripleJoint(gapThickness, wallThickness, wallHeight, bottomThickness, armLength);