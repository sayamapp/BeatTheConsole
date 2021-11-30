extends Node

var glitch_objects = []
var key_count = 0

onready var environment = $Environment
onready var player = $Player
onready var player_camera = $Player/PlayerCamera
onready var stage = $Stage
onready var door = $Door

var is_pause = false

func _unhandled_input(event):
	if event.is_action_pressed("retry"):
		print("RETRY @ Game")
		Global.load_stage()
	if event.is_action_pressed("esc"):
		if !is_pause:
			is_pause = true
			player.set_pause(true)
			environment.pause(true)
		else:
			is_pause = false
			player.set_pause(false)
			environment.pause(false)

func _ready():
	player.connect("player_death", self, "_on_player_death")
	player.connect("glitch", self, "_on_glitch")
	door.connect("door_entered", self, "_on_clear")
	if has_node("Events"):
		for _e in $Events.get_children():
			_e.connect("event_finished", self, "_on_event_finished")
	for _obj in get_children():
		if _obj.is_in_group("glitch"):
			glitch_objects.push_back(_obj)
			if _obj.is_in_group("key"):
				_obj.connect("get_key", self, "_on_get_key")
				key_count += 1

	print(key_count, "key_count")
	if key_count == 0:
		door.open()

	environment.set_stage(Global.get_stage_number())
	environment.set_instruction("", Global.get_stage_number())




func _on_glitch():
	if !player.ability.glitch: return

	Sounds.play("glitch")
	environment.hit_console()
	for _obj in glitch_objects:
		_obj.glitch()

	stage.glitch()
	player_camera.shake()


func _on_get_key():
	key_count -= 1
	if key_count == 0:
		door.open()


func _on_clear():
	Sounds.play("clear")
	player.set_pause(true)
	environment.next()

func _on_event_finished(_str):
	environment.set_instruction(_str)
	match _str:
		"2-1":
			player.ability.high_jump = false
		"2-2":
			player.ability.glitch = true

	


