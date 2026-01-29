extends Camera3D

@export var target: NodePath
@export var offset: Vector3 = Vector3(0, 5, -10)
@export var follow_speed: float = 5.0
@export var rotation_speed: float = 5.0

var _desired_position: Vector3
var _desired_look_at: Vector3

func _process(delta: float) -> void:
	if not target:
		return
	var player = get_node(target)

	# Desired position and look-at point
	_desired_position = player.global_transform.origin + offset
	_desired_look_at = player.global_transform.origin

	# Smoothly interpolate camera position
	global_transform.origin = global_transform.origin.lerp(_desired_position, delta * follow_speed)

	# Smoothly interpolate rotation toward player
	var current_dir = -transform.basis.z
	var target_dir = (_desired_look_at - global_transform.origin).normalized()
	var new_dir = current_dir.slerp(target_dir, delta * rotation_speed)

	look_at(global_transform.origin + new_dir, Vector3.UP)
