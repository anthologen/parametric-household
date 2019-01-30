module arm(gapThickness, wallThickness, wallHeight, bottomThickness, armLength)
{
    // Bottom
    cube([gapThickness + (2 * wallThickness), armLength, bottomThickness]);
    // Walls
    translate([0, 0, bottomThickness])
        cube([wallThickness, armLength, wallHeight]);
    translate([wallThickness+gapThickness, 0, bottomThickness])
        cube([wallThickness, armLength, wallHeight]);
}

module wedge(wedgeFlatEdge, wedgeExtrusion)
{
    union()
    {
        linear_extrude(height=wedgeExtrusion)
            polygon(points=[[0,0], [0,wedgeFlatEdge], [wedgeFlatEdge/sqrt(3), wedgeFlatEdge]]);
        linear_extrude(height=wedgeExtrusion)
            rotate([0,180,-60])
            polygon(points=[[0,0], [0,wedgeFlatEdge], [wedgeFlatEdge/sqrt(3), wedgeFlatEdge]]);
    }
}
