@tool
class_name LandscapeWorld extends World

const TEST_WORLD = preload("res://assets/templates/lands/tropical.tres")

var world: WorldSeed = WorldSeed.new(TEST_WORLD)
var water: WaterNode # to implement from the WorldSeed generation
var nodes: Array[TerrainNode] = []

@export_group("Terrain Settings")
@export var chunk_count: Vector2i = Vector2i(2, 2)
@export var node_size: int = 32
@export var textures: WorldTextures = WorldTextures.new():
	set(val):
			textures = val
			#world.textures = val # Pass it down to the internal resource
			if Engine.is_editor_hint():
				generate_world.call_deferred()

@export_group("Controls")
@export var CLICK_TO_REGENERATE: bool = false:
	set(val):
		# We only trigger if the user sets it to TRUE
		if val == true:
			world.create_seed()
			generate_world.call_deferred()
			CLICK_TO_REGENERATE = false 

func _ready() -> void:
	print("--- LandscapeWorld script is LIVE in the Scene Tree ---")
	
func world_offset() -> Vector2 :
	return Vector2(chunk_count.x * node_size / 2, chunk_count.y * node_size / 2 )

func generate_world() -> void:
	print("--- Starting Regeneration ---")
	#prepare the world origin offset
	offset = world_offset()
	
	# 1. Clear existing chunks
	for child in get_children():
		if child is TerrainNode:
			child.free()
	
	# 2. Check for Noise
	if not world or not world.noise:
		printerr("ABORT: WorldSeed or Noise is null")
		return
	
	# 3. Force Noise Update
	world._update_noise()
	
	# 4. Create chunks
	for x in range(chunk_count.x):
		for z in range(chunk_count.y):
			#nodes.append( create_node(Vector2i(x, z) ) )
			create_node(Vector2i(x, z ) ) 
	
	print("--- Generation Finished ---")

func create_node(coord: Vector2i) -> TerrainNode:
	var node = TerrainNode.new()
	node.name = "node_%d_%d" % [coord.x, coord.y]
	add_child(node)
	
	# IMPORTANT: Without this, you won't see the chunks in the 3D Viewport
	if Engine.is_editor_hint():
		node.owner = get_tree().edited_scene_root
		
	node.setup(coord, offset, node_size, world.noise)
	
	if textures:
		node.apply_visuals(textures)

	return node

	
