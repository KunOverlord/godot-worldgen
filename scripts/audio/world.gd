extends Node
class_name WorldAudioPlayer

# We can add these as children in the editor or via code
var music_layer: MusicLayer
var ambient_layer: AmbientLayer
var sound_layers: Array[SoundEffectLayer] = []

func _ready():
	# Example: Auto-detect children
	for child in get_children():
		if child is MusicLayer: music_layer = child
		if child is AmbientLayer: ambient_layer = child
		if child is SoundEffectLayer: sound_layers.append(child)

func start_environment():
	if music_layer: music_layer.play_layer()
	if ambient_layer: ambient_layer.play_layer()
	# SoundLayers handle themselves via _process
