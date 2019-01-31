module utensilHolder(bottomHeight, wallHeight, wallThickness, width, gapList)
{
    module bottom(gap) { cube([gap, width, bottomHeight]); }
    module wall() { cube([wallThickness, width, wallHeight]); }
    function total_gap_of(n) = ( n==0 ? 0 : gapList[n-1] + wallThickness + total_gap_of(n-1) );
    
    for(i = [0 : 1 : len(gapList)-1])
    {
        translate([total_gap_of(i), 0, 0])
        {
            bottom(gapList[i]);
            translate([gapList[i], 0, 0]) wall();
        }
    }
    translate([-wallThickness, 0 , 0]) wall();
}
// spoons=4cm, forks=3cm, knives=2cm, chopsticks=1.5cm
utensilHolder(2, 40, 2, 10, [40, 30, 20, 15]);
// envelope holder
// utensilHolder(3, 50, 3, 50, [10, 10, 10]);