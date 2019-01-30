$fn=100;

module roundedShadeShape(diameter, sideLen, cylinderHeight)
{
    cylinder(h=cylinderHeight, r=diameter/2, center=false);
    translate([-diameter/2,0,0]) cube([diameter,sideLen,cylinderHeight]);
    translate([0,0,cylinderHeight]) sphere(r=diameter/2);
    translate([0,0,cylinderHeight]) rotate([-90,0,0]) cylinder(h=sideLen, r=diameter/2, center=false);
}

module roundedShade(diameter, sideLen, cylinderHeight, holeDiameter, thickness)
{
    difference()
    {
        roundedShadeShape(diameter, sideLen, cylinderHeight);
        translate([0,0,thickness])
            roundedShadeShape(diameter-(thickness*2), sideLen+thickness, cylinderHeight-(thickness*2));
        cylinder(h=thickness*3, r=holeDiameter/2, center=true);
    }
}
roundedShade(40,20,80,15,1);
