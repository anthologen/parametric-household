// laser engraver belt holder
$fn=64;

module roundedcube(xdim,ydim,zdim,rdim){
    hull(){
        translate([rdim,rdim,0]) cylinder(h=zdim,r=rdim);
        translate([xdim-rdim,rdim,0]) cylinder(h=zdim,r=rdim);
        translate([rdim,ydim-rdim,0]) cylinder(h=zdim,r=rdim);
        translate([xdim-rdim,ydim-rdim,0]) cylinder(h=zdim,r=rdim);
    }
}
difference() {
    roundedcube(19,19,6.5,2);
    translate([9.5,4,-0.5]) cylinder(h=7.5,r=3);
    translate([6,8.5,-0.5]) cube([7,2.5,7.5]);
}
translate([7,14,6.5]) cube([5,3,5]);