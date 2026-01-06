@tool
class_name WaterNode extends MeshInstance3D

func setup(level: float, color: Color, size: float):
	# 1. Mesh Setup
	var p_mesh = PlaneMesh.new()
	p_mesh.size = Vector2(size, size)
	p_mesh.subdivide_depth = 64
	p_mesh.subdivide_width = 64
	mesh = p_mesh
	
	# 2. Position
	global_position.y = level
	
	# 3. Material Setup (Assuming a WaterMaterial logic exists)
	var mat = ShaderMaterial.new()
	mat.shader = GameData.shader("waternode") # Your water shader
	mat.set_shader_parameter("water_color", color)
	mesh.surface_set_material(0, mat)
