shader_type spatial;
render_mode unshaded, depth_draw_opaque, blend_mix, cull_disabled;

uniform sampler2D screen_tex  : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D depth_tex   : hint_depth_texture, filter_linear_mipmap;
uniform float    scale = 1.0;

// --- all the holes in one material! up to 4 of them.
uniform vec3     black_hole_positions[4];
uniform vec3     black_hole_colors[4]:source_color;
uniform float    black_hole_sizes[4];
uniform int      black_hole_count;

// NEW: Toggle for skybox mode (when camera is inside the sphere)
uniform bool     skybox_mode = false;

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

// Safe UV sampling with transparency for out-of-bounds
vec4 sample_screen_safe(sampler2D tex, vec2 uv) {
    // If UV is out of bounds, return transparent
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        return vec4(0.0, 0.0, 0.0, 0.0);
    }

    // Calculate distance from UV boundaries
    vec2 edge_dist = min(uv, 1.0 - uv);
    float min_edge_dist = min(edge_dist.x, edge_dist.y);

    // Fade to transparent near edges
    float edge_fade = smooth_falloff(min_edge_dist, 0.1, 0.02);

    // Sample the texture
    vec3 color = texture(tex, uv).rgb;

    return vec4(color, edge_fade);
}

void fragment() {
    // Get the depth of the scene behind this fragment
    float scene_depth = texture(depth_tex, SCREEN_UV).x;

    // For skybox mode, we need different depth handling
    if (!skybox_mode) {
        // Original depth check for external sphere
        vec3 scene_ndc = vec3(SCREEN_UV * 2.0 - 1.0, scene_depth);
        vec4 scene_view = INV_PROJECTION_MATRIX * vec4(scene_ndc, 1.0);
        float scene_linear_depth = -scene_view.z / scene_view.w;
        float fragment_linear_depth = -VERTEX.z;

        if (scene_linear_depth < fragment_linear_depth - 0.01) {
            discard;
        }
    }

    // Calculate ray direction based on mode
    vec3 ray_origin;
    vec3 ray_dir;

    if (skybox_mode) {
        // For skybox mode, ray goes from camera through the pixel
        ray_origin = CAMERA_POSITION_WORLD;
        // Use the world position of the fragment on the skybox sphere
        vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
        ray_dir = normalize(world_pos - CAMERA_POSITION_WORLD);
    } else {
        // Original calculation for external sphere
        vec3 frag_p = get_world_position_from_uv(
            SCREEN_UV, scene_depth,
            INV_PROJECTION_MATRIX,
            INV_VIEW_MATRIX
        );
        ray_origin = CAMERA_POSITION_WORLD;
        ray_dir = normalize(frag_p - CAMERA_POSITION_WORLD);
    }

    // find nearest horizon intersection
    float nearest_t = 1e20;
    int   hit_idx   = -1;
    for (int i = 0; i < black_hole_count; ++i) {
        float t;
        if (hit_sphere(
                ray_origin,
                ray_dir,
                black_hole_positions[i],
                black_hole_sizes[i] * 0.3,
                t
            ) && t < nearest_t) {
            nearest_t = t;
            hit_idx   = i;
        }
    }

    // choose color: inside = solid hole, outside = warped background
    vec4 out_col;
    if (hit_idx >= 0) {
        // inside the hole → flat color with proper depth
        out_col = vec4(black_hole_colors[hit_idx], 1.0);

        // Calculate the actual intersection point
        vec3 hit_point = ray_origin + ray_dir * nearest_t;

        // Transform hit point to view space
        vec4 hit_view = VIEW_MATRIX * vec4(hit_point, 1.0);

        // Transform to clip space
        vec4 hit_clip = PROJECTION_MATRIX * hit_view;

        // Calculate normalized device coordinates depth
        float ndc_depth = hit_clip.z / hit_clip.w;

        // Write the depth value
        DEPTH = ndc_depth * 0.5 + 0.5;

        if (!skybox_mode) {
            // Check if there's something in the scene closer than the black hole
            vec3 hole_center = black_hole_positions[hit_idx];
            float hole_radius = black_hole_sizes[hit_idx] * 0.3;

            // Get world position of what's behind at this screen position
            vec3 behind_world = get_world_position_from_uv(
                SCREEN_UV, scene_depth,
                INV_PROJECTION_MATRIX,
                INV_VIEW_MATRIX
            );

            // Check if the object behind is actually inside the black hole sphere
            float dist_to_center = length(behind_world - hole_center);

            // Convert scene depth to linear depth
            vec3 scene_ndc = vec3(SCREEN_UV * 2.0 - 1.0, scene_depth);
            vec4 scene_view = INV_PROJECTION_MATRIX * vec4(scene_ndc, 1.0);
            float scene_linear_depth = -scene_view.z / scene_view.w;

            // If there's an object closer than the black hole surface, discard
            if (scene_linear_depth < -hit_view.z && dist_to_center > hole_radius) {
                discard;
            }
        }

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
            float angular_size = black_hole_sizes[i] / world_dist;

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

        // Use safe sampling that returns transparency for out-of-bounds
        out_col = sample_screen_safe(screen_tex, final_uv);

        // If we got a transparent result, discard the fragment
        if (out_col.a < 0.01) {
            discard;
        }

        // For lensing effect in skybox mode, we write a far depth
        if (skybox_mode) {
            DEPTH = 0.999999;
        } else {
            DEPTH = scene_depth;
        }
    }

    ALBEDO = out_col.rgb;
    ALPHA = out_col.a;
}