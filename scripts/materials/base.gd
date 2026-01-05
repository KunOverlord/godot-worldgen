@tool
class_name WorldMaterial extends Resource

@export_group("Material")
@export var name: String = "material"


# fetch a texture to load
func loadtexture( ) -> Texture2D :
	var path : String = "res://assets/textures/%s.jpg" % name.to_lower()
	print_debug(path)
	if not ResourceLoader.exists(path):
		push_warning("World Material not found: %s" % path)
		return null	
	return load(path)
