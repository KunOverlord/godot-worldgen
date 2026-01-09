class_name WorldSeed extends Resource

# Key: String (Attribute Name), Value: Variant (The generated value)
var _data: Dictionary = {}
var _seed: String # Renamed from 'seed' to avoid confusion with noise.seed
var _noise: FastNoiseLite = FastNoiseLite.new()

# Derived data from Template + Seed
var water_level: float = 0.0
var water_color: Color = Color.LIGHT_BLUE

func _init( ) -> void:
	# Initial Setup
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.frequency = 0.02
	create_seed()

#
func noise() ->FastNoiseLite:
	return _noise

func create_seed(size: int = 8) -> void:
	_seed = generate(size)
	print("New Seed [ %s ]" % _seed)
	update_noise()

#refresh noise
func update_noise():
	_noise.seed = _seed.hash()

func generate(length: int) -> String:
	var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var result = ""
	for i in range(length): result += chars[randi() % chars.length()]
	return result

func reset( template : WorldTemplate) -> WorldSeed:
	create_seed()
	return fill(template)

#fill the seed with the world _data
func fill(template: WorldTemplate = null) -> WorldSeed:
	# 1. Start with a completely fresh, local, untyped dictionary
	var new_data: Dictionary = {} 
	
	if not template:
		_data = new_data
		return self
	
	# 2. Get the source. We don't type 'contents' here to avoid inheritance issues
	var contents = template.attributes()
	
	var rnd = RandomNumberGenerator.new()
	rnd.seed = _noise.seed
	
	for att in contents:
		var options = contents[att]
		
		# Check if options is a valid Array and not null
		if options is Array and options.size() > 0:
			var picked_value = options[rnd.randi() % options.size()]
			# 3. Assign the single value (Float/Color) to the untyped map
			new_data[att] = picked_value
		else:
			# Safety fallback for empty arrays in template
			printerr("WorldSeed: Template attribute '", att, "' is empty or not an array.")
	
	# 4. Swap the local data into the class variable
	_data = new_data
	return self


func attributes() -> Dictionary : return _data
func has_attribute( name = "" ) -> bool : return name.length() and attributes().has(name)
func get_attribute(name : String , default : Variant = null) -> Variant: return _data.get(name,default)
func set_attribute(name : String , value : Variant ) : _data.set(name,value)
	
