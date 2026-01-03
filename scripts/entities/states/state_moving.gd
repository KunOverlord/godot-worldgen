class_name StateMoving
extends EntityState

var _speed : Vector3 = Vector3.ZERO

func name() -> String: return 'moving'
func gravity() -> int : return 1
func speed() -> Vector3 : return _speed

func enter( owner : Entity ) -> EntityState:
	super(owner)
	
	return self

func exit() -> EntityState:
	super()
	return self
	
	
func update( delta : float = 0.0 ) -> void:
	super( delta )
	update_speed(delta)
	update_collission(delta)
	update_animation(delta)
	#owner().is_on_floor()
	

func update_physics( delta : float = 0.0 ) -> void:
	super( delta )	

func update_speed( delta : float = 0.0 ) -> void:
	entity().velocity += speed() * delta
	
func update_animation( delta : float = 0.0) -> void:
	pass

func update_collission( delta : float = 0.0) -> void:
	pass
