@tool
class_name TerrainNode extends MeshInstance3D

func setup(coord: Vector2i, size: int, noise: FastNoiseLite) -> void:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var vert_count = size + 1
	var offset = Vector3(coord.x * size, 0, coord.y * size)
	
	for z in range(vert_count):
		for x in range(vert_count):
			var world_x = offset.x + x
			var world_z = offset.z + z
			var y = noise.get_noise_2d(world_x, world_z) * 15.0 
			
			st.set_uv(Vector2(float(x)/size, float(z)/size))
			st.add_vertex(Vector3(x, y, z))
			
	for z in range(size):
		for x in range(size):
			var i = x + (z * vert_count)
			st.add_index(i)
			st.add_index(i + 1)
			st.add_index(i + vert_count)
			st.add_index(i + 1)
			st.add_index(i + vert_count + 1)
			st.add_index(i + vert_count)
			
	st.generate_normals()
	self.mesh = st.commit()
	self.global_position = offset

# --- ADD THIS METHOD BELOW ---
func apply_visuals(textures: WorldTextures) -> void:
	if not textures:
		return
		
	var mat = ShaderMaterial.new()
	var shader = Shader.new()
	
	# This is a basic slope-blending shader string
	shader.code = """
	shader_type spatial;
	uniform sampler2D grass_tex;
	uniform sampler2D rock_tex;
	
	void fragment() {
		float slope = clamp(NORMAL.y, 0.0, 1.0);
		vec3 grass = texture(grass_tex, UV * 4.0).rgb;
		vec3 rock = texture(rock_tex, UV * 4.0).rgb;
		
		// Blends rock on steep slopes (low NORMAL.y) and grass on flats
		ALBEDO = mix(rock, grass, smoothstep(0.7, 0.8, slope));
	}
	"""
	
	mat.shader = shader
	mat.set_shader_parameter("grass_tex", textures.grass_albedo)
	mat.set_shader_parameter("rock_tex", textures.rock_albedo)
	
	self.material_override = mat
