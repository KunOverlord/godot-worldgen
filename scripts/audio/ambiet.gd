extends AudioLayer
class_name AmbientLayer

@export var base_pitch: float = 1.0

func setup(ambient_stream: AudioStream):
	player.stream = ambient_stream
	player.autoplay = true
	player.pitch_scale = base_pitch

func set_pitch(new_pitch: float):
	player.pitch_scale = new_pitch
