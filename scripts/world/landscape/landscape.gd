@tool
class_name LandscapeWorld extends World

var _water: WaterNode 

@export_group("Terrain Settings")
@export_range(8,64,2) var node_size: int = 8
@export var node_count: Vector2i = Vector2i(0, 0)

@export_group("Controls")
@export var CLICK_TO_REGENERATE: bool = false:
	set(val):
		# We only trigger if the user sets it to TRUE
		if val == true:
			_seed.reset(_template)
			create_landscape.call_deferred()
			CLICK_TO_REGENERATE = false 

#
func _init():
	if _template :
		print_debug("Attributes",_template.attributes())
	super._init()

func _ready() -> void:
	print("--- LandscapeWorld script is LIVE in the Scene Tree ---")

#
func template() -> LandTemplate:
	if _template == null: _template = GameData.landscapeworld("tropical")
	return super.template()

func tiles() -> Vector2 :
	if( node_count.x and node_count.y): return node_count
	return template().tiles

func tile_size() -> float:
	return node_size if node_size > 0 else template().tile_size

func create_offset() -> Vector2 :
	var nodes = tiles()
	var size = tile_size()
	return Vector2(nodes.x * size / 2, nodes.y * size / 2 )


	
func create_landscape() -> void:
	print("--- Starting Regeneration ---")
	#prepare the _template origin offset
	offset = create_offset()
	var seed : WorldSeed = worldseed()
	var material : ShaderMaterial = template().testmaterial()
	var size = tiles()
	var tile_size = tile_size()
	#var material : ShaderMaterial = template().create_material()
	# 1. Clear existing chunks
	for child in get_children():
		if child is TerrainNode:
			child.free()
	# 2. Check for Noise
	if not seed:
		printerr("ABORT: WorldSeed or Noise is null")
		return
	# 4. Create chunks
	for x in range(size.x):
		for z in range(size.y):
			create_node(Vector2i(x, z ) , material ) 
			
	# 5.- Create Water surface if required
	create_water()
	print("--- Generation Finished ---")

func create_node(coord: Vector2i , material : ShaderMaterial = null ) -> TerrainNode:
	var noise = worldseed().noise()
	var node = TerrainNode.new()
	node.name = "node_%d_%d" % [coord.x, coord.y]
	add_child(node)
	
	# IMPORTANT: Without this, you won't see the chunks in the 3D Viewport
	if Engine.is_editor_hint():
		node.owner = get_tree().edited_scene_root
		
	node.setup(coord, offset, tile_size(), noise )
	if material: node.apply_shader(material)
	return node

#
func create_water() -> void:
	# 1. Clean up old water if it exists
	if _water and is_instance_valid(_water):
		_water.queue_free()
	
	# 2. Get data from the Seed
	# We assume WorldSeed has already parsed the Template Arrays into single values
	var seed = worldseed() 
	var level = seed.get_attribute("water_level", 0.0)
	var color = seed.get_attribute("water_color", Color.ROYAL_BLUE)
	var tiles = tiles()
	# 3. Instance and Configure
	_water = WaterNode.new()
	_water.name = "WaterLevel"
	add_child(_water)
	
	# Set owner for editor visibility
	if Engine.is_editor_hint():
		_water.owner = get_tree().edited_scene_root
		
	# 4. Calculate size based on grid
	var total_size = tiles.x * tile_size() * 2 # Cover a wide area
	_water.setup(level, color, total_size)
	
	print("Water created at height: ", level)
