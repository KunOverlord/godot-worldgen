@tool
class_name WorldSeed extends Resource

@export var template: WorldTemplate:
	set(val):
		template = val
		_sync_template_data() # Apply template defaults to this seed instance

# Inspector Button
@export var RANDOMIZE_SEED: bool = false:
	set(val):
		if val:
			create_seed()
			RANDOMIZE_SEED = false
			notify_property_list_changed()

var seed_string: String # Renamed from 'seed' to avoid confusion with noise.seed
var noise: FastNoiseLite = FastNoiseLite.new()

# Derived data from Template + Seed
var water_level: float = 0.0
var water_color: Color = Color.LIGHT_BLUE

## Constructor: p_template is optional for Inspector compatibility
func _init( tpl: WorldTemplate = null) -> void:
	if tpl:
		template = tpl
	
	# Initial Setup
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.02
	create_seed()

func create_seed(size: int = 8) -> void:
	seed_string = _generate_random_string(size)
	print("New Seed [ %s ]" % seed_string)
	_update_noise()

func _update_noise() -> void:
	if noise:
		noise.seed = seed_string.hash()
	# Here you could also use the seed to "jitter" template values 
	# (e.g., slightly different water height for every seed)

func _sync_template_data() -> void:
	if template:
		# Extract data from the Template "DNA"
		water_color = template.sky_color # Or template.water_data.color
		# Use the seed to slightly randomize the template's base levels
		water_level = template.get_initial_water_level() 
		print("Seed synced with Template: ", template.resource_name)

func _generate_random_string(length: int) -> String:
	var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var result = ""
	for i in range(length):
		result += chars[randi() % chars.length()]
	return result
