extends AudioLayer
class_name MusicLayer

@export var stream: AudioStream
@export var loop_start_time: float = 0.0

func setup(music_stream: AudioStream, start_loop: float):
	stream = music_stream
	loop_start_time = start_loop
	player.stream = stream

func _process(_delta):
	if player.playing and player.get_playback_position() >= player.stream.get_length():
		player.seek(loop_start_time)
