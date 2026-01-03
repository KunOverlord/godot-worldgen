shader_type spatial;

uniform sampler2D underwater_tex : source_color;
uniform sampler2D sand_tex : source_color;
uniform sampler2D grass_tex : source_color;
uniform sampler2D rock_tex : source_color;
uniform sampler2D snow_tex : source_color;

// Height Rules
uniform float water_level = -2.0;
uniform float sand_cutoff = 2.0;
uniform float grass_cutoff = 12.0;
uniform float snow_cutoff = 18.0;
uniform float rock_slope_threshold = 0.7;

varying float v_world_y;
varying vec3 v_world_pos;
varying vec3 v_normal;

// Function to calculate triplanar texture blending
vec3 triplanar_texture(sampler2D p_sampler, vec3 p_weights, vec3 p_triplanar_pos) {
	vec3 samp = vec3(0.0);
	samp += texture(p_sampler, p_triplanar_pos.xy).rgb * p_weights.z;
	samp += texture(p_sampler, p_triplanar_pos.xz).rgb * p_weights.y;
	samp += texture(p_sampler, p_triplanar_pos.zy).rgb * p_weights.x;
	return samp;
}

void vertex() {
	v_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	v_world_y = v_world_pos.y;
	v_normal = abs(NORMAL);
}

void fragment() {
	// 1. Calculate Triplanar Weights
	vec3 weights = v_normal;
	weights /= (weights.x + weights.y + weights.z);
	
	// Use world position for the projection coordinates (tiling scale 0.1)
	vec3 tiling_pos = v_world_pos * 0.1;
	
	// 2. Sample all textures using the triplanar function
	vec3 tex_underwater = triplanar_texture(underwater_tex, weights, tiling_pos);
	vec3 tex_sand = triplanar_texture(sand_tex, weights, tiling_pos);
	vec3 tex_grass = triplanar_texture(grass_tex, weights, tiling_pos);
	vec3 tex_rock = triplanar_texture(rock_tex, weights, tiling_pos);
	vec3 tex_snow = triplanar_texture(snow_tex, weights, tiling_pos);
	
	// 3. Slope calculation (Normal.y is 1.0 when flat)
	float slope = clamp(NORMAL.y, 0.0, 1.0);
	
	// 4. Height & Slope Logic
	vec3 final_color;
	
	if (v_world_y < water_level) {
		final_color = tex_underwater;
	} else if (v_world_y < sand_cutoff) {
		final_color = mix(tex_underwater, tex_sand, smoothstep(water_level, water_level + 0.5, v_world_y));
	} else if (v_world_y < grass_cutoff) {
		final_color = mix(tex_sand, tex_grass, smoothstep(sand_cutoff - 1.0, sand_cutoff + 1.0, v_world_y));
	} else if (v_world_y < snow_cutoff) {
		final_color = mix(tex_grass, tex_snow, smoothstep(snow_cutoff - 1.0, snow_cutoff + 1.0, v_world_y));
	} else {
		final_color = tex_snow;
	}
	
	// 5. Rock Override for Slopes
	// Apply rock to steep areas, except deep underwater or highest snow caps
	if (v_world_y > water_level + 1.0 && v_world_y < snow_cutoff + 2.0) {
		float rock_mask = smoothstep(rock_slope_threshold - 0.1, rock_slope_threshold + 0.1, slope);
		final_color = mix(tex_rock, final_color, rock_mask);
	}
	
	ALBEDO = final_color;
}