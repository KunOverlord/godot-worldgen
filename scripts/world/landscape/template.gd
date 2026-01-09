@tool
class_name LandTemplate extends WorldTemplate

const MAT_SIZE : int = 7

@export_group("Landscape")
@export var min: Vector2 = Vector2(-10.0,0.0)
@export var max: Vector2 = Vector2(30.0,40.0)
@export_range(8,64,1) var tile_size: int = 16
@export var tiles: Vector2i = Vector2i(4, 4) :
	set(value):
		tiles = Vector2i(
			min(32, max(value.x, 1) ),
			min( 32 , max(value.y, 1 ) )
		)

#return random world size
func height() -> Vector2:
	var _min = randf_range(min.x,min.y)
	var _max = randf_range(max.x,max.y)
	return Vector2(_min,_max)

#override/append elements
func attributes() -> Dictionary:
	var contents = super.attributes()
	contents["min_height"] = [min.x,min.y]
	contents["max_height"] = [max.x,max.y]
	
	var water = water_material()
	if water :
		contents["water_color"] = water.color
		contents["water_level"] = water.level
		contents["water_flow"] = water.flow
	print(contents)
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

#List all water materials
func water_materials() -> Array[WaterMaterial] :
	var list : Array[WaterMaterial] = []
	for water in world_materials():
		if water is WaterMaterial: list.append(water)
	return list
	

#get a random water template
func water_material() -> WaterMaterial:
	var materials = water_materials()
	var count = materials.size()
	return materials[randi() & count] if count else null
#
#check if has water
func has_water() -> bool:
	return water_materials().size() > 0
