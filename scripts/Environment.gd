extends Node2D

enum State {DEFAULT, PAUSE, TRANSITION, TITLE}
var state = State.DEFAULT

onready var pause_menu = $GUI/PauseMenu
onready var transition_anim = $Transition/AnimationPlayer
onready var title = $Transition/StageTitle
onready var inst = $Instruction
onready var console = $Console/Console
onready var labels = [
	$Instruction/Decide,
	$Instruction/Pause,
	$Instruction/Retry,
	$Instruction/Left,
	$Instruction/Right,
	$Instruction/Jump,
	$Instruction/Beat,
]


func _ready():
	$Transition/Top.visible = true
	$Transition/Bottom.visible = true
	pause_menu.visible = false
	pause_menu.get_node("HSlider").connect("value_changed", self, "_on_volume_changed")
	title.visible = false
	transition_anim.play("open")
	yield(get_tree(), "idle_frame")
	yield(transition_anim, "animation_finished")

func pause(flag):
	pause_menu.visible = flag

func next():
	transition_anim.play("close")
	yield(transition_anim, "animation_finished")
	$Instruction/Stage.visible = false
	yield(get_tree().create_timer(0.3), "timeout")

	var _nn = Global.get_stage_number()
	var _ns = Global.get_stage_title()
	_set_title(_nn + 1, _ns)

	title.visible = true
	yield(get_tree().create_timer(2.0), "timeout")
	title.visible = false
	yield(get_tree().create_timer(0.2), "timeout")
	Global.next()


func set_stage(n):
	$Instruction/Stage.set_label(n)

func hit_console():
	$Console/AnimationPlayer.play("beat")
	var _r = randi() % 16
	if _r == 0:
		$Console/Hand.play("cat")
	elif _r == 1:
		$Console/Hand.play("robot")
	else:
		$Console/Hand.play("default")


func _set_title(_n, _str):
	title.get_node("Stage").text = "Stage:%s/10" % _n 
	title.get_node("Title").text = _str

func _on_volume_changed(value):
	Sounds.set_volume(value)

func set_instruction(_str, _n = -1):
	if _n == 0:
		labels[1].set_label("OPTION", "esc")
		labels[2].set_visible(false)
		labels[3].set_visible(false)
		labels[4].set_visible(false)
		labels[5].set_visible(false)
		labels[6].set_visible(false)
	elif _n != 1:
		labels[1].set_label("PAUSE", "esc")
		labels[2].set_visible(true)
		labels[3].set_visible(true)
		labels[4].set_visible(true)
		labels[5].set_visible(false)
		labels[6].set_visible(true)
	elif _str == "1-1":
		labels[3].set_visible(true)
		labels[4].set_visible(true)
		labels[5].set_visible(true)
		labels[3].blink()
		labels[4].blink()
		labels[5].blink()
	elif _str == "1-2":
		return
	elif _n == 2:
		labels[1].set_label("PAUSE", "esc")
		labels[2].set_visible(true)
		labels[3].set_visible(true)
		labels[4].set_visible(true)
		labels[5].set_visible(true)
		labels[6].set_visible(false)
	elif _str == "2-1":
		return
	elif _str == "2-2":
		labels[5].set_label("JUMP", "S+J")
		labels[5].blink()
	elif _n == 3:
		labels[1].set_label("PAUSE", "esc")
		labels[2].set_visible(true)
		labels[3].set_visible(true)
		labels[4].set_visible(true)
		labels[5].set_visible(true)
		labels[5].set_label("JUMP", "S+J")
		labels[6].set_visible(false)
	elif _str == "3-1":
		labels[6].set_visible(true)
		labels[6].blink()
	elif _n >= 4:
		labels[1].set_label("PAUSE", "esc")
		labels[2].set_visible(true)
		labels[3].set_visible(true)
		labels[4].set_visible(true)
		labels[5].set_visible(true)
		labels[5].set_label("JUMP", "S+J")
		labels[6].set_visible(true)	
	else:
		return







	
