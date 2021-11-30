extends Label

func set_label(_name, _button):
	var _b = "[%s]" % _button
	var _str = ""
	for i in 13:
		if i < _name.length():
			_str = _str + _name[i]
		elif i < 13 - _b.length():
			_str = _str + " "
		else:
			_str = _str + _b
			break
	text = _str


func set_visible(flag):
	visible = flag

func blink():
	var tween: Tween = Tween.new()
	add_child(tween)
	for i in 5:
		tween.interpolate_property(
			self,
			"modulate:a",
			0.0,
			1.0,
			0.3,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
		)
		tween.start()
		yield(tween, "tween_all_completed")
