extends Node

var sounds = {}

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -10)
	for _s in get_children():
		sounds[_s.name] = _s


func play(name):
	sounds[name].play()

func stop(name):
	sounds[name].stop()

func set_volume(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
