shader_type spatial;

// The fix: Declare these uniforms to access the buffers
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

render_mode depth_draw_always; 

uniform vec3 water_color : source_color = vec3(0.0, 0.4, 0.6);
uniform vec3 deep_water_color : source_color = vec3(0.0, 0.1, 0.2);
uniform float beer_law_factor = 2.0; 
uniform float edge_fade_distance = 0.5; 

uniform float wave_speed = 1.0;
uniform float wave_height = 0.3;

varying float v_depth;

void vertex() {
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float time = TIME * wave_speed;
	float wave = sin(world_pos.x * 0.5 + time) * cos(world_pos.z * 0.5 + time);
	
	VERTEX.y += wave * wave_height;
}

void fragment() {
	// 1. Calculate Depth using the new uniform
	float depth_tex = texture(DEPTH_TEXTURE, SCREEN_UV).r;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth_tex);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	
	float water_depth = linear_depth - VERTEX.z; 
	
	// 2. Color & Shoreline logic
	float depth_factor = clamp(1.0 - exp(-water_depth / beer_law_factor), 0.0, 1.0);
	vec3 final_color = mix(water_color, deep_water_color, depth_factor);
	float alpha_factor = clamp(water_depth / edge_fade_distance, 0.0, 1.0);
	
	ALBEDO = final_color;
	ALPHA = alpha_factor * 0.8;
	METALLIC = 0.5;
	ROUGHNESS = 0.05;
}