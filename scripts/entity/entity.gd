class_name Entity extends CharacterBody3D

@export var _data: EntityData
var _state: EntityState = null

@onready var camera = $CameraPOV
@onready var display = $Display

func _ready():
	change_state("moving")

func states() -> Dictionary[String,StateData]: return _data.states if _data else {}

func _physics_process(delta: float):
	if _state:
		_state.update(self, delta)
		move_and_slide()

func change_state(state_name: String) -> bool:
	var next = states().get( state_name )
	if next and next != _state:
		_state.exit(self)
		_state = next
		_state.enter(self)
		print("State changed to: ", state_name )
		return true
	return false

func direction() -> float : return camera.rotation.y
