class_name GameData extends Resource

const MAT_SIZE : int = 7

const TYPE_LAND = "land"
const TYPE_PLANET = "planet"
const TYPE_SOLAR = "solar"
const TYPE_VOXEL = "voxel"
const TYPE_DUNGEON = "dungeon"


# Fetch a world template
static func loadworld(name: String, type : String = TYPE_LAND ) -> WorldTemplate:
	var path := "res://assets/templates/%s/%s.tres" % [type,name]
	print_debug("Loading world %s" % path)
	
	if ResourceLoader.exists(path):
		return load(path)
	push_warning("World template not found: %s" % path)
	return null

#Create a landscape world seed template
static func landscapeworld( name : String ) -> WorldTemplate:
	#make a selection from the template folder
	var template : WorldTemplate = loadworld(name,TYPE_LAND)
	#make a selection of templates here
	return template if template is LandTemplate else null


# Load game shaders
static func shader( name : String ) -> ShaderMaterial:
	var path : String = "res://assets/shaders/%s.gdshader" % name
	if ResourceLoader.exists(path): return load(path)
	push_warning("Shader not found: %s" % path)
	return null

## Load texture from the asset folder
static func texture( name : String ) -> Texture2D :
	
	var path : String = "res://assets/textures/%s.jpg" % name.to_lower()
	print_debug(path)
	
	if ResourceLoader.exists(path): load(path)
	
	push_warning("World Material not found: %s" % path)
	return null	
