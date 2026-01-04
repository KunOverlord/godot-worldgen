@tool
class_name LandMaterial extends WorldMaterial

@export_group("Texture Data")
@export var texture: Texture2D

@export_group("Terrain Properties")
@export var height_range: Vector2 = Vector2(0.0, 10.0) # x = min, y = max
@export var slope_threshold: float = 0.7
@export var transition_falloff: float = 2.0 # For smooth blending
