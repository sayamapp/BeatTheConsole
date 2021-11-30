extends Node

export (int) var debug_stage = 0

export (Array, PackedScene) var stages 
export (Array, String) var next_stage_titles

var stage_number = 0

var inst_visible = [true, true, true, false, false, false, false]

func _ready():
	stage_number = debug_stage
	print("stage @ Global ", stage_number)
	var _e = get_tree().change_scene_to(stages[stage_number])

func next():
	stage_number += 1
	load_stage()

func load_stage():
	var _e = get_tree().change_scene_to(stages[stage_number])

func get_stage_number():
	return stage_number

func get_stage_title():
	return next_stage_titles[stage_number + 1]
