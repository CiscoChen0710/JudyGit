// === 参数设置 ===
house_radius = 30;
house_height = 30;
wall_thickness = 3;

roof_radius = 40;
roof_height = 20;

door_width = 20;
door_height = 25;

window_radius = 5;


module triangle_prism(size=6, depth=8, up=true) {
    points = up ? [[0,0], [size,0], [size/2, size*sqrt(3)/2]]
                : [[0,size*sqrt(3)/2], [size,size*sqrt(3)/2], [size/2, 0]];
    linear_extrude(height=depth)
        polygon(points);
}


module wall_with_cutouts() {
    difference() {

        cylinder(h = house_height, r = house_radius, $fn = 100);

  
        triangle_size = 8;
        triangle_rows = 3;
        triangles_per_row = 18;

        for (row = [0 : triangle_rows - 1]) {
            z_level = row * (house_height / triangle_rows) + 2;
            up = (row % 2 == 0);

            for (i = [0 : triangles_per_row - 1]) {
                angle = 360 * i / triangles_per_row;
                rotate([0, 0, angle])
                    translate([-1.5, 0, z_level])
                        translate([house_radius - wall_thickness / 2 - 2, 0, 0])
                            rotate([90, 0, 90])
                                triangle_prism(size=triangle_size, depth=8, up=up);
            }
        }

        translate([0, -house_radius + 5, 2])
            rotate([90, 0, 0])
                cylinder(h = house_radius, r = door_width / 2, $fn = 100);
    }
}


module mushroom_roof_with_rays() {
    difference() {

        scale([1, 1, roof_height / roof_radius])
            intersection() {
                sphere(r = roof_radius, $fn = 100);
                translate([0, 0, roof_radius / 2])
                    cube([2 * roof_radius, 2 * roof_radius, roof_radius], center = true);
            }

        for (angle = [0 : 30 : 330]) {
            for (step = [0 : 1 : 8]) {
                t = step / 8;
                r = roof_radius * (0.75 - 0.6 * t);
                z = roof_height * pow(t, 0.8);

                x = r * cos(angle);
                y = r * sin(angle);

                dx = -cos(angle);
                dy = -sin(angle);
                dz = 0.5;

                a = atan2(dy, dx);
                b = atan2(dz, sqrt(dx * dx + dy * dy));

                translate([x, y, z])
                    rotate([0, -b, a])
                        cube([roof_radius * 1, 2, 15], center = true);
            }
        }
    }
}


module cylindrical_ring(outer_r = 10, inner_r = 8, height = 5) {
    difference() {
        cylinder(r = outer_r, h = height, $fn = 100);
        translate([0, 0, -0.1]) 
            cylinder(r = inner_r, h = height + 0.2, $fn = 100);
    }
}


difference() {
    union() {
        wall_with_cutouts();


        intersection() {
            translate([0, -26, 2])
                rotate([90, 0, 0])
                    cylindrical_ring(outer_r = 12, inner_r = 9, height = 4);

            cylinder(h = house_height, r = house_radius, $fn = 100);
        }
    }


    translate([0, 0, wall_thickness])
        cylinder(h = house_height, r = house_radius - wall_thickness, $fn = 100);


    translate([-50, -50, -10])
        cube([100, 100, 10]);
}


translate([0, 0, house_height])
    mushroom_roof_with_rays();



