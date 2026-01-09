@tool
class_name MaterialRule extends Resource

@export_category("Material rules")
@export var height : Vector2 = Vector2.ZERO
@export var density : float = 1.0
@export var slope : float = 0.0

func _init( h : Vector2 = Vector2.ZERO, d : float  = 1.0 , s : float = 0.0 ) -> void:
	height = h
	density = d
	slope = s
	
#
func data() -> Vector4:
	return Vector4(height.x,height.y,slope,density)
