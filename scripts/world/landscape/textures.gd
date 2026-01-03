@tool
class_name WorldTextures extends Resource

@export_group("Height Limits")
## The Y-level where underwater becomes sand
@export var water_level: float = -2.0
## The Y-level where sand becomes grass
@export var sand_cutoff: float = 2.0
## The Y-level where grass becomes snow
@export var grass_cutoff: float = 12.0
## The Y-level where everything becomes snow
@export var snow_cutoff: float = 18.0

@export_group("Slope Settings")
## 1.0 is flat, 0.0 is vertical. Rock appears below this value.
@export var rock_slope_threshold: float = 0.7

@export_group("Texture Assets")
@export var underwater_tex: Texture2D
@export var sand_tex: Texture2D
@export var grass_tex: Texture2D
@export var rock_tex: Texture2D
@export var snow_tex: Texture2D

## Helper to apply these to a material
func setup_material(mat: ShaderMaterial) -> void:
	# Heights
	mat.set_shader_parameter("water_level", water_level)
	mat.set_shader_parameter("sand_cutoff", sand_cutoff)
	mat.set_shader_parameter("grass_cutoff", grass_cutoff)
	mat.set_shader_parameter("snow_cutoff", snow_cutoff)
	
	# Slope
	mat.set_shader_parameter("rock_slope_threshold", rock_slope_threshold)
	
	# Textures
	mat.set_shader_parameter("underwater_tex", underwater_tex)
	mat.set_shader_parameter("sand_tex", sand_tex)
	mat.set_shader_parameter("grass_tex", grass_tex)
	mat.set_shader_parameter("rock_tex", rock_tex)
	mat.set_shader_parameter("snow_tex", snow_tex)
