@tool
class_name LandTemplate extends WorldTemplate


@export_group("Materials")
@export var water : WaterMaterial
## The collection of LandMaterials (Grass, Sand, etc.) and their rules.
@export var terrain: Array[LandMaterial] = [] :
	set(val):
		if val.size() > MAT_SIZE:
			# Slice the array to keep only the first 7
			terrain = val.slice(0, MAT_SIZE)
			push_warning("WorldMaterial limit reached")
		else:
			terrain = val

@export_group("Generation Bounds")
@export var min_height: float = -10.0
@export var max_height: float = 30.0

#used to test static loading	
static func testworld() -> WorldSeed:
	return create("tropical",TYPE_LAND)
	#return WorldSeed.new( preload("res://assets/templates/land/tropical.tres") )

	
