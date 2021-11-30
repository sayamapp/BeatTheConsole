extends Label


func set_label(n):
	text = "Stage %s" % n
	visible = true
	var tween: Tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(
		self,
		"modulate:a",
		0.0,
		1.0,
		1.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	tween.start()


