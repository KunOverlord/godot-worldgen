@tool
class_name WorldTemplate extends Resource

const MAT_SIZE : int = 7

const TYPE_LAND = "land"
const TYPE_PLANET = "planet"
const TYPE_SOLAR = "solar"
const TYPE_VOXEL = "voxel"
const TYPE_DUNGEON = "dungeon"

@export_group("Materials")
var materials: Array[WorldMaterial] = []
	
@export_group("Atmosphere & Lighting")
@export var sky_color: Color = Color.SKY_BLUE
@export var fog_color: Color = Color.ALICE_BLUE
@export var sun_intensity: float = 1.0

# Fetch a world template
static func loadfrom(name: String, type : String = TYPE_LAND ) -> WorldTemplate:
	var path := "res://assets/templates/%s/%s.tres" % [type,name]
	print_debug(path)
	
	if not ResourceLoader.exists(path):
		push_warning("World template not found: %s" % path)
		return null
	
	return load(path)
	#var res := load(path)
	#return res if res is WorldTemplate else null


#load worlds from the given template
static func create( name : String , type = TYPE_LAND) -> WorldSeed:
	#make a selection from the template folder
	var template : WorldTemplate = loadfrom(name,type)
	#make a selection of templates here
	return WorldSeed.new(  template if template is WorldTemplate else null )

# fill with template texture contetns
func createshader() -> ShaderMaterial:
	var textures : Array[Texture] = []
	var shader = ShaderMaterial.new()
	#fill in all materials
	for mat : WorldMaterial in materials:
		textures.append(mat.loadtexture())
	
	return shader

#test shader
func testshader() -> ShaderMaterial :
	var material = ShaderMaterial.new()
	material.shader = load("res://assets/shaders/terrain.gdshader") # Path to the shader above
	
	# Mapping your jpg files from the assets folder
	material.set_shader_parameter("underwater_tex", load("res://assets/textures/underwater.jpg"))
	material.set_shader_parameter("sand_tex", load("res://assets/textures/sand.jpg"))
	material.set_shader_parameter("grass_tex", load("res://assets/textures/grass.jpg"))
	material.set_shader_parameter("rock_tex", load("res://assets/textures/rock.jpg"))
	material.set_shader_parameter("snow_tex", load("res://assets/textures/snow.jpg"))
	return material
