include <braille.scad>;
include <common.scad>;

line1 = [dots_ka, dots_mo, dots_mi, dots_bar, dots_ru];
line2 = [];
line1_ja = "カモミール";
line2_ja = "";

$fn = 25;
holerad = 3;
padding = 2;
dots_width = 4;
dots_height = 6;
letter_height = dots_height - 1;

word_length = len(line1) > len(line2) ? get_word_length(line1, len(line1)) * (dots_width + 1) : get_word_length(line2, len(line2)) * (dots_width + 1);
tag_length = word_length + (padding * 5);

tag_width = len(line2) > 0 ? (dots_height * 2) + (padding * 3) : dots_height + (padding * 2);
tag_thickness = 3;
text_thickness = 2;


module draw_tag() {
    difference() {
        union() {
            cube([tag_length, tag_thickness, tag_width]);
            translate([0, tag_thickness, tag_width / 2]) {
                rotate([90, 0, 0]) {
                        scale([(holerad * 3) / tag_width, 1])cylinder(d = tag_width, h = tag_thickness);
                }
            }
        }
        // Hole
        translate([padding / 2, tag_thickness * 1.1, tag_width / 2]) {
            rotate([90, 0, 0]) {
                cylinder(r = holerad, h = tag_thickness * 1.2);
            }
        }
        write_text();
    }
    
    translate([tag_length, tag_thickness / 2, 0]) {
        cylinder(d = tag_thickness, h = tag_width);
    }
    
    translate([padding * 3, -1, 0]) {
        write_braille();
    }
}
draw_tag();



module write_braille() {
    // Print a single line
    for (i = [0:len(line1) - 1]) {
        translate([padding + (get_word_length(line1, i) * (dots_width + 1)), 0, tag_width - dots_height - padding]) {
            draw_dots(line1[i]);
        }
    }
    if (len(line2) > 0) {
        // Print the second line
        for (i = [0:len(line2) - 1]) {
            translate([padding + (get_word_length(line2, i) * (dots_width + 1)), 0, padding]) {
                draw_dots(line2[i]);
            }
        }
    }
}

module write_text() {
    rotate([-90, 180, 0]) {
        // Print a single line
        pos_x = (tag_length - padding) * -1;
        pos_y = tag_thickness - 1;
        translate([pos_x, tag_width - dots_height - padding, pos_y]) {
            linear_extrude(tag_thickness) {
                text(line1_ja, letter_height, "Corporate Logo Rounded:style=Bold", spacing = 1.1);
            }
        }
        if (len(line2) > 0) {
            // Print the second line
            translate([pos_x, padding, pos_y]) {
                linear_extrude(text_thickness) {
                    text(line2_ja, letter_height, "Corporate Logo Rounded:style=Bold", spacing = 1.1);
                }
            }
        }
    }
}
