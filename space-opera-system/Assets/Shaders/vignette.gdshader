shader_type canvas_item;
uniform float size;

void fragment() {
	
	vec2 uv=UV;
	vec2 suv = abs(uv * 2.0 - 1.0);
	vec4 col = texture(TEXTURE, uv);
	vec2 u = vec2(size / (1.0/TEXTURE_PIXEL_SIZE));
	u = smoothstep(vec2(0), u, 1.0 - suv);
    
	COLOR = col * u.x * u.y;
}