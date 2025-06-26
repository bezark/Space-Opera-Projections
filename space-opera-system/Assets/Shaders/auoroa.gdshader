shader_type spatial;
render_mode unshaded, depth_draw_never;
uniform sampler2D screen_tex  : hint_screen_texture;
uniform sampler2D depth_tex   : hint_depth_texture;
uniform float    scale;
uniform float lens_radius; 

// --- NEW: all the holes in one material! up to 4 of them. 
uniform vec3     black_hole_positions[4];
uniform vec3 black_hole_colors[4]:source_color;
uniform int      black_hole_count;

// updated hit_sphere that also spits back the nearest positive t
bool hit_sphere(vec3 ro, vec3 rd, vec3 so, float r, out float t_out) {
    vec3 oc = ro - so;
    float a = dot(rd, rd);
    float b = 2.0 * dot(rd, oc);
    float c = dot(oc, oc) - r*r;
    float disc = b*b - 4.0*a*c;
    if (disc < 0.0) return false;
    float sq = sqrt(disc);
    float t0 = (-b - sq) / (2.0 * a);
    float t1 = (-b + sq) / (2.0 * a);
    // pick the closest positive intersection
    t_out = (t0 > 0.0) ? t0 : ((t1 > 0.0) ? t1 : -1.0);
    return t_out > 0.0;
}


vec3 get_world_position_from_uv(vec2 uv, float depth,
                                mat4 inv_proj, mat4 inv_view) {
    vec4 ndc = vec4(uv * 2.0 - 1.0, depth, 1.0);
    vec4 view_p = inv_proj * ndc;
    view_p.xyz /= view_p.w;
    vec4 world_p = inv_view * vec4(view_p.xyz, 1.0);
    return world_p.xyz;
}

vec2 get_uv_from_world_position(vec3 wp, mat4 proj, mat4 view) {
    vec4 pos_v  = view * vec4(wp, 1.0);
    vec4 pos_cs = proj  * pos_v;
    vec2 ndc    = pos_cs.xy / pos_cs.w;
    return ndc * 0.5 + 0.5;
}

float fresnel_term(float power, vec3 N, vec3 V) {
    return pow(1.0 - clamp(dot(normalize(N), normalize(V)), 0.0, 1.0),
               power);
}
void fragment() {
    // 1) rebuild world‐position & ray
float depth = texture(depth_tex, SCREEN_UV).x;
vec3 frag_p = get_world_position_from_uv(
                  SCREEN_UV, depth,
                  INV_PROJECTION_MATRIX,
                  INV_VIEW_MATRIX
              );
vec3 ray_dir = normalize(frag_p - CAMERA_POSITION_WORLD);

// 2) find the *first* horizon intersection, if any
float nearest_t = 1e20;
int   hit_idx   = -1;
for (int i = 0; i < black_hole_count; ++i) {
    float t;
    if (hit_sphere(
            CAMERA_POSITION_WORLD,
            ray_dir,
            black_hole_positions[i],
            scale * 0.3,
            t
        ) && t < nearest_t) {
        nearest_t = t;
        hit_idx   = i;
    }
}

if (hit_idx >= 0) {
    // 3a) inside the nearest hole → paint its color
    ALBEDO = black_hole_colors[hit_idx];
}
else {
    // 3b) outside all horizons → do the combined lensing
    vec2 total_disp = vec2(0.0);
    float fov = atan(-1.0 / PROJECTION_MATRIX[1][1] * 2.0);

    for (int i = 0; i < black_hole_count; ++i) {
        vec2 bh_uv = get_uv_from_world_position(
                         black_hole_positions[i],
                         PROJECTION_MATRIX,
                         VIEW_MATRIX
                     );
        vec2 dir2d = normalize(bh_uv - SCREEN_UV) * 0.5;
        float f    = 1.0 - fresnel_term(0.5, NORMAL, VIEW);
        float dist = distance(
                         CAMERA_POSITION_WORLD,
                         black_hole_positions[i]
                     );
        float s    = (2.0 * dist * tan(fov * 0.5)) / scale;
        total_disp += dir2d * (f / s);
    }

    vec2 uv = SCREEN_UV + total_disp;
    ALBEDO  = texture(screen_tex, uv).rgb;
}
}
