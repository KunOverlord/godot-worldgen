class_name FlyState extends PlayerState

func update(e: Entity, delta: float) -> void:
	if not flying():
		falling(e)
		return
	fly(e,delta)
	super.update(e,delta)

func update_speed( entity : Entity, delta : float = 0.0 ) -> void:
	super.update_speed(entity,delta)

func up() -> bool : return input().hold2()
func down() -> bool : return input().hold3()
func flying() -> bool : return input().hold1()

func upwards() -> float : return speed() * 4.0 if up() else 0
func downwards() -> float : return speed() * 2.0 if down() else 0

func falling( e : Entity ) -> bool :
	e.create_tween().tween_property( e.display , "rotation:x", 0.0, 0.2)
	if e.is_on_floor() : return moving(e)
	return e.change_state("fall")

func moving( e : Entity) -> bool :
	if not e.is_on_floor() : return false
	return e.change_state("land")

func fly(e : Entity , delta : float ):
	# EXIT CONDITION: Release jump button or touch floor
	var model = e.display
	var inputs = input().getinput() # Vector2 (A/D, W/S)
	var cam_basis = e.camera.global_transform.basis
	var direction = (cam_basis * Vector3(inputs.x, 0, inputs.y)).normalized()
	# 4. Apply Movement (No gravity applied here)
	e.velocity = e.velocity.lerp(direction * speed * 1.5, delta * 5.0) # Flying is often faster
	e.velocity.y += upwards() * delta
	e.velocity.y -= downwards() * delta

	# 5. Rotate Display (Face the flight direction)
	if direction.length() > 0.1:
		var target_angle = atan2(direction.x, direction.z) + PI
		model.rotation.y = lerp_angle(model.rotation.y, target_angle, delta * 10.0)
		
		# Optional: Tilt mesh up/down based on flight direction
		var vertical_angle = asin(-direction.y)
		model.rotation.x = lerp_angle(model.rotation.x, vertical_angle, delta * 10.0)
	else:
		# Level out the mesh if not moving
		model.rotation.x = lerp_angle(model.rotation.x, 0, delta * 5.0)
		
	return true
