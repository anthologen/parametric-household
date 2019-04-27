$fn = 64;
epsilon = 0.01;

module bolt(boltRadius, boltGap, boltHeight) {
    difference() {
        cylinder(r = boltRadius, h = boltHeight);
        translate([-boltRadius, -boltGap / 2, -epsilon])
            cube([boltRadius * 2, boltGap, boltHeight + (2 * epsilon)]);
    }
}

module popFilterCap(capRadius, capHeight, floorThickness, wallThickness, floorExtent, boltRadius, boltGap, boltDistance, numBolts, boltDegreeOffset) {
    difference() {
        cylinder(r = capRadius, h = capHeight);
        translate([0, 0, -epsilon])
            cylinder(r = capRadius - floorExtent, h = capHeight + (2 * epsilon));
        translate([0, 0, floorThickness])
            cylinder(r = capRadius - wallThickness, h = capHeight);
    }
    for(i = [0: numBolts]) {
        rotate([0, 0, (i * (360 / numBolts)) + boltDegreeOffset])
            translate([boltDistance, 0 , 0])
            bolt(boltRadius, boltGap, capHeight);
    }
}

capRadius = 58.3;
capHeight = 7;
floorThickness = 1;
wallThickness = 1;
floorExtent = 10;

boltRadius = 1.8;
boltGap = 0.2;
boltDistance = 52;
numBolts = 5;
boltDegreeOffset = 0;

popFilterCap(capRadius, capHeight, floorThickness, wallThickness, floorExtent, boltRadius, boltGap, boltDistance, numBolts, boltDegreeOffset);
