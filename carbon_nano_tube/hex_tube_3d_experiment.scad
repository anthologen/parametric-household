$fn = 64;
    
joint_thickness = 1;
segment_thickness = 1;

module makeLayer(num_sides, slice_angle, segment_radius, cut_segment_length, segment_thickness, height, isOdd)
{
    translate([0, 0, height])
    {
        for(i = [0:num_sides-1])
        {
            if(i % 2 == isOdd)
            {
                rotate([0,0,slice_angle*i])
                    translate([0,segment_radius,0])
                    {
                        rotate([0,90,0])
                            cylinder(h=cut_segment_length, r=segment_thickness/2, center=true);
                        translate([cut_segment_length/2,0,0])
                            sphere(r=vertex_length/2);
                        translate([-cut_segment_length/2,0,0])
                            sphere(r=vertex_length/2);
                    }
            }
        }
    }
}

module makeSupport(slice_angle, vertex_radius, vertex_radius_reduction, hexagon_height, cut_segment_length, segment_thickness, z_rotation, upAngle)
{
    rotate([0,0,z_rotation])
        translate([0,vertex_radius-vertex_radius_reduction,hexagon_height/4])
        rotate([0,upAngle,0])
        cylinder(h=cut_segment_length, r=segment_thickness/2, center=true);
}

module makeSupportLayer(num_sides, slice_angle, vertex_radius, vertex_radius_reduction, hexagon_height, cut_segment_length, segment_thickness, height, isOdd)
{
    offset_angle = slice_angle / 2;
    translate([0, 0, height])
    {
        for(i = [0:num_sides-1])
        {
            if(i % 2 == isOdd)
            {
                makeSupport(slice_angle, vertex_radius, vertex_radius_reduction, hexagon_height, cut_segment_length, segment_thickness, (slice_angle*i) + offset_angle, -30);
            }
            else
            {
                makeSupport(slice_angle, vertex_radius, vertex_radius_reduction, hexagon_height, cut_segment_length, segment_thickness, (slice_angle*i) + offset_angle, 30);
            }

        }
    }
}

module prototype_tube(num_sides, face_length, vertex_length, layers)
{
    slice_angle = 360 / num_sides;
    vertex_angle = (num_sides - 2) * 180 / num_sides;
    
    segment_radius = face_length / (2 * tan(slice_angle/2));
    vertex_radius = face_length / (2 * sin(slice_angle/2));
    
    cut_segment_length = face_length / ((1 / (2 * sin(vertex_angle/2))) + 1);
    vertex_radius_reduction = cut_segment_length / (4 * tan(vertex_angle/2));
    
    hexagon_height = sqrt(3) * cut_segment_length;
    layer_height = hexagon_height / 2;
    
    // horizontal segments
    for(layer = [0:layers-1])
    {
        if(layer % 2 == 0)
        {
            makeLayer(num_sides, slice_angle, segment_radius, cut_segment_length, segment_thickness,
                layer * layer_height, 0);
        }
        else
        {
            makeLayer(num_sides, slice_angle, segment_radius, cut_segment_length, segment_thickness,
                layer * layer_height, 1);
        }
    }

    // support segments
    for(supportLayer = [0:layers-2])
    {
        if(supportLayer % 2 == 0)
        {
            makeSupportLayer(num_sides, slice_angle, vertex_radius, vertex_radius_reduction, hexagon_height, cut_segment_length, segment_thickness, supportLayer * layer_height, 0);
        }
        else
        {
            makeSupportLayer(num_sides, slice_angle, vertex_radius, vertex_radius_reduction, hexagon_height, cut_segment_length, segment_thickness, supportLayer * layer_height, 1);
        }
        
    }
}



segment_length = 8;
vertex_length = 1.5;
num_sides = 24;
layers = 16;

prototype_tube(num_sides, segment_length, vertex_length, layers);
base_height = 2;
translate([0,0,-base_height])
cylinder(r1=35, r2=32, h=base_height);