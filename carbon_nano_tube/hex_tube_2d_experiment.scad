$fn = 16;
    
joint_thickness = 1;
segment_thickness = 1;

module regular_polygon(num_sides, side_length)
{
    slice_angle = 360 / num_sides;
    segment_radius = side_length / (2 * tan(slice_angle/2));
    vertex_radius = side_length / (2 * sin(slice_angle/2));
    
    // segments
    for(i = [0:num_sides-1])
    {
        rotate([0,0,slice_angle*i])
            translate([0,segment_radius,0])
            rotate([0,90,0])
            cylinder(h=segment_length, r=segment_thickness/2, center=true);
    }
    // verticies
    offset_angle = slice_angle / 2;
    for(i = [0:num_sides-1])
    {   
        rotate([0,0,(slice_angle*i)+offset_angle])
            translate([0,vertex_radius,0])
            sphere(r=joint_thickness/2);
    }
}

module regular_polygon_halfcuts(num_sides, face_length)
{
    slice_angle = 360 / num_sides;
    vertex_angle = (num_sides - 2) * 180 / num_sides;
    
    segment_radius = face_length / (2 * tan(slice_angle/2));
    vertex_radius = face_length / (2 * sin(slice_angle/2));
    
    cut_segment_length = face_length / ((1 / (2 * sin(vertex_angle/2))) + 1);
    vertex_radius_reduction = cut_segment_length / (4 * tan(vertex_angle/2));
    
    // primary segments
    for(i = [0:num_sides-1])
    {
        rotate([0,0,slice_angle*i])
            translate([0,segment_radius,0])
            rotate([0,90,0])
            cylinder(h=cut_segment_length, r=segment_thickness/2, center=true);
    }
    
    // secondary segments
    offset_angle = slice_angle / 2;
    for(i = [0:num_sides-1])
    {
        rotate([0,0,(slice_angle*i)+offset_angle])
            translate([0,vertex_radius-vertex_radius_reduction,0])
            rotate([0,90,0])
            cylinder(h=cut_segment_length/2, r=segment_thickness/2, center=true);
    }
}


segment_length = 10;
num_sides = 6;

translate([0,0,-joint_thickness])
    regular_polygon(num_sides, segment_length);

regular_polygon_halfcuts(num_sides, segment_length);