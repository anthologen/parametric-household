// --- Input Variables ---
$fn = 16;

VERTEX_THICKNESS = 3;
SEGMENT_THICKNESS = 2;
SEGMENT_LENGTH = 10;
NUM_SIDES = 16; // only makes sense with even numbers
NUM_LAYERS = 10; 

// --- Intermediate Variables ---

g_slice_angle = 360 / NUM_SIDES;
g_vertex_angle = (NUM_SIDES - 2) * 180 / NUM_SIDES;
g_face_length = SEGMENT_LENGTH * ((1 / (2 * sin(g_vertex_angle/2))) + 1);
g_segment_radius = g_face_length / (2 * tan(g_slice_angle/2));
g_vertex_radius = g_face_length / (2 * sin(g_slice_angle/2));
echo("Tube has diameter ", g_vertex_radius * 2);
echo("Tube has height ", g_layer_height * NUM_LAYERS);

g_vertex_radius_reduction = SEGMENT_LENGTH / (4 * tan(g_vertex_angle/2));

g_hexagon_height = sqrt(3) * SEGMENT_LENGTH;
g_layer_height = g_hexagon_height / 2;

// --- Geometry ---

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

module makeHorizontals()
{
    render() {
        for(i = [0:2:NUM_SIDES-1])
        {
            rotate([0,0,g_slice_angle*i])
                translate([0,g_segment_radius,0])
                dumbbell();
        }
    }
}

module makeDiagonal(upAngle)
{
    translate([0,g_vertex_radius-g_vertex_radius_reduction,g_hexagon_height/4])
        rotate([0,upAngle,0])
        cylinder(h=SEGMENT_LENGTH, r=SEGMENT_THICKNESS/2, center=true);
}

module makeLeftDiagonal()
{
    render() makeDiagonal(-30);
}

module makeRightDiagonal()
{
    render() makeDiagonal(30);
}

module makeDiagonals()
{
    offset_angle = g_slice_angle / 2;
    for(i = [0:2:NUM_SIDES-1])
    {
        rotate([0,0,(g_slice_angle*i) + offset_angle])
            makeLeftDiagonal();
    }
    for(i = [1:2:NUM_SIDES-1])
    {
        rotate([0,0,(g_slice_angle*i) + offset_angle])
            makeRightDiagonal();
    }
}

module makeLayer()
{
    render()
    {
        makeHorizontals();
        makeDiagonals();
    }
}

module prototype_tube()
{
    for(layer = [0:NUM_LAYERS-1])
    {
        translate([0,0,layer * g_layer_height])
            rotate([0,0,layer * g_slice_angle])
            makeLayer();
    }
    translate([0,0, NUM_LAYERS * g_layer_height])
        rotate([0,0,(NUM_LAYERS % 2) * g_slice_angle])
        makeHorizontals();
}

prototype_tube();
base_height = 2;
translate([0,0,-base_height])
    cylinder(r1=42, r2=40, h=base_height, $fn=64);