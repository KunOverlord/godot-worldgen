@tool
class_name WorldTextures extends Resource

@export_group("Environmental Limits")
@export var water_level: float = -1.5
@export var sand_limit: float = 0.5
@export var grass_limit: float = 6.0
@export var slope_threshold: float = 0.6

@export_group("Texture Assets")
@export var sand_albedo: Texture2D
@export var grass_albedo: Texture2D
@export var rock_albedo: Texture2D

# Helper to apply these to a material
# world_textures.gd snippet
func setup_material(mat: ShaderMaterial):
	mat.set_shader_parameter("sand_limit", sand_limit)
	mat.set_shader_parameter("grass_limit", grass_limit)
	mat.set_shader_parameter("slope_threshold", slope_threshold)
	mat.set_shader_parameter("sand_tex", sand_albedo)
	mat.set_shader_parameter("grass_tex", grass_albedo)
	mat.set_shader_parameter("rock_tex", rock_albedo)
	
	

	
