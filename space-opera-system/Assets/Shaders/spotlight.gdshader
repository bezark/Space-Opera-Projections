shader_type canvas_item;
render_mode unshaded;

uniform float circle_width = 0.5;    // your half-width of the pill
uniform float circle_height = 0.3;   // radius of the pill ends (and half-height)
uniform float feather = 0.05;
uniform vec2 circle_position = vec2(0.5, 0.5);
uniform float screen_width = 1920.0;
uniform float screen_height = 1080.0;

void fragment() {
    // compensate for non-square viewports
    float ratio = screen_width / screen_height;
    vec2 adj_uv = vec2(mix(circle_position.x, UV.x, ratio), UV.y);

    // vector from center
    vec2 p = adj_uv - circle_position;

    // half-length of the center rectangle
    float halfRect = max(circle_width - circle_height, 0.0);

    // distance to the “capsule” segment:
    //   q.x = how far outside the rect you are horizontally
    //   q.y = your vertical offset
    vec2 q = vec2(max(abs(p.x) - halfRect, 0.0), p.y);

    // normalized distance (<=1 means inside the pill)
    float dist = length(q) / circle_height;

    // feathered edge just like your original
    float edge0 = 1.0 - feather;
    float edge1 = 1.0 + feather;
    COLOR.a = smoothstep(edge0, edge1, dist);
}
