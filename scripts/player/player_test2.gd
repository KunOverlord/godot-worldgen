extends CharacterBody3D

@export var speed: float = 5.0
@export var turn_speed: float = 5.0  # higher = faster rotation
@onready var input := PlayerInput  # your singleton

func _physics_process(delta: float) -> void:
	var dir = Vector3.ZERO

	# Map 2D input to X/Z plane
	dir.x = input.direction(false).x
	dir.z = input.direction(false).y

	# Normalize for consistent speed
	if dir.length() > 0:
		dir = dir.normalized()

		# Smooth rotation toward movement direction
		var target_rot = Vector3(0, atan2(-dir.x, -dir.z), 0)
		rotation = rotation.lerp(target_rot, delta * turn_speed)

	# Apply movement
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed

	# Gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0

	move_and_slide()
