@tool
class_name TerrainNode extends StaticBody3D

var mesh_instance: MeshInstance3D
var collision_shape: CollisionShape3D

func _init() -> void:
	# Initialize internal components
	mesh_instance = MeshInstance3D.new()
	collision_shape = CollisionShape3D.new()
	add_child(mesh_instance)
	add_child(collision_shape)

func setup(coord: Vector2i, offset: Vector2 , size: int, noise: FastNoiseLite) -> void:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var vert_count = size + 1
	var location = Vector3(coord.x * size - offset.x, 0, coord.y * size - offset.y)
	
	for z in range(vert_count):
		for x in range(vert_count):
			var world_x = location.x + x
			var world_z = location.z + z
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
	var final_mesh = st.commit()
	
	# Update visuals
	mesh_instance.mesh = final_mesh
	
	# Update physics collision
	collision_shape.shape = final_mesh.create_trimesh_shape()
	
	self.global_position = location
	
func apply_shader( material : ShaderMaterial ) -> void:
	mesh_instance.material_override = material

func apply_visuals(world_data: WorldTextures) -> void:
	var mat = ShaderMaterial.new()
	mat.shader = load("res://assets/shaders/terrain.gdshader") # Path to the shader above
	
	# Mapping your jpg files from the assets folder
	mat.set_shader_parameter("underwater_tex", load("res://assets/textures/underwater.jpg"))
	mat.set_shader_parameter("sand_tex", load("res://assets/textures/sand.jpg"))
	mat.set_shader_parameter("grass_tex", load("res://assets/textures/grass.jpg"))
	mat.set_shader_parameter("rock_tex", load("res://assets/textures/rock.jpg"))
	mat.set_shader_parameter("snow_tex", load("res://assets/textures/snow.jpg"))
	
	mesh_instance.material_override = mat
