extends Control

@onready var _input := PlayerInput

# Font & visuals
var font: Font = preload("res://fonts/Mono.tres")
var line_height: int = 14
var padding: int = 10

# Joystick visual setup
var joystick_center := Vector2(100, 100)
var joystick_radius := 50.0
var deadzone_radius := 10.0

# Debug colors
const COLOR_BG := Color(0.0, 0.0, 0.0, 0.25)
const COLOR_TEXT := Color.WHITE
const COLOR_CANCEL := Color.RED
const COLOR_AXIS := Color(0.3, 0.9, 0.9)
const COLOR_JOYSTICK := Color(0.9, 0.3, 0.3)

func _ready() -> void:
	# Make this Control cover the whole screen
	set_anchors_preset(Control.PRESET_FULL_RECT)
	z_index = 100  # Ensures it's on top of UI
	set_process(true)

func _process(_delta: float) -> void:
	queue_redraw()

func buttonstate(button) -> String:
	var state = _input.state(button)
	if state > GameInput.HOLD_RANGE :
		return 'Release'
	elif state > GameInput.TOUCH_RANGE:
		return 'Hold'
	elif state > 0:
		return 'Touch'
	else:
		return ''
		

func _draw() -> void:
	if _input == null: return
	_drawdirection()	
	_drawbuttons()

#render button state
func _drawbuttons() ->void :
	# Draw button states
	var y := joystick_center.y + joystick_radius + 100
	#y += 10
	draw_string(font, Vector2(padding, y), "-- Buttons --", HORIZONTAL_ALIGNMENT_LEFT, -1, line_height, COLOR_TEXT)
	y += line_height
	for action in _input.buttons():
		var state := _input.state(action)
		var label := "%s: %d %s" % [action, state,buttonstate(action ) ]
		var color = COLOR_CANCEL if state > GameInput.HOLD_RANGE else COLOR_TEXT
		draw_string(font, Vector2(padding, y), label, HORIZONTAL_ALIGNMENT_LEFT, -1, line_height, color)
		y += line_height

func _drawdot( position :Vector2 ) -> void :
	var joy_pos := joystick_center + position * joystick_radius
	draw_circle(joy_pos, 5.0, COLOR_JOYSTICK)
	draw_line(joystick_center, joy_pos, COLOR_AXIS, 2.0)
	
#show gamepad direction POV
func _drawdirection() -> void:
	# Draw joystick background
	draw_circle(joystick_center, joystick_radius, COLOR_BG)
	draw_circle(joystick_center, deadzone_radius, Color(1,1,1,0.05))
	
	# Draw joystick position
	_drawdot(Vector2(_input.x(),_input.y()))

	# Draw text info
	var y := joystick_center.y + joystick_radius + 20
	var lines := [
		"Move X: %.2f" % _input.x(),
		"Move Y: %.2f" % _input.y(),
		"Moving: %s" % str(_input.moving()),
		"Direction: %s" % str(_input.direction())
	]
	
	for line in lines:
		draw_string(font, Vector2(padding, y), line, HORIZONTAL_ALIGNMENT_LEFT, -1, line_height, COLOR_TEXT)
		y += line_height
