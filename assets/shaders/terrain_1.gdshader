shader_type spatial;

// Texture Uniforms
uniform sampler2D sand_tex : source_color;
uniform sampler2D grass_tex : source_color;
uniform sampler2D rock_tex : source_color;

// Thresholds
uniform float sand_limit = 0.5;
uniform float grass_limit = 6.0;
uniform float slope_threshold = 0.6;

varying float v_height;
varying vec3 v_world_pos;
varying vec3 v_normal;

void vertex() {
	v_height = VERTEX.y;
	v_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	v_normal = NORMAL;
}

void fragment() {
	// Calculate the dot product of the normal and the up vector (0,1,0)
	// This tells us how "flat" the surface is.
	float slope = clamp(NORMAL.y, 0.0, 1.0);
	
	vec3 blending;
	
	// Determine base color by height
	if (v_height < sand_limit) {
		blending = texture(sand_tex, v_world_pos.xz * 0.2).rgb;
	} else if (v_height < grass_limit) {
		blending = texture(grass_tex, v_world_pos.xz * 0.2).rgb;
	} else {
		blending = texture(rock_tex, v_world_pos.xz * 0.2).rgb;
	}
	
	// Apply slope override (if too steep, use rock texture)
	if (slope < slope_threshold) {
		// Blend slightly to avoid harsh pixel lines
		float lerp_val = smoothstep(slope_threshold - 0.1, slope_threshold, slope);
		vec3 rock_color = texture(rock_tex, v_world_pos.xz * 0.2).rgb;
		blending = mix(rock_color, blending, lerp_val);
	}

	ALBEDO = blending;
	// Optional: Use the slope to make cliffs look a bit rougher
	ROUGHNESS = mix(0.9, 0.4, slope); 
}