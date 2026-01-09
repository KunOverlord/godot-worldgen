@tool
class_name WorldMaterial extends Resource

#private attribute
var _name : String = ""

#attribute accessor
@export var name: String:
	get: return _name if _name.length() else type()
	set(value): _name = value

func _init():
	if _name.length() == 0 : _name = type()
	pass

# fetch a texture to load
func loadtexture( ) -> Texture2D :
	return GameData.texture(name)
#
func type() -> String:
	return get_script().get_global_name()
