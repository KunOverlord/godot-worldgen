class_name Entity
extends CharacterBody3D

#@onready var _input := PlayerInput
var _states : Dictionary[String,EntityState] = {}
var _state : EntityState = null
var _tags : Array[String] = []
var _attributes : Dictionary[String,int] = {}

func _init():
	# entity setup
	pass

func _process(delta):
	if _state : _process_state(delta)

func _process_state( delta ) -> bool :
	if _state:
		#then update state
		_state.update(delta)
		#check if changed to next state
		if _state.finished(): setstate(_state.next())
		return true
	return false
	

func states() -> Array[EntityState]: return _states.values()
func state() -> EntityState : return _state
func getstate( state : String ) -> EntityState : return _states[state] if _states.has(state) else null

func addstate( state : EntityState ) -> void :
	_states[state.name()] = state

func setstate( state : String ) -> EntityState:
	var newstate = getstate(state) if state.length() else null
	if( newstate ) : _state = newstate.from(_state)
	return state()

func attributes() -> Array[String] : return _attributes.keys()
func has( attribute : String ) -> bool: return attributes().has(attribute)
func attribute(attribute:String) -> int : return _attributes[attribute] if has(attribute) else 0
func istag( tag : String ) -> bool : return _tags.has(tag)
func tag( tag : String ) -> Entity :
	if !istag(tag): _tags.append(tag.to_lower())
	return self
