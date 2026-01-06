@tool
class_name LandTemplate extends WorldTemplate

const MAT_SIZE : int = 7

@export_group("Landscape")
@export var min_height: Array[float] = [-10.0]
@export var max_height: Array[float] = [30.0]

@export_group("Water")
@export var water_color: Array[Color] = [Color.ROYAL_BLUE]
@export var water_level : Array[float] = [0.0]

#override/append elements
func attributes() -> Dictionary:
	var contents = super.attributes()
	if water_color: contents["water_color"] = water_color
	if water_level: contents["water_level"] = water_level
	if min_height: contents["min_height"] = min_height
	if max_height: contents["max_height"] = max_height
	return contents

#test shader
func testmaterial() -> ShaderMaterial :
	var material = ShaderMaterial.new()
	#material.shader = load("res://assets/shaders/terrain.gdshader") # Path to the shader above
	material.shader = GameData.shader("terrain_test")
	# Mapping your jpg files from the assets folder
	material.set_shader_parameter("underwater_tex", load("res://assets/textures/underwater.jpg"))
	material.set_shader_parameter("sand_tex", load("res://assets/textures/sand.jpg"))
	material.set_shader_parameter("grass_tex", load("res://assets/textures/grass.jpg"))
	material.set_shader_parameter("rock_tex", load("res://assets/textures/rock.jpg"))
	material.set_shader_parameter("snow_tex", load("res://assets/textures/snow.jpg"))
	return material
	

# fill with template texture contetns
func create_material() -> ShaderMaterial:
	var elements : Array[WorldMaterial] = land_materials()
	var material = ShaderMaterial.new()
	material.shader = GameData.shader("terrain")
	#fill in all materials  in hte array
	for e in elements :
		#material.set_shader_parameter(e.name,e.loadtexture())
		pass
	return material

#filter all world materials (exclude water, sky and others, not used in the terrain blending
func land_materials() -> Array[WorldMaterial]:
	var list : Array[WorldMaterial] = []
	for mat in world_materials() :
		if mat is LandMaterial: list.append(mat)
		if  list.size() < MAT_SIZE: break #skip after reaching the texture limit
	return list
