@tool
class_name WorldTemplate extends Resource

const TYPE_LAND = "land"
const TYPE_PLANET = "planet"
const TYPE_SOLAR = "solar"
const TYPE_VOXEL = "voxel"
const TYPE_DUNGEON = "dungeon"


@export_group("Materials")
@export var materials: Array[WorldMaterial] = []
	
@export_group("Atmosphere & Lighting")
@export var sky: Array[Color] = [Color.ALICE_BLUE,Color.SKY_BLUE,Color.ROYAL_BLUE]
#@export var ambient: Array[Color] = [Color.ALICE_BLUE] #use for albedo and fog color
@export var sun_intensity: Array[float] = [1.0,1.2,1.5,1.8]
@export var sun_color: Array[Color] = [Color.WHITE,Color.LIGHT_GOLDENROD]

#override to scope on the quired world materials
func world_materials() -> Array[WorldMaterial]:
	return materials

#fill all template attributes here. Override with world class types
func attributes() -> Dictionary :
	var contents = {}
	if sky : contents["sky"] = sky
	if sun_intensity : contents["sun_intensity"] = sun_intensity
	if sun_color : contents["sun_color"] = sun_color
	return contents
