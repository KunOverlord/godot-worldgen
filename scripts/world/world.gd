class_name World
extends Node3D

#var world : WorldSeed

#set the world's base offset for rendering
@export var offset : Vector2 = Vector2.ZERO


#
#func materials() -> Array[WorldMaterial] :
#	return world.template.materials
