include <braille.scad>;
include <common.scad>;

line1 = [dots_ba, dots_ta, dots_bar, dots_sho, dots_u, dots_yu, dots_a, dots_ji];
line1_ja = "バターしょうゆあじ";

$fn = 25;
padding = 2;
dots_width = 4;
dots_height = 6;
letter_height = dots_height - 1;
word_length = get_word_length(line1, len(line1)) * (dots_width + 1);

tag_length = word_length + (padding * 3);

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
        }
    }
    translate([padding, tag_thickness * -1, 0]) {
        write_braille();
    }
}
draw_tag();


module draw_clip(clip_rad) {
    // Springy part of the clip
    difference() {
        translate([-0.5, clip_rad - tag_thickness, 0]) {
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
    
    // Diagonal part of the clip
    translate([2.6, 11.2, 0]) {
        rotate(-45) {
            cube([11.6, tag_thickness, tag_width]);
        }
    }
    
    // Text part of the clip
    translate([10.8, padding + 1, 0]) {
        difference() {
            union() {
                cube([tag_length, tag_thickness, tag_width]);
                translate([tag_length, tag_thickness / 2, 0]) {
                    cylinder(d = tag_thickness, h = tag_width);
                }
            }
            write_text();
        }
    }
}
draw_clip(8);

module draw_grips(grip_rad) {
    translate([12, 0.3, 0]) {
        rotate(90) {
            cylinder(r = grip_rad, h = tag_width, $fn = 3);
        }
    }
    translate([6 + (tag_length - padding) / 2, padding + 0.5, 0]) {
     rotate(270) {
            cylinder(r = grip_rad, h = tag_width, $fn = 3);
        }
    }
    translate([tag_length - padding, 0.7, 0]) {
        rotate(90) {
            cylinder(r = grip_rad, h = tag_width, $fn = 3);
        }
    }
}
draw_grips(2);


module write_braille() {
    for (i = [0:len(line1) - 1]) {
        translate([padding + (get_word_length(line1, i) * (dots_width + 1)), 0, padding]) {
            draw_dots(line1[i]);
        }
    }
}


module write_text() {
    pos_z = (tag_width - letter_height) / 2;
    translate([tag_length - padding, tag_thickness / 2, pos_z]) {
        rotate([-90, 180, 0]) {
            linear_extrude(tag_thickness) {
            text(line1_ja, letter_height, "Corporate Logo Rounded:style=Bold", spacing = 1.1);
            }
        }
    }
}

