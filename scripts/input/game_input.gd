class_name GameInput
extends BaseInput

# -- Button state constants
const TOUCH_RANGE := 10         # 1–10 = touch
const HOLD_RANGE := 20		    # 40 = hold , 41 = RELEASE
const AXIS_RANGE := 10          # directional vector smppthing

# -- Input state storage
var _keys: Dictionary[String,String] = {}
# -- Config profile
var _name: String = 'default'

#Initialize
func _init() -> void:
	super._init()
	_initstates()
	print(states(),keys(),buttons())

func _initstates() :
	_states["button1"] = 0
	_states["button2"] = 0
	_states["button3"] = 0
	_states["button4"] = 0

#setup
func _ready(profile: String = "default") -> void:
	super._ready()
	_name = profile
	_keys = _load(_name)
	print("PlayerInput created for profile:", profile , keys() )
	#print(buttons(),actions(),keys(),states())
	reset()

# -- MAIN UPDATE
func _process(delta: float) -> void:
	super._process(delta)

## RESET AND UTILS
func reset():
	_dir.x = 0
	_dir.y = 0
	for key in states().keys(): _states[key] = 0

# import the input mappings
func _load( profile : String = 'default' ) -> Dictionary[String,String]:
	var path: String = "res://config/input_%s.json" % [profile]
	if FileAccess.file_exists(path):
		var content = FileAccess.get_file_as_string(path)
		var data = JSON.parse_string(content)
		var out : Dictionary[String,String] = {}
		for k in data: if typeof(k) == TYPE_STRING and typeof(data[k]) == TYPE_STRING: out[k] = data[k]
		#if data and data is Dictionary[String,String]: return data.get("keys",{})
		return out
		#if data and data is Dictionary: return data
		push_error("Failed to parse JSON: %s" % data)
	else:
		push_warning("Input map not found at: %s" % path)
	return {}

# Initialize button states
# -- AXIS HANDLING ------------------------------------------------------------
func _update_axes__( delta : float ) -> void:
	super._update_axes(delta)
	move(inputx(),inputy(),delta)
	_dir.x = inputx()
	_dir.y = inputy()

func _update_axes( delta : float ) -> void:
	super._update_axes(delta)
	move( inputx() , inputy() , delta * AXIS_RANGE )
	
func inputx() -> float: return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
func inputy() -> float: return Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	

func up() -> bool: return y() < 0
func down() -> bool: return y() > 0
func left() -> bool: return x() < 0
func right() -> bool: return x() > 0
	

# -- BUTTON STATE HANDLING ----------------------------------------------------
func _update_states( delta : float) -> void:
	for key in states().keys(): actiondown(key) if actionpressed(key) else actionup(key)

#extra input methods
func actionreleased(key:String) -> bool :return Input.is_action_just_released( key )
func actionpressed(key:String,touch:bool = false) -> bool :
	return Input.is_action_just_pressed(key) if touch else Input.is_action_pressed( key )

#func action(key: String) -> bool: return actionpressed(keys().get(key, key))
func actiondown(key : String): _states[key] = min(actions().get(key,key) + 1,HOLD_RANGE)
func actionup( key : String ): _states[key] = HOLD_RANGE + 1 if actionreleased(key) else 0

# -- STATE QUERIES ------------------------------------------------------------
## GGETTERS
func keys() -> Dictionary[String,String]: return _keys
func buttons() -> Array[String]: return keys().keys( ) 
func actions() -> Dictionary[String,int]:
	var actionmap : Dictionary[String,int] = {}
	for key in super.states().keys(): actionmap[key] = state(key)
	return actionmap;
func states( map : bool = false ) -> Dictionary[String,int]: return actions() if map else super.states()
#read key state
func state(key: String) -> int: return super.state(keys().get(key, key))
#is key touch
func touch(key: String) -> bool: return threshold(state(key),0,TOUCH_RANGE)
#is keypress
func press(key: String) -> bool: return threshold(state(key),TOUCH_RANGE,HOLD_RANGE)
#is key hold
func hold(key: String) -> bool: return state(key) == HOLD_RANGE
#is key released
func release(key: String) -> bool: return state(key) > HOLD_RANGE
#threshold helper
func threshold(value : int = 0 , min : int = 0,max : int = 0) -> bool: return value > min and value < max
