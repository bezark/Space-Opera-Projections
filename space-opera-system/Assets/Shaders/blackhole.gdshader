shader_type spatial;
render_mode unshaded, depth_draw_never;
uniform sampler2D screen_tex  : hint_screen_texture;
uniform sampler2D depth_tex   : hint_depth_texture;
uniform float    scale;
uniform float lens_radius;       // e.g. 0.25
//uniform vec3     hole_color   : source_color;

// --- NEW: all the holes in one material! up to 4 of them. 
uniform vec3     black_hole_positions[4];
uniform vec3 black_hole_colors[4]:source_color;
uniform int      black_hole_count;

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
    // 1) rebuild world‐pos & ray
    float depth = texture(depth_tex, SCREEN_UV).x;
    vec3 frag_p = get_world_position_from_uv(
        SCREEN_UV, depth,
        INV_PROJECTION_MATRIX,
        INV_VIEW_MATRIX
    );
    vec3 ray_dir = normalize(frag_p - CAMERA_POSITION_WORLD);

    // 2) find nearest horizon intersection
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

    // 3) choose color: inside = solid hole, outside = warped background
    vec3 out_col;
    if (hit_idx >= 0) {
        // inside the hole → flat color (and depth is written by depth_draw_opaque)
        out_col = black_hole_colors[hit_idx];
    } else {
        // outside: do your lensing
        vec2 total_disp = vec2(0.0);
        float fov = atan(-1.0 / PROJECTION_MATRIX[1][1] * 2.0);

        for (int i = 0; i < black_hole_count; ++i) {
            vec4 hole_vs = VIEW_MATRIX * vec4(black_hole_positions[i], 1.0);
            if (hole_vs.z >= 0.0) continue;  // behind camera

            vec4 hole_cs = PROJECTION_MATRIX * hole_vs;
            vec2 bh_uv   = (hole_cs.xy / hole_cs.w) * 0.5 + 0.5;
            vec2 dir2d   = normalize(bh_uv - SCREEN_UV) * 0.5;
            float f      = 1.0 - fresnel_term(0.5, NORMAL, VIEW);
            float dist   = length(black_hole_positions[i] - CAMERA_POSITION_WORLD);
            float s      = (2.0 * dist * tan(fov * 0.5)) / scale;
            total_disp  += dir2d * (f / s);
        }

        // clamp the displacement so we never sample outside [0,1]
        vec2 min_disp  = -SCREEN_UV;
        vec2 max_disp  = vec2(1.0) - SCREEN_UV;
        vec2 safe_disp = clamp(total_disp, min_disp, max_disp);

        vec2 uv = SCREEN_UV + safe_disp;
        out_col = texture(screen_tex, uv).rgb;
    }

    ALBEDO = out_col;
}
