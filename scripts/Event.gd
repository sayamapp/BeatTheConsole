extends Area2D

signal event_finished(_str)

export (Array, String, MULTILINE) var contents = []
export (String) var event_name = "please set event_name"

var i = 0

var is_finished = false
var player

onready var window = $Window 
onready var window_anim = $Window/AnimationPlayer

func _unhandled_input(event):
	if event.is_action_pressed("jump"):
		Sounds.stop("talk")
		if i >= contents.size():
			window_anim.play("close")
			yield(window_anim, "animation_finished")
			is_finished = true
			player.set_process_unhandled_input(true)
			player.set_physics_process(true)
			set_process_unhandled_input(false)
			emit_signal("event_finished", event_name)
		else:
			_set_contents(contents[i])
			i += 1


func _ready():
	set_process_unhandled_input(false)
	var _e = connect("body_entered", self, "_on_event_start")
	window.visible = false

func _on_event_start(_body):
	if is_finished: return

	if event_name == "2-1":
		Sounds.play("damage")

	player = _body 
	player.set_process_unhandled_input(false)
	player.set_physics_process(false)

	_set_contents(contents[i])
	i += 1
	window_anim.play("open")

	yield(window_anim, "animation_finished")
	set_process_unhandled_input(true)

func _set_contents(_str):
	var _label = window.get_node("MarginContainer/Contents")
	_label.bbcode_text = _str
	Sounds.play("talk")
