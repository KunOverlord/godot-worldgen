class_name World
extends Node3D

#private types
var _seed : WorldSeed = WorldSeed.new()
var _template : WorldTemplate = null

#set the world's base offset for rendering
@export var offset : Vector2 = Vector2.ZERO

#override
func _init():
	_seed.reset(template())
	
#override
func template() -> WorldTemplate:
	return _template
	
func worldseed() -> WorldSeed:
	return _seed

func update_noise() -> void:
	if _seed : _seed.update_noise()
	#if _seed : _seed.fill(self)
