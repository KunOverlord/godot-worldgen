@tool
class_name WaterNode extends MeshInstance3D

func _init() -> void:
	# Create a flat plane for the water
	var plane = PlaneMesh.new()
	plane.size = Vector2(1000, 1000) # Large enough to cover the horizon
	self.mesh = plane
	
	# Setup a basic transparent material
	var mat = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = Color(0.0, 0.4, 0.8, 0.6) # Deep blue, semi-transparent
	mat.metallic = 0.8
	mat.roughness = 0.1
	self.material_override = mat

func update_level(height: float) -> void:
	self.global_position.y = height
