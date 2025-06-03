shader_type canvas_item;
render_mode unshaded;

uniform float circle_width = 0.5;    // horizontal radius in UV-space
uniform float circle_height = 0.3;   // vertical radius in UV-space
uniform float feather = 0.05;
uniform vec2 circle_position = vec2(0.5, 0.5);
uniform float screen_width = 1920;
uniform float screen_height = 1080;

void fragment() {
    // keep the original hack that “stretches” UV.x by the screen aspect, so shapes look correct on non-square viewports
    float ratio = screen_width / screen_height;
    vec2 adjusted_uv = vec2(mix(circle_position.x, UV.x, ratio), UV.y);

    // compute normalized offset from center
    float dx = (adjusted_uv.x - circle_position.x) / circle_width;
    float dy = (UV.y - circle_position.y) / circle_height;
    float dist = length(vec2(dx, dy));

    // inside ellipse when dist <= 1; use smoothstep for the feather
    float edge_start = 1.0 - feather;
    float edge_end = 1.0 + feather;
    COLOR.a = smoothstep(edge_start, edge_end, dist);
}
