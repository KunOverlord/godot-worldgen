extends Marker3D

@export_group("Rotation Settings")
@export var mouse_sensitivity: float = 0.15
@export var tilt_upper_limit: float = 80.0 # Degrees
@export var tilt_lower_limit: float = -80.0

@export_group("Zoom Settings")
@export var zoom_speed: float = 0.5
@export var min_zoom: float = 2.0
@export var max_zoom: float = 10.0

@export_group("Smoothing")
@export var lerp_speed: float = 10.0

@onready var spring_arm: SpringArm3D = $SpringArm3D

var _rotation_input: float = 0.0
var _tilt_input: float = 0.0
var _current_zoom: float = 5.0

func _ready():
	# Make the anchor move independently of the player's rotation
	set_as_top_level(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spring_arm.spring_length = _current_zoom

func _process(delta: float):
	# 1. Manually follow the player's position (but not their rotation)
	var target_pos = get_parent().global_position + Vector3(0, 1.5, 0)
	global_position = target_pos # Or use lerp for "floaty" follow
	
	# 2. Apply the Orbit/Tilt logic (same as before)
	rotation_degrees.y = _rotation_input
	rotation_degrees.x = _tilt_input
	
	# 3. Apply Zoom (Spring Length)
	spring_arm.spring_length = lerp(spring_arm.spring_length, _current_zoom, lerp_speed * delta)


func _unhandled_input(event: InputEvent):
	# Handle Orbit and Tilt
	if event is InputEventMouseMotion:
		_rotation_input -= event.relative.x * mouse_sensitivity
		_tilt_input -= event.relative.y * mouse_sensitivity
		_tilt_input = clamp(_tilt_input, tilt_lower_limit, tilt_upper_limit)
		#_tilt_input = clamp(_tilt_input, -80, 80) # Degrees
	
	# Handle Zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_current_zoom -= zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_current_zoom += zoom_speed
		_current_zoom = clamp(_current_zoom, min_zoom, max_zoom)


func _physics_process(delta):
	# This creates a "lag" behind the player for a smoother cinematic feel
	var target_pos = get_parent().global_position + Vector3(0, 1.5, 0) # Offset to head height
	global_position = global_position.lerp(target_pos, lerp_speed * delta)
	
	
