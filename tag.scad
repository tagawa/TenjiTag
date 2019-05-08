include <braille.scad>;

line1 = [dots_ma, dots_n, dots_de, dots_ri, dots_n];
line2 = [];
line1_ja = "マンデリン";
line2_ja = "";

// Calculate the length of the braille word up to a certain number of characters
function get_word_length(word, stop) = (stop < 1 ? 0 : len(word[stop - 1]) + get_word_length(word, stop - 1));

$fn = 25;
holerad = 3;
padding = 2;
tagrad = holerad + padding;
dots_width = 4;
dots_height = 6;
tag_length = len(line1) > len(line2) ? tagrad + get_word_length(line1, len(line1)) : tagrad + get_word_length(line2, len(line2));
tag_width = len(line2) > 0 ? (dots_height * 2) + (padding * 3) : dots_height + (padding * 2);
tag_thickness = 3;
text_thickness = 2;

module draw_tag(tag_width) {
    translate([tagrad, 0, 0]) {
        difference() {
            union() {
                cube([tag_length, tag_width, tag_thickness]);
                translate([0, tag_width / 2, 0]) {
                    cylinder(r = tagrad, h = tag_thickness);
                }
                translate([tagrad * -1, 0, 0]) {
                    draw_polyhedron();
                }
                translate([tag_length, tag_width, tag_thickness / 2]) {
                    rotate([90, 0, 0]) {
                        cylinder(d = tag_thickness, h = tag_width);
                    }
                }
            }
            // Hole
            holepadding = len(line2) > 0 ? (padding * 2) * -1 : 0;
            translate([0, tag_width / 2, -1]) {
                cylinder(r = holerad, h = tag_thickness + 2);
            }
            write_text();
        }
        write_braille();
    }
}
draw_tag(tag_width);


module draw_polyhedron() {
    CubePoints = [
        [padding / 2,  tag_width / 3,  0 ],  //0
        [tagrad,  0,  0 ],  //1
        [tagrad,  tag_width,  0 ],  //2
        [padding / 2,  tag_width / 3 * 2,  0 ],  //3
        [padding / 2,  tag_width / 3,  tag_thickness],  //4
        [tagrad,  0,  tag_thickness],  //5
        [tagrad,  tag_width,  tag_thickness],  //6
        [padding / 2,  tag_width / 3 * 2,  tag_thickness]]; //7
        
    CubeFaces = [
        [0,1,2,3],  // bottom
        [4,5,1,0],  // front
        [7,6,5,4],  // top
        [5,6,2,1],  // right
        [6,7,3,2],  // back
        [7,4,0,3]]; // left

    polyhedron(
        points=CubePoints,                                 // the apex point 
        faces=CubeFaces                         // two triangles for square base
    );
}


module draw_dots(arr) {
    translate([0, 0, tag_thickness - 1]) {
        cube([dots_width, dots_height, 1]);
        // Top left
        translate([1, 5, arr[0]]) {
            sphere(r = 0.5);
        }
        // Top right
        translate([3, 5, arr[1]]) {
            sphere(r = 0.5);
        }
        // Middle left
        translate([1, 3, arr[2]]) {
            sphere(r = 0.5);
        }
        // Middle right
        translate([3, 3, arr[3]]) {
            sphere(r = 0.5);
        }
        // Bottom left
        translate([1, 1, arr[4]]) {
            sphere(r = 0.5);
        }
        // Bottom right
        translate([3, 1, arr[5]]) {
            sphere(r = 0.5);
        }
    }
    if (len(arr) > 6) {
        translate([6, 0, tag_thickness - 1]) {
            cube([dots_width, 6, 1]);
            // Top left
            translate([1, 5, arr[6]]) {
                sphere(r = 0.5);
            }
            // Top right
            translate([3, 5, arr[7]]) {
                sphere(r = 0.5);
            }
            // Middle left
            translate([1, 3, arr[8]]) {
                sphere(r = 0.5);
            }
            // Middle right
            translate([3, 3, arr[9]]) {
                sphere(r = 0.5);
            }
            // Bottom left
            translate([1, 1, arr[10]]) {
                sphere(r = 0.5);
            }
            // Bottom right
            translate([3, 1, arr[11]]) {
                sphere(r = 0.5);
            }
        }
    }
}

module write_braille() {
    if (len(line2) == 0) {
        // Print a single line
        for (i = [0:len(line1) - 1]) {
            translate([tagrad + get_word_length(line1, i), padding, 0]) {
                draw_dots(line1[i]);
            }
        }
    } else {
        // Print two lines
        posy = (padding * 2) + dots_height;
        for (i = [0:len(line1) - 1]) {
            translate([tagrad + get_word_length(line1, i), posy, 0]) {
                draw_dots(line1[i]);
            }
        }
        for (i = [0:len(line2) - 1]) {
            translate([tagrad + get_word_length(line2, i), padding, 0]) {
                draw_dots(line2[i]);
            }
        }
    }
}


module write_text() {
    if (len(line2_ja) == 0) {
        // Print a single line
        posy = (tag_width - dots_height) / 2;
        translate([tag_length - padding, posy, text_thickness - 1]) {
            rotate([0, 180, 0]) {
                linear_extrude(text_thickness) {
                text(line1_ja, dots_height, "Corporate Logo Rounded:style=Bold");
                }
            }
        }
    } else {
        // Print two lines
        gapy = (tag_width - (dots_height * 2)) / 3;
        posy1 = (gapy * 2) + dots_height;
        translate([tag_length - padding, posy1, text_thickness - 1]) {
            rotate([0, 180, 0]) {
                linear_extrude(text_thickness) {
                text(line1_ja, dots_height, "Corporate Logo Rounded:style=Bold");
                }
            }
        }
        translate([tag_length - padding, gapy, text_thickness - 1]) {
            rotate([0, 180, 0]) {
                linear_extrude(text_thickness) {
                text(line2_ja, dots_height, "Corporate Logo Rounded:style=Bold");
                }
            }
        }
    }
}


