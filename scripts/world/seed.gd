@tool
class_name WorldSeed extends Resource

# This will be visible
@export var seed_string: String
# This is NOT exported, so it's hidden from the Inspector
var noise: FastNoiseLite = FastNoiseLite.new()
#@export var textures: WorldTextures
#var textures: WorldTextures = WorldTextures.new()

var water_level : float = 0.0
var wataer_color : Color = Color.LIGHT_BLUE

## This acts as your "Randomize" button
@export var RANDOMIZE_SEED: bool = false:
	set(val):
		if val == true:
			# Generate a random 8-character string
			#seed_string = string_hash(8)
			create_seed()
			RANDOMIZE_SEED = false # Reset checkbox
			notify_property_list_changed() # Update the Inspector UI

func _init() -> void:
	# Configure default noise settings internally
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.02
	create_seed()
	#_update_noise()

#Expose the generate seed method
func create_seed(size: int = 8) -> void:
	seed_string = string_hash( size )
	print("New Seed [ %s ]" % seed_string)
	_update_noise()

func _update_noise() -> void:
	if noise:
		noise.seed = seed_string.hash()

func string_hash(length: int) -> String:
	var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var result = ""
	for i in range(length):
		result += chars[randi() % chars.length()]
	return result
