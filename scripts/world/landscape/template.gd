@tool
class_name LandTemplate extends WorldTemplate

const MAT_SIZE : int = 7

@export_group("Terrain Biome")
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
