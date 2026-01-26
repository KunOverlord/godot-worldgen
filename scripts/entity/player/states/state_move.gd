class_name MoveState extends PlayerState

func is_jumping( e : Entity) -> bool:
	if e.is_on_floor() and input().button1():
		e.change_state("jump")
		return true
	return false

func update( e : Entity, delta : float = 0.0 ) -> void:
	if is_jumping(e) : return
	super.update( e , delta )
	
