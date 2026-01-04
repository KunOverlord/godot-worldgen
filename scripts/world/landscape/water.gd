@tool
class_name WaterNode extends MeshInstance3D

var overlay: ColorRect
var canvas: CanvasLayer

func _ready() -> void:
	# Setup the UI Layer
	canvas = CanvasLayer.new()
	add_child(canvas)
	
	# Setup the Overlay
	overlay = ColorRect.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.visible = false # Hidden by default
	
	# Apply the Submerged Shader
	var mat = ShaderMaterial.new()
	mat.shader = load("res://assets/shaders/underwater.gdshader")
	overlay.material = mat
	
	canvas.add_child(overlay)

func _process(_delta: float) -> void:
	var cam = get_viewport().get_camera_3d()
	if not cam: return
	
	# Detection Logic
	var is_underwater = cam.global_position.y < global_position.y
	
	# Toggle the visibility of the screen effect
	if overlay.visible != is_underwater:
		overlay.visible = is_underwater
		_update_environmental_lighting(is_underwater)

func _update_environmental_lighting(underwater: bool) -> void:
	# Here you would adjust WorldEnvironment Fog/Ambient light
	pass
