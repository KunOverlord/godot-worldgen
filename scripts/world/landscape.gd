@tool
class_name LandscapeWorld extends Node3D

var world: WorldSeed = WorldSeed.new()

@export_group("Terrain Settings")
@export var chunk_count: Vector2i = Vector2i(2, 2)
@export var chunk_size: int = 32
@export var textures: WorldTextures = WorldTextures.new():
	set(val):
			textures = val
			world.textures = val # Pass it down to the internal resource
			if Engine.is_editor_hint():
				regenerate_world.call_deferred()

@export_group("Controls")
@export var CLICK_TO_REGENERATE: bool = false:
	set(val):
		# We only trigger if the user sets it to TRUE
		if val == true:
			world.create_seed()
			regenerate_world.call_deferred()
			CLICK_TO_REGENERATE = false 

func _ready() -> void:
	print("--- LandscapeWorld script is LIVE in the Scene Tree ---")

func regenerate_world() -> void:
	print("--- Starting Regeneration ---")
	
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
			_create_chunk(Vector2i(x, z))
	
	print("--- Generation Finished ---")

func _create_chunk(coord: Vector2i) -> void:
	var chunk = TerrainNode.new()
	chunk.name = "Chunk_%d_%d" % [coord.x, coord.y]
	add_child(chunk)
	
	# IMPORTANT: Without this, you won't see the chunks in the 3D Viewport
	if Engine.is_editor_hint():
		chunk.owner = get_tree().edited_scene_root
		
	chunk.setup(coord, chunk_size, world.noise)
	
	if textures:
		chunk.apply_visuals(textures)
