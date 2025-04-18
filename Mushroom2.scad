house_radius = 30;
house_height = 30;
wall_thickness = 3;

roof_radius = 40;
roof_height = 20;

door_width = 20;
door_height = 25;

window_radius = 5;

module hexagon(size) {
    points = [
        for(i = [0:5]) [cos(i*60)*size, sin(i*60)*size]
    ];
    polygon(points);
}

module wall_with_cutouts() {
    difference() {
        cylinder(h = house_height, r = house_radius, $fn = 100);

        hex_size = 4;
        rows = 10;
        cols = 20;
        spacing = hex_size * 1.75;

        for (row = [0:rows]) {
            y_offset = row * spacing * sin(60);
            x_offset = (row % 2 == 0) ? 0 : spacing / 2;
            for (col = [0:cols]) {
                angle = 360 * col / cols;
                rotate([0, 0, angle])
                    translate([house_radius - wall_thickness / 2 - 1, 0, row * 2])
                        rotate([90, 0, 90])
                            linear_extrude(height=8)
                                hexagon(hex_size);
            }
        }

        translate([0, -house_radius + 5, 2])
            rotate([90, 0, 0])
                cylinder(h = house_radius, r = door_width / 2, $fn = 100);
    }
}

module star_roof_pattern() {
    difference() {
        scale([1, 1, roof_height / roof_radius])
            intersection() {
                sphere(r = roof_radius, $fn = 100);
                translate([0, 0, roof_radius / 2])
                    cube([2 * roof_radius, 2 * roof_radius, roof_radius], center = true);
            }

        for (angle = [0:30:330]) {
            for (step = [0 : 1 : 6]) {
                t = step / 6;
                r = roof_radius * (0.8 - 0.6 * t);
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
                        rotate([0, 0, 45])
                            cube([4, 1.5, 10], center = true);
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
    star_roof_pattern();