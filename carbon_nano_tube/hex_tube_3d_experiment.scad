$fn = 8;

VERTEX_THICKNESS = 1.5;
SEGMENT_THICKNESS = 1;
SEGMENT_LENGTH = 6;

module dumbbell()
{
    render() { // cache this object for future calls
        union() { // union early to "swallow" internal verticies
            rotate([0,90,0])
                cylinder(h=SEGMENT_LENGTH, r=SEGMENT_THICKNESS/2, center=true);
            translate([SEGMENT_LENGTH/2,0,0])
                sphere(r=VERTEX_THICKNESS/2);
            translate([-SEGMENT_LENGTH/2,0,0])
                sphere(r=VERTEX_THICKNESS/2);
        }
    }
}

module makeLayer(num_sides, slice_angle, segment_radius, height, isOdd)
{
    translate([0, 0, height])
    {
        for(i = [0:num_sides-1])
        {
            if(i % 2 == isOdd)
            {
                rotate([0,0,slice_angle*i])
                    translate([0,segment_radius,0])
                    dumbbell();
            }
        }
    }
}

module makeSupport(slice_angle, vertex_radius, vertex_radius_reduction, hexagon_height, z_rotation, upAngle)
{
    rotate([0,0,z_rotation])
        translate([0,vertex_radius-vertex_radius_reduction,hexagon_height/4])
        rotate([0,upAngle,0])
        cylinder(h=SEGMENT_LENGTH, r=SEGMENT_THICKNESS/2, center=true);
}

module makeSupportLayer(num_sides, slice_angle, vertex_radius, vertex_radius_reduction, hexagon_height, height, isOdd)
{
    offset_angle = slice_angle / 2;
    translate([0, 0, height])
    {
        for(i = [0:num_sides-1])
        {
            if(i % 2 == isOdd)
            {
                makeSupport(slice_angle, vertex_radius, vertex_radius_reduction, hexagon_height, (slice_angle*i) + offset_angle, -30);
            }
            else
            {
                makeSupport(slice_angle, vertex_radius, vertex_radius_reduction, hexagon_height, (slice_angle*i) + offset_angle, 30);
            }

        }
    }
}

module prototype_tube(num_sides, layers)
{
    slice_angle = 360 / num_sides;
    vertex_angle = (num_sides - 2) * 180 / num_sides;
    
    face_length = SEGMENT_LENGTH * ((1 / (2 * sin(vertex_angle/2))) + 1);
    
    segment_radius = face_length / (2 * tan(slice_angle/2));
    vertex_radius = face_length / (2 * sin(slice_angle/2));
    echo("Tube has diameter ", vertex_radius * 2);
    
    vertex_radius_reduction = SEGMENT_LENGTH / (4 * tan(vertex_angle/2));
    
    hexagon_height = sqrt(3) * SEGMENT_LENGTH;
    layer_height = hexagon_height / 2;
    
    // horizontal segments
    for(layer = [0:layers-1])
    {
        if(layer % 2 == 0)
        {
            makeLayer(num_sides, slice_angle, segment_radius, layer * layer_height, 0);
        }
        else
        {
            makeLayer(num_sides, slice_angle, segment_radius, layer * layer_height, 1);
        }
    }

    // support segments
    for(supportLayer = [0:layers-2])
    {
        if(supportLayer % 2 == 0)
        {
            makeSupportLayer(num_sides, slice_angle, vertex_radius, vertex_radius_reduction, hexagon_height, supportLayer * layer_height, 0);
        }
        else
        {
            makeSupportLayer(num_sides, slice_angle, vertex_radius, vertex_radius_reduction, hexagon_height, supportLayer * layer_height, 1);
        }
        
    }
}

num_sides = 4;
layers = 4;

prototype_tube(num_sides, layers);
base_height = 2;
//translate([0,0,-base_height])
//    cylinder(r1=35, r2=32, h=base_height);