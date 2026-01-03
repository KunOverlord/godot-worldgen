@tool
class_name WorldMaterial extends Resource

@export var name: String = "New Material"
@export var texture: Texture2D
@export var height_range: Vector2 = Vector2(0.0, 10.0) # x = min, y = max
@export var slope_threshold: float = 0.7
@export var transition_falloff: float = 2.0 # For smooth blending
