@tool
class_name WaterMaterial extends WorldMaterial

@export var color: Array[Color] = [Color.ROYAL_BLUE]
@export var level : Array[float] = [0.0]
@export var flow: Array[float] = [0.0]


func getcolor() -> Color :
	return color[randi() % color.size()] if color.size() else Color.ROYAL_BLUE
	
func getlevel() -> float:
	return level[randi() % level.size()] if level.size() else 0.0
	
func getflow() -> float:
	return flow[randi() % flow.size()] if flow.size() else 0.0
