extends Node
# Save as GamePlayer.gd and set as Autoload (Singleton)

const BASE_JUMP = 4.0
const BASE_STRENGTH = 1.0
const BASE_SPEED = 2.0

signal energy_changed(new_value, new_progress)

var _energy: int = 0
var _max_energy: int = 500

# Attributes calculated on the fly
func get_progress() -> float: 
	return (float(_energy) / _max_energy) * 100.0

func can_fly() -> bool: 
	return get_progress() >= 100

func get_speed() -> float: 
	return BASE_SPEED + (_energy * 0.05) # Balanced so 500 energy = 29 speed

func get_jump() -> float: 
	return BASE_JUMP + (_energy * 0.02)

func get_strength() -> float: 
	return BASE_STRENGTH + (_energy * 0.1)

func boost(amount: int):
	_energy = clampi(_energy + amount, 0, _max_energy)
	energy_changed.emit(_energy, get_progress())
	
	if _energy >= 100:
		print("Flight Capability Unlocked!")
