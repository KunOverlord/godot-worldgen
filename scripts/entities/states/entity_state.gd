class_name EntityState
extends Node

var _owner: CharacterBody3D = null
#var _name : String = "state"
var _next : Array[String] = [] #use for next states
#
func from( previous : EntityState ) -> EntityState:
	if previous:
		enter(previous.entity())
		previous.exit()
	return self
#terminate all pending handlers and cleanup tasks
func exit() -> EntityState:
	return self
#port all state attributes to the next state
func enter( owner : Entity ) -> EntityState	:
	_owner = owner
	#add here the initial animation changes, motion and collilssion setups
	return self


func handle(  event : InputEvent ) -> void:
	pass

func update_physics( delta : float = 0.0 ) -> void:
	pass
	
func update( delta : float = 0.0 ) -> void:
	update_physics(delta)
	pass

#state name ident
func name(): return ""
func entity() -> CharacterBody3D: return _owner
#get next state
func next( random : bool = false) -> String:
	if _next.is_empty() : return ""
	return _next[randi() % _next.size()] if random else _next[0]
#check if has next states, to mark as finished
func finished() -> bool: return _next.size() > 0


	
