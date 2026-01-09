class_name AudioLayer extends Node

var player: AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Master" # Or a specific bus like "Sfx" or "Music"

func play_layer():
	player.play()

func stop_layer():
	player.stop()
