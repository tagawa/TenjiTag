include <braille.scad>;

line1 = [dots_ma, dots_n, dots_de, dots_ri, dots_n, dots_ri, dots_n];
line1_ja = "うすしおあじ";


// Calculate the length of the braille word up to a certain number of characters
function get_word_length(word, stop) = (stop < 1 ? 0 : len(word[stop - 1]) + get_word_length(word, stop - 1));

$fn = 25;
padding = 2;
dots_width = 4;
dots_height = 6;
tag_length = padding + get_word_length(line1, len(line1));
tag_width = dots_height + (padding * 2);
tag_thickness = 2;
text_thickness = 2;

module draw_tag() {
    rotate([90, 0, 0]) {
        difference() {
            union() {
                cube([tag_length, tag_width, tag_thickness]);
                translate([tag_length, tag_width, tag_thickness / 2]) {
                    rotate([90, 0, 0]) {
                        cylinder(d = tag_thickness, h = tag_width);
                    }
                }
            }
            //write_text();
        }
        write_braille();
    }
}
draw_tag();



module draw_clip(clip_rad) {
    // Springy part of the clip
    difference() {
        translate([-1, clip_rad - tag_thickness, 0]) {
            difference() {
                cylinder(r = clip_rad, h = tag_width);
                cylinder(r = clip_rad - 2, h = tag_width);
            }
        }
        translate([(clip_rad * 1.5), clip_rad, 0]) {
            rotate(90) {
                cylinder(r = clip_rad * 2, h = tag_width, $fn = 3);
            }
        }
    }
    
    // Straight part of the clip
    translate([4, 14.2, 0]) {
        rotate(-45) {
            cube([15, tag_thickness, tag_width]);
        }
    }
    
    // End part of the clip
    difference() {
        translate([21.8, clip_rad + 0.5, 0]) {
            difference() {
                cylinder(r = clip_rad, h = tag_width);
                cylinder(r = clip_rad - 2, h = tag_width);
            }
        }
        translate([20, 24, 0]) {
            rotate(45) {
                cylinder(r = 20, h = tag_width, $fn = 5);
            }
        }
    }
    
    translate([30.7, 11.4, 0]) {
        cylinder(d = tag_thickness, h = tag_width);
    }
}
draw_clip(10);

module draw_grip(grip_rad) {
    translate([15.5, 0, 0]) {
        rotate(90) {
            cylinder(r = grip_rad, h = tag_width, $fn = 3);
        }
    }
    translate([28, 0, 0]) {
        rotate(90) {
            cylinder(r = grip_rad, h = tag_width, $fn = 3);
        }
    }
}
draw_grip(2);

module draw_wedge(wedge_rad) {
    translate([(wedge_rad / 1.5), wedge_rad / 2, 0]) {
        rotate(90) {
            cylinder(r = wedge_rad, h = tag_width, $fn = 3);
        }
    }
}
//draw_wedge(10);


module draw_dots(arr) {
    translate([0, 0, tag_thickness - 1]) {
        cube([dots_width, dots_height, 1]);
        // Top left
        translate([1, 5, 1]) {
            sphere(d = arr[0]);
        }
        // Top right
        translate([3, 5, 1]) {
            sphere(d = arr[1]);
        }
        // Middle left
        translate([1, 3, 1]) {
            sphere(d = arr[2]);
        }
        // Middle right
        translate([3, 3, 1]) {
            sphere(d = arr[3]);
        }
        // Bottom left
        translate([1, 1, 1]) {
            sphere(d = arr[4]);
        }
        // Bottom right
        translate([3, 1, 1]) {
            sphere(d = arr[5]);
        }
    }
    if (len(arr) > 6) {
        translate([6, 0, tag_thickness - 1]) {
            cube([dots_width, 6, 1]);
            // Top left
            translate([1, 5, 1]) {
                sphere(d = arr[6]);
            }
            // Top right
            translate([3, 5, 1]) {
                sphere(d = arr[7]);
            }
            // Middle left
            translate([1, 3, 1]) {
                sphere(d = arr[8]);
            }
            // Middle right
            translate([3, 3, 1]) {
                sphere(d = arr[9]);
            }
            // Bottom left
            translate([1, 1, 1]) {
                sphere(d = arr[10]);
            }
            // Bottom right
            translate([3, 1, 1]) {
                sphere(d = arr[11]);
            }
        }
    }
}

module write_braille() {
    for (i = [0:len(line1) - 1]) {
        translate([padding + get_word_length(line1, i), padding, 0]) {
            draw_dots(line1[i]);
        }
    }
}


module write_text() {
    posy = (tag_width - dots_height) / 2;
    translate([tag_length - padding, posy, text_thickness - 1]) {
        rotate([0, 180, 0]) {
            linear_extrude(text_thickness) {
            text(line1_ja, dots_height, "Corporate Logo Rounded:style=Bold");
            }
        }
    }
}


