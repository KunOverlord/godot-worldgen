class_name BaseInputOLD
extends Node

# -- Axis values
var _dir: Vector2 = Vector2.ZERO
# -- Input action storage
var _states: Dictionary[String,int] = {}

#initialize base
func _init() -> void: pass
# setup base input
func _ready() -> void: pass
#main update
func _process(delta: float) -> void:
	_update_axes( delta )
	_update_states( delta )
#handle diractional update
func _update_axes( delta ):
	#print(direction())
	pass
#handle action key updates
func _update_states( delta ):
	pass
# applies the lerp and delta interpolation
func move( x : float  = 0 , y : float = 0, delta : float = 1 ) -> void:
	_dir = _dir.move_toward(Vector2( x , y ) , delta )

#horizontal direction
func x() -> float: return _dir.x
#vertical direction
func y() -> float: return _dir.y
# vector direction
func direction( normalize : bool = false) -> Vector2: return normalized() if normalize else _dir
#normalized direction
func normalized() -> Vector2 : return _dir.normalized() if _dir.length() > 0 else Vector2.ZERO
#check if moving
func moving() -> bool: return direction().length() > 0.1


#expose states
func states( ) -> Dictionary: return _states
#get current key state
func state(key: String) -> int: return states().get(key, 0)
