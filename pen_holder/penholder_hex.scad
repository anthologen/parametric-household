$fn=64;
module roundedcube(xdim,ydim,zdim,rdim){
    hull(){
        translate([rdim,rdim,0]) cylinder(h=zdim,r=rdim);
        translate([xdim-rdim,rdim,0]) cylinder(h=zdim,r=rdim);
        translate([rdim,ydim-rdim,0]) cylinder(h=zdim,r=rdim);
        translate([xdim-rdim,ydim-rdim,0]) cylinder(h=zdim,r=rdim);
    }
}

module baseShell(sideLength, height, cornerRadius, wallThickness, bottomThickness)
{
    difference() {
        roundedcube(sideLength,sideLength,height,cornerRadius);
        innerSideLength = sideLength - (wallThickness * 2);
        translate([wallThickness, wallThickness, bottomThickness])
            roundedcube(innerSideLength,innerSideLength,height,cornerRadius);
    }
}

epsilon = 0.001;
module baseShellCut(sideLength, height, cornerRadius, wallThickness, bottomThickness)
{
    difference() {
        baseShell(sideLength, height, cornerRadius, wallThickness, bottomThickness);
        straightWallSpan = sideLength - (cornerRadius * 4);
        translate([0-epsilon,cornerRadius*2,bottomThickness])
            scale([1+epsilon,1,1])
            cube([wallThickness,straightWallSpan,height]);
        translate([(sideLength-wallThickness)-epsilon,cornerRadius*2,bottomThickness])
            scale([1+epsilon,1,1])
            cube([wallThickness,straightWallSpan,height]);
        translate([cornerRadius*2,0-epsilon,bottomThickness])
            scale([1,1+epsilon,1])
            cube([straightWallSpan,wallThickness,height]);
        translate([cornerRadius*2,(sideLength-wallThickness)-epsilon,bottomThickness])
            scale([1,1+epsilon,1])
            cube([straightWallSpan,wallThickness,height]);
    }
}

module wallwithLinesImport(extrusionHeight)
{
    linear_extrude(height=extrusionHeight)
        translate([0,222,0])
        import(file="hex_wall_with_lines.dxf", layer="base");
}

module wallImport(extrusionHeight)
{
    linear_extrude(height=extrusionHeight)
        translate([0,222,0])
        import(file="hex_wall.dxf", layer="base");
}

module completeWall()
{
    wallImport(2.5);
    translate([0,0,2.5])
        wallwithLinesImport(0.5);
}

sideLength = 60;
height = 80;
cornerRadius = 5;
wallThickness = 5;
bottomThickness = 5;

baseShellCut(sideLength, height, cornerRadius, wallThickness, bottomThickness);

insertedWallThickess = 3;
insertedWallLength = 40;

translate([cornerRadius*2,insertedWallThickess,bottomThickness])
rotate([90,0,0])
completeWall();

translate([insertedWallThickess,(cornerRadius*2)+insertedWallLength,bottomThickness])
rotate([90,0,-90])
completeWall();

translate([sideLength-insertedWallThickess,(cornerRadius*2),bottomThickness])
rotate([90,0,90])
completeWall();

translate([insertedWallLength+(cornerRadius*2),sideLength-insertedWallThickess,bottomThickness])
rotate([90,0,-180])
completeWall();