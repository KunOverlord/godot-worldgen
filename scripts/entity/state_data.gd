class_name StateData extends Resource

@export var state: String = "default"
@export var speed_factor: float = 1.0
@export var animations: Dictionary[String,String] = {}

func state_name() -> String : return state.capitalize().replace(" ","") + "State"

func create() -> EntityState:
	var cls = state_name()
	# 2. Search the Global Class List
	for script_data in ProjectSettings.get_global_class_list():
		if script_data["class"] == cls:
			var script = load(script_data["path"])
			return script.new(self) if script else null
	push_error("StateData: Could not find a class named " + cls)
	return null

	
	
	
