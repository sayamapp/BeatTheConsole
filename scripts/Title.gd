extends Node

var is_option = false

func _unhandled_input(event):
	if event.is_action_pressed("esc"):
		if !is_option:
			$Environment.pause(true)
			is_option = true
		else:
			$Environment.pause(false)
			is_option = false

	if event.is_action_pressed("jump"):
		if !is_option:
			$Start.bbcode_text = "[rainbow]start[/rainbow]"
			set_process_unhandled_input(false)
			Sounds.stop("title")
			Sounds.play("glitch")
			$Environment.next()

func _ready():
	Sounds.play("title")
	$Environment/Transition/AnimationPlayer.play("open")
	$Environment.set_instruction("", 0)
