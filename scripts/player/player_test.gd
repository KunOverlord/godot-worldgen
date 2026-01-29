extends CharacterBody3D

enum State {Idle,Moving,Jumping,Falling,Flying}
var _STATE : State = State.Idle
@export_group("Player Setup")
@export var speed : float = 5.0
@export var jumpheight : float = 4.5

# Reference your Camera Anchor (the node that rotates horizontally)
@onready var camera_anchor = $CameraPOV
# Reference your Visual Mesh (to rotate it independently of the physics body)
@onready var visual_mesh = $MeshInstance3D
# Reference to the mesh display
@onready var display = $Display


func _physics_process(delta : float):
	match (_STATE):
		State.Idle , State.Moving: _move(delta)
		State.Jumping: _jump(delta)
		State.Falling: _fall(delta)
		State.Flying: _fly(delta)
	move_and_slide()

func _button1(): return Input.is_action_just_pressed("button1")
func _hold1(): return Input.is_action_pressed("button1")
func _button2(): return Input.is_action_just_pressed("button2")
func _hold2(): return Input.is_action_pressed("button2")
func _button3(): return Input.is_action_just_pressed("button3")
func _hold3(): return Input.is_action_pressed("button3")
func _button4(): return Input.is_action_just_pressed("button4")
func _hold4(): return Input.is_action_pressed("button4")
func playerinput() -> Vector2: return Input.get_vector("move_left", "move_right", "move_up", "move_down")
func playerdirection() -> Vector3 :
	var dir = playerinput()
	return Vector3(dir.x, 0, dir.y).rotated(Vector3.UP, camera_anchor.rotation.y).normalized()

func _fly(delta: float) -> bool:
	# EXIT CONDITION: Release jump button or touch floor
	if not _hold1():
		create_tween().tween_property(display, "rotation:x", 0.0, 0.2)
		return _falling() or _moving()

	# 1. Get Input
	var move = playerinput() # Vector2 (A/D, W/S)
	
	# 2. 3D Movement Logic (Fly where looking)
	# We use the camera's full transform basis to include Pitch (Up/Down)
	var cam_basis = camera_anchor.global_transform.basis
	var direction = (cam_basis * Vector3(move.x, 0, move.y)).normalized()
	
	# 3. Vertical Overrides (Optional Up/Down buttons)
	#if _button3(): direction.y += speed * delta
	#if _button2(): direction.y -= speed * delta
	#direction = direction.normalized()

	# 4. Apply Movement (No gravity applied here)
	velocity = velocity.lerp(direction * speed * 1.5, delta * 5.0) # Flying is often faster
	if _hold3(): velocity.y += speed * delta * 4.0
	if _hold2(): velocity.y -= speed * delta * 2.0

	# 5. Rotate Display (Face the flight direction)
	if direction.length() > 0.1:
		var target_angle = atan2(direction.x, direction.z) + PI
		display.rotation.y = lerp_angle(display.rotation.y, target_angle, delta * 10.0)
		
		# Optional: Tilt mesh up/down based on flight direction
		var vertical_angle = asin(-direction.y)
		display.rotation.x = lerp_angle(display.rotation.x, vertical_angle, delta * 10.0)
	else:
		# Level out the mesh if not moving
		display.rotation.x = lerp_angle(display.rotation.x, 0, delta * 5.0)
		
	return true

func _flying( ) -> bool:
	if _hold1():
		_STATE = State.Flying
		return true
	
	return false

func _fall(delta : float) -> bool : 
	if !is_on_floor() :
		if _flying() : return false;
		velocity += get_gravity() * delta
		return true
	_STATE = State.Moving
	return false

func _falling(  ) -> bool:
	if is_on_floor(): return false
	_STATE = State.Falling
	return true;

func _jumping( ) -> bool:
	if _button1() and is_on_floor():
		_STATE = State.Jumping
		velocity.y = jumpheight
		return true
	return false

func _jump( delta : float ) -> bool :
	#if _falling() : return false
	velocity += get_gravity() * delta
	if velocity.y > 0 : return true
	_STATE = State.Falling
	return false

func _moving() -> bool:
	if is_on_floor():
		_STATE = State.Moving
		return true;
	return false
	#return playerinput().length() > 0

func _move(delta : float ) -> bool:
	# Add the gravity.
	if _falling() or _jumping(): return false

	# 1. Get raw input
	#var input = playerinput()
	# Calculate direction relative to the Camera Anchor
	var direction = playerdirection()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		# ROTATE THE DISPLAY NODE
		# We use atan2 to get the angle from the direction vector
		#var target_angle = atan2(direction.x, direction.z)
		var target_angle = atan2(direction.x, direction.z) + PI
		display.rotation.y = lerp_angle(display.rotation.y, target_angle, delta * 10.0)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	return true
