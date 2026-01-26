class_name EntityState extends RefCounted

var _data: StateData

func _init(data: StateData):
	_data = data
func name() -> String: return _data.state if _data else ""
func state() -> String : return _data.state_name() if _data else ""
func enter( e : Entity ): pass
func exit( e: Entity) : pass

func update(e: Entity, delta: float):
	update_animation(e,delta)
	update_collission(e,delta)

func update_animation(e : Entity , delta : float ) -> void: pass
func update_collission(e : Entity , delta : float ) -> void: pass
