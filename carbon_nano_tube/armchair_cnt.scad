// Armchair Carbon Nanotube Pen Holder

/* [Armchair Carbon Nanotube] */
// Diameter of the carbon atoms (mm)
Carbon_diameter = 4;
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
Bond_smoothness = 16;

/* [Pen Holder Base] */
// Toggle the pen holder base on/off
Draw_pen_holder_base = true;
// Height of the pen holder base (mm)
Base_height = 1.5;
// $fn used to draw the pen holder base
Base_smoothness = 64;

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

echo("Tube has approx. diameter ", g_ngon_vertex_radius * 2);
echo("Tube has approx. height ", g_half_layer_height * Num_half_layers);

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
    base_top_radius = g_ngon_vertex_radius + Carbon_diameter / 2;
    base_bevel_height = Carbon_diameter / 2;
    base_bevel_angle = 60; // to stylistically match bond angles
    base_bottom_radius = base_top_radius + (base_bevel_height / tan(base_bevel_angle));
    translate([0,0,-base_bevel_height])
        cylinder(r1=base_bottom_radius, r2=base_top_radius, h=base_bevel_height, $fn=Base_smoothness);
    translate([0,0,-base_bevel_height-Base_height])
        cylinder(r=base_bottom_radius, h=Base_height, $fn=Base_smoothness);
}

ArmchairCNT();
if (Draw_pen_holder_base) PenHolderBase();