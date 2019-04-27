$fn = 64;
epsilon = 0.01;

module popFilterClip(clipParms)
{
    innerRadius = clipParms[0];
    thickness = clipParms[1];
    width = clipParms[2];
    entranceWidth = clipParms[3];
    bufferLength = clipParms[4];
    cutWidth = clipParms[5];
    cutLength = clipParms[6];
    cutSpread = clipParms[7];
    
    translate([(width/2) + bufferLength, 0, 0])    
    difference()
    {
        union()
        {
            difference()
            {
                translate([-width/2, -width/2, 0]) 
                    cube([width, width, thickness]);
                translate([0, 0, -epsilon])
                    cylinder(r = innerRadius, h = thickness + (2*epsilon));
                translate([0, -entranceWidth/2, -epsilon])
                    cube([(width/2) + epsilon , entranceWidth, thickness + (2*epsilon)]);
            }
            translate([-(width/2) - bufferLength, -width/2, 0])
                cube([bufferLength, width, thickness]);
        }
        // cuts for flexibility
        translate([-(innerRadius+cutLength), cutSpread/2, -epsilon])
            cube([innerRadius+cutLength, cutWidth, thickness + (2*epsilon)]);
        translate([-(innerRadius+cutLength), -cutSpread/2, -epsilon])
            cube([innerRadius+cutLength, cutWidth, thickness + (2*epsilon)]);
    }
}

module popFilterClipWithBridgeRamp(clipParms, bridgeParms)
{
    clipThickness = clipParms[1];
    clipWidth = clipParms[2];
    clipBufferLength = clipParms[4];
    rampThickness = clipParms[8];
    
    bridgeWidth = bridgeParms[0];
    bridgeThickness = bridgeParms[1];
    bridgeLength = bridgeParms[2];
    
    popFilterClip(clipParms);
    
    // ramp between clip and bridge
    hull()
    {
        translate([0, -clipWidth/2, 0])
            rotate([0, -90, 0])
            cube([clipThickness, clipWidth, epsilon]);
        translate([-rampThickness, -bridgeWidth/2, 0])
            rotate([0, -90, 0])
            cube([bridgeThickness, bridgeWidth, epsilon]);
    }
}

module popFilterBase(baseParms, baseHoleParms)
{
    baseRadius = baseParms[0];
    baseHeight = baseParms[1];
    baseWallThickness = baseParms[2];
    
    holeRadius = baseHoleParms[0];
    holeDistance = baseHoleParms[1];
    numHoles = baseHoleParms[2];
    holeDegreeOffset = baseHoleParms[3];
    
    difference()
    {
        cylinder(r = baseRadius, h = baseHeight);
        translate([0, 0, -epsilon])
            cylinder(r = baseRadius - baseWallThickness, h = baseHeight + (2*epsilon));
        for(i = [0 : numHoles]) 
        {
            rotate([0, 0, (i * (360 / numHoles)) + holeDegreeOffset])
                translate([holeDistance, 0 , -epsilon])
                cylinder(r = holeRadius, h = baseHeight + (2*epsilon));
        }
    }
}

module popFilter(baseParms, baseHoleParms, bridgeParms, clipParms)
{
    baseHeight = baseParms[1];
    
    bridgeWidth = bridgeParms[0];
    bridgeThickness = bridgeParms[1];
    bridgeLength = bridgeParms[2];
    bridgeDistFromCentre = bridgeParms[3];
    
    popFilterBase(baseParms, baseHoleParms);

    translate([-bridgeDistFromCentre, -bridgeWidth/2, baseHeight])
    {
        cube([bridgeThickness, bridgeWidth, bridgeLength]);
    }
    
    translate([-(bridgeDistFromCentre-bridgeThickness), 0, baseHeight + bridgeLength])
        rotate([0, -90, 0])
        popFilterClipWithBridgeRamp(clipParms, bridgeParms);
}

baseRadius = 56.5;
baseHeight = 5;
baseWallThickness = 8;

holeRadius = 2;
holeDistance = 52;
numHoles = 5;
holeDegreeOffset = 0;

bridgeWidth = 18;
bridgeThickness = 5;
bridgeLength = 30;
bridgeDistFromCentre = 55.5;
rampThickness = 10;

clipInnerRadius = 9.3;
clipThickness = 10;
clipWidth = 25;
clipEntranceWidth = 16;
clipBufferLength = 10;
clipCutWidth = 0.8;
clipCutLength = 10;
clipCutSpread = 10;

baseParms = [baseRadius, baseHeight, baseWallThickness];
baseHoleParms = [holeRadius, holeDistance, numHoles, holeDegreeOffset];
bridgeParms = [bridgeWidth, bridgeThickness, bridgeLength, bridgeDistFromCentre];
clipParms = [clipInnerRadius, clipThickness, clipWidth, clipEntranceWidth, clipBufferLength, clipCutWidth, clipCutLength, clipCutSpread, rampThickness];

popFilter(baseParms, baseHoleParms, bridgeParms, clipParms);