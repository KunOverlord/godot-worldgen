class_name PlayerState extends EntityState

var _input : BaseInput = null

func _init(data: StateData):
	super._init(data)
	_input = GameInput

func movetowards( direction : float) -> Vector3:
	var input = input().getinput()
	return Vector3(input.x, 0, input.y).rotated(Vector3.UP, direction).normalized()

func input() -> PlayerInput : return _input
func gravity() -> int : return 1 #capture world gravity
func jump_height() -> float: return GamePlayer.get_jump()
func strength() -> float : return GamePlayer.get_strength()
func speed() -> float : return GamePlayer.get_speed()
func canfly() -> bool: return GamePlayer.can_fly()


func update(e: Entity, delta: float):
	update_speed(e,delta)
	update_physics(e,delta)
	super.update(e,delta)

func update_speed( entity : Entity, delta : float = 0.0 ) -> void:
	entity.velocity += movetowards(entity.direction())

func update_physics(e : Entity , delta : float ) -> void:
	pass
