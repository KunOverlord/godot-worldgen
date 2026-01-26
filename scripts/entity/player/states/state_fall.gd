class_name FallState extends PlayerState

### apply falling physics, using the global world gravity index (1 by default)

func update(e: Entity, delta: float):
	if islanding(e) : return 
	super.update(e,delta)


func islanding( e : Entity) -> bool:
	if not e.is_on_floor() : return false
	e.change_state("idle")
	return true

#import the world's gravity index and apply some weight variants
func gravity() -> int: return 1
