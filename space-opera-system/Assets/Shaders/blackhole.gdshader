shader_type spatial;
render_mode unshaded, depth_draw_opaque;
uniform sampler2D screen_tex  : hint_screen_texture;
uniform sampler2D depth_tex   : hint_depth_texture;
uniform float    scale;
uniform float lens_radius;       // e.g. 0.25

// --- NEW: all the holes in one material! up to 4 of them.
uniform vec3     black_hole_positions[4];
uniform vec3 black_hole_colors[4]:source_color;
uniform float    black_hole_sizes[4];
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

// Smooth falloff function to avoid hard clamping
float smooth_falloff(float x, float edge_start, float edge_end) {
    return smoothstep(edge_end, edge_start, x);
}

// Safe UV sampling with smooth edge handling
vec3 sample_screen_safe(sampler2D tex, vec2 uv) {
    // Calculate distance from UV boundaries
    vec2 edge_dist = min(uv, 1.0 - uv);
    float min_edge_dist = min(edge_dist.x, edge_dist.y);
    
    // Fade to black near edges instead of hard clamping
    float edge_fade = smooth_falloff(min_edge_dist, 0.1, 0.02);
    
    // Clamp UV but allow some bleeding for smoother transitions
    vec2 safe_uv = clamp(uv, 0.001, 0.999);
    vec3 color = texture(tex, safe_uv).rgb;
    
    return color * edge_fade;
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
                black_hole_sizes[i] * scale * 0.3,
                t
            ) && t < nearest_t) {
            nearest_t = t;
            hit_idx   = i;
        }
    }

    // 3) choose color: inside = solid hole, outside = warped background
    vec3 out_col;
    if (hit_idx >= 0) {
        // inside the hole → flat color with proper depth
        out_col = black_hole_colors[hit_idx];
        
        // Set depth to the actual intersection point on the black hole surface
        vec3 intersection_point = CAMERA_POSITION_WORLD + ray_dir * nearest_t;
        vec4 intersection_view = VIEW_MATRIX * vec4(intersection_point, 1.0);
        vec4 intersection_clip = PROJECTION_MATRIX * intersection_view;
        float intersection_depth = intersection_clip.z / intersection_clip.w;
        // Convert to depth buffer format
        DEPTH = intersection_depth * 0.5 + 0.5;
    } else {
        // outside: do your lensing with improved smoothing
        vec2 total_disp = vec2(0.0);
        float fov = atan(-1.0 / PROJECTION_MATRIX[1][1] * 2.0);

        for (int i = 0; i < black_hole_count; ++i) {
            vec4 hole_vs = VIEW_MATRIX * vec4(black_hole_positions[i], 1.0);
            if (hole_vs.z >= 0.0) continue;  // behind camera

            vec4 hole_cs = PROJECTION_MATRIX * hole_vs;
            vec2 bh_uv   = (hole_cs.xy / hole_cs.w) * 0.5 + 0.5;
            
            // Calculate screen-space direction and distance
            vec2 screen_dir = bh_uv - SCREEN_UV;
            float screen_dist = length(screen_dir);
            
            // Skip if too far away to avoid unnecessary computation
            if (screen_dist > 2.0) continue;
            
            vec2 dir2d = normalize(screen_dir);
            
            // Improved falloff calculation
            float world_dist = length(black_hole_positions[i] - CAMERA_POSITION_WORLD);
            float angular_size = (black_hole_sizes[i] * scale) / world_dist;
            
            // Use both fresnel and distance-based falloff
            float f = 1.0 - fresnel_term(0.8, NORMAL, VIEW);
            float dist_falloff = 1.0 / (1.0 + screen_dist * screen_dist * 4.0);
            
            // Calculate displacement with improved scaling
            float displacement_strength = f * dist_falloff * angular_size * 0.5;
            vec2 local_disp = dir2d * displacement_strength;
            
            total_disp += local_disp;
        }

        // Improved smoothing - use tanh for smooth limiting instead of hard clamping
        float disp_magnitude = length(total_disp);
        vec2 smooth_disp = total_disp;
        
        if (disp_magnitude > 0.001) {
            // Use tanh for smooth limiting - prevents sudden jumps
            float max_disp = 0.8;
            float smooth_magnitude = tanh(disp_magnitude / max_disp) * max_disp;
            smooth_disp = normalize(total_disp) * smooth_magnitude;
        }

        // Calculate final UV with smooth displacement
        vec2 final_uv = SCREEN_UV + smooth_disp;
        
        // Hybrid approach: blend between original and distorted view
        vec3 distorted_color = sample_screen_safe(screen_tex, final_uv);
        vec3 original_color = texture(screen_tex, SCREEN_UV).rgb;
        
        // Blend based on how extreme the displacement is
        float blend_factor = smoothstep(0.3, 0.6, length(smooth_disp));
        out_col = mix(original_color, distorted_color, blend_factor);
    }

    ALBEDO = out_col;
}