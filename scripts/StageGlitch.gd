extends Sprite

func glitch():
	visible = true 
	yield(get_tree(), "idle_frame")
	var r = randi() % 10 / 24.0 
	yield(get_tree().create_timer(r), "timeout")
	visible = false