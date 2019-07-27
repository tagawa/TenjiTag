
// Calculate the length of the braille word up to a certain number of characters
function get_word_length(word, stop) = (stop < 1 ? 0 : (len(word[stop - 1]) / 6) + get_word_length(word, stop - 1));

module draw_dots(arr) {
    translate([0, tag_thickness - 1, 0]) {
        translate([0, -1, 0]) {
            cube([dots_width, 1, dots_height]);
        }
        // Top left
        translate([1, -arr[0], 5]) {
            sphere(r = 0.5);
        }
        // Top right
        translate([3, -arr[1], 5]) {
            sphere(r = 0.5);
        }
        // Middle left
        translate([1, -arr[2], 3]) {
            sphere(r = 0.5);
        }
        // Middle right
        translate([3, -arr[3], 3]) {
            sphere(r = 0.5);
        }
        // Bottom left
        translate([1, -arr[4], 1]) {
            sphere(r = 0.5);
        }
        // Bottom right
        translate([3, -arr[5], 1]) {
            sphere(r = 0.5);
        }
    }
    if (len(arr) > 6) {
        translate([dots_width + 1, tag_thickness - 1, 0]) {
            translate([0, -1, 0]) {
                cube([dots_width, 1, 6]);
            }
            // Top left
            translate([1, -arr[6], 5]) {
                sphere(r = 0.5);
            }
            // Top right
            translate([3, -arr[7], 5]) {
                sphere(r = 0.5);
            }
            // Middle left
            translate([1, -arr[8], 3]) {
                sphere(r = 0.5);
            }
            // Middle right
            translate([3, -arr[9], 3]) {
                sphere(r = 0.5);
            }
            // Bottom left
            translate([1, -arr[10], 1]) {
                sphere(r = 0.5);
            }
            // Bottom right
            translate([3, -arr[11], 1]) {
                sphere(r = 0.5);
            }
        }
    }
}
