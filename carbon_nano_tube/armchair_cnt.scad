// Armchair Carbon Nanotube Pen Holder

/* [Armchair Carbon Nanotube] */
// Diameter of the carbon atoms (mm)
Carbon_diameter = 3;
// Diameter of the carbon bonds (mm)
Bond_diameter = 3;
// Length of the carbon bonds (mm)
Bond_length = 8;
// Halved number of n-gon faces on the tube
Num_sides = 10;
// Number of half layers to vertically stack
Num_half_layers = 12;
// $fn used to draw carbon spheres
Carbon_smoothness = 16;
// $fn used to draw bond cylinders
Bond_smoothness = 8;

/* [Pen Holder Base] */
// Toggle the pen holder base on/off
Draw_pen_holder_base = true;
// Height of the pen holder base (mm)
Base_height = 3;
// $fn used to draw the pen holder base
Base_smoothness = 64;

/* [Pen Holder End Ring] */
// Toggle the pen holder top ring on/off
Draw_pen_holder_ring = true;
// Height of the top ring (mm)
Top_ring_height = 3;
// $fn used to draw the pen holder base
Top_ring_smoothness = 64;

/* [Base and Top Bevel] */
// Angle of the top and bottom bevel (relative to Z)
Bevel_angle = 30;
// Height of top and bottom bevel
Bevel_height = 3;

// --- Intermediate Values ---
// pre-calculate values to allow for caching
g_num_faces = Num_sides * 2;
g_ngon_slice_angle = 360 / g_num_faces;
g_ngon_vertex_angle = (g_num_faces - 2) * 180 / g_num_faces;
g_face_length = Bond_length * ((1 / (2 * sin(g_ngon_vertex_angle/2))) + 1);
g_segment_radius = g_face_length / (2 * tan(g_ngon_slice_angle/2));
g_ngon_vertex_radius = g_face_length / (2 * sin(g_ngon_slice_angle/2));
g_ngon_vertex_radius_reduction = Bond_length / (4 * tan(g_ngon_vertex_angle/2));
g_hexagon_height = sqrt(3) * Bond_length;
g_half_layer_height = g_hexagon_height / 2;
g_cnt_height = g_half_layer_height * Num_half_layers;
g_base_outer_radius = g_ngon_vertex_radius + (Bevel_height * tan(Bevel_angle));
Z_EPSILON = 0.01; // small constant value for z-fighting 

echo("Tube has approx. diameter ", g_ngon_vertex_radius * 2);
echo("Tube has approx. height ", g_cnt_height);

// --- Geometry ---
// render() is used often to cache objects for future calls
// union early to "swallow" internal vertices
// without caching, compilation never finishes
module Dumbbell()
{
    render() {
        union() { 
            rotate([0,90,0])
                cylinder(h=Bond_length, r=Bond_diameter/2, center=true, $fn=Bond_smoothness);
            translate([Bond_length/2,0,0])
                sphere(r=Carbon_diameter/2, $fn=Carbon_smoothness);
            translate([-Bond_length/2,0,0])
                sphere(r=Carbon_diameter/2, $fn=Carbon_smoothness);
        }
    }
}

module DumbbellLayer()
{
    render() {
        for(i = [0:2:g_num_faces-1])
        {
            rotate([0,0,g_ngon_slice_angle*i])
                translate([0,g_segment_radius,0])
                Dumbbell();
        }
    }
}

module DiagonalBond(up_angle)
{
    translate([0,g_ngon_vertex_radius-g_ngon_vertex_radius_reduction,g_half_layer_height/2])
        rotate([0,up_angle,0])
        cylinder(h=Bond_length, r=Bond_diameter/2, center=true, $fn=Bond_smoothness);
}

module LeftDiagonalBonds()
{
    render() DiagonalBond(-30);
}

module RightDiagonalBonds()
{
    render() DiagonalBond(30);
}

module DiagonalBondLayer()
{
    offset_angle = g_ngon_slice_angle / 2;
    for(i = [0:2:g_num_faces-1])
    {
        rotate([0,0,(g_ngon_slice_angle*i) + offset_angle])
            LeftDiagonalBonds();
    }
    for(i = [1:2:g_num_faces-1])
    {
        rotate([0,0,(g_ngon_slice_angle*i) + offset_angle])
            RightDiagonalBonds();
    }
}

module HalfLayer()
{
    render()
    {
        DumbbellLayer();
        DiagonalBondLayer();
    }
}

module ArmchairCNT()
{
    for(layer = [0:Num_half_layers-1])
    {
        translate([0,0,layer * g_half_layer_height])
            rotate([0,0,layer * g_ngon_slice_angle])
            HalfLayer();
    }
    translate([0,0, Num_half_layers * g_half_layer_height])
        rotate([0,0,(Num_half_layers % 2) * g_ngon_slice_angle])
        DumbbellLayer();
}

module PenHolderBase()
{
    translate([0,0,-Bevel_height])
        cylinder(r1=g_base_outer_radius, r2=g_ngon_vertex_radius, h=Bevel_height, $fn=Base_smoothness);
    translate([0,0,-Bevel_height-Base_height])
        cylinder(r=g_base_outer_radius, h=Base_height, $fn=Base_smoothness);
    echo("Penholder base has radius ", g_base_outer_radius);
    echo("Penholder base has total height ", Bevel_height + Base_height);
}

module PenHolderTopRingPositive()
{
    cylinder(h=Bevel_height, r1=g_ngon_vertex_radius, r2=g_base_outer_radius, $fn=Top_ring_smoothness);
        translate([0, 0, Bevel_height])
    cylinder(h=Top_ring_height, r=g_base_outer_radius, $fn=Top_ring_smoothness);
}

module PenHolderTopRingNegative()
{
    top_ring_half_thickness = g_base_outer_radius - g_ngon_vertex_radius;
    top_ring_upper_inner_radius = g_base_outer_radius - (top_ring_half_thickness * 2);
    echo("Penholder top ring has thickness ", top_ring_half_thickness * 2);
    translate([0, 0, -Z_EPSILON])
        union()
        {
            cylinder(h=Bevel_height, r1=g_ngon_vertex_radius, r2=top_ring_upper_inner_radius, $fn=Top_ring_smoothness);
            translate([0, 0 ,Bevel_height-Z_EPSILON])
                cylinder(h=Top_ring_height+(Z_EPSILON*3), r=top_ring_upper_inner_radius, $fn=Top_ring_smoothness);
        }
}

debug_top_ring_cutaway = false;
module PenHolderEndRing()
{
    difference()
    {
        PenHolderTopRingPositive();
        PenHolderTopRingNegative();
        if (debug_top_ring_cutaway) cube([g_base_outer_radius, g_base_outer_radius, g_base_outer_radius]);
    }
}
module PenHolderTopRing()
{
    translate([0, 0, g_cnt_height])
        PenHolderEndRing();
    echo("Penholder top ring has total height ", Bevel_height + Top_ring_height);
}

module PenHolderBottomRing()
{
    mirror([0, 0, 180])
        PenHolderEndRing();
}

ArmchairCNT();
if (Draw_pen_holder_base) PenHolderBase();
if (Draw_pen_holder_ring) PenHolderTopRing();
if (Draw_pen_holder_ring && !Draw_pen_holder_base) PenHolderBottomRing();