shader_type spatial;
render_mode blend_add, unshaded, cull_back, shadows_disabled;


uniform vec4 color : source_color;
uniform float emission_strength = 1.0;
uniform float num_points : hint_range(1.0, 64.0, 1.0) = 4.0;
uniform sampler2D interpolation_curve : filter_linear, repeat_disable; // Sampled between each point, expects values between [0.0, 1.0]
uniform float mirrored : hint_range(0.0, 1.0, 1.0) = 0.0; // Enables mirrored curve sampling
uniform vec2 curve_clamp = vec2(0.0, 1.0); // Clamps the curve's sampled values, can be used as a mask
uniform vec2 edge_blur = vec2(0.0, 0.0); // Edge blurring using smoothstep
uniform float rotation = 0.0;
uniform vec2 rotation_center = vec2(0.0);
uniform vec2 uv_scale = vec2(1.0);
uniform vec2 uv_offset = vec2(0.0);


// https://theorangeduck.com/page/avoiding-shader-conditionals
float when_eq(float x, float y) {
  return 1.0 - abs(sign(x - y));
}

void vertex() {
	UV = UV * uv_scale.xy + uv_offset.xy;
}

void fragment() {
	vec2 centered_uv = (UV - 0.5) * 2.0;
	vec2 rotated_uv = vec2(
      cos(rotation) * (centered_uv.x - rotation_center.x) + sin(rotation) * (centered_uv.y - rotation_center.y) + rotation_center.x,
      cos(rotation) * (centered_uv.y - rotation_center.y) - sin(rotation) * (centered_uv.x - rotation_center.x) + rotation_center.y
    );

	vec2 UV_dir = normalize(rotated_uv);
	float UV_angle = (atan(UV_dir.y, UV_dir.x) + PI) * (180.0 / PI); // [0.0, 360.0]
	float modulo_value = 360.0 / num_points;
	float modulo_angle = mod(UV_angle, modulo_value); // [0.0, modulo_value]
	float modulo_angle_norm = modulo_angle / modulo_value; // Continuous sampling
	float dist_from_midpoint = abs(abs(modulo_angle - (modulo_value * 0.5)) / (modulo_value * 0.5) - 1.0); // Mirrored sampling

	float sample_value = modulo_angle_norm * when_eq(mirrored, 0.0) + dist_from_midpoint * when_eq(mirrored, 1.0); // Use selected sampling option
	float curve_value = texture(interpolation_curve, vec2(sample_value, 0.0)).r;
	float sampled_clip_dist = clamp(curve_value, curve_clamp.x, curve_clamp.y);
	float dist_center = length(rotated_uv);
	float mask = smoothstep(edge_blur.x, edge_blur.y, sampled_clip_dist - dist_center); // Returns x < 0 if dist_center > sampled_clip_dist

	// TODO: Add better color options
	vec3 output = color.rgb * mask;
	ALBEDO = output;
	EMISSION = output * emission_strength;
}