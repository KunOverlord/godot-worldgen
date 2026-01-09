class_name SoundEffectLayer extends AudioLayer

@export var sound_pool: Array[AudioStream] = []
@export var wait_range: Vector2 = Vector2(5.0, 15.0) # Min/Max seconds
@export var pitch_range: Vector2 = Vector2(0.8, 1.2)

var timer: float = 0.0

func _ready():
	super._ready()
	_reset_timer()

func _process(delta):
	timer -= delta
	if timer <= 0:
		_play_random_sound()
		_reset_timer()

func _play_random_sound():
	if sound_pool.is_empty(): return
	
	player.stream = sound_pool.pick_random()
	player.pitch_scale = randf_range(pitch_range.x, pitch_range.y)
	player.play()

func _reset_timer():
	timer = randf_range(wait_range.x, wait_range.y)
