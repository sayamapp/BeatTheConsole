extends Node

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		get_node("../Game/Environment").next()
