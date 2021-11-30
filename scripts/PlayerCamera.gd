extends Camera2D

export (Vector2) var offset_pos = Vector2(0, 20)
export (float) var offset_time = 0.05

onready var tween: Tween = $Tween

func shake():
	tween.interpolate_property(
		self,
		"offset",
		Vector2.ZERO,
		offset_pos,
		offset_time,
		Tween.TRANS_BOUNCE, Tween.EASE_OUT
	);
	tween.start()
	yield(tween, "tween_all_completed")

	tween.interpolate_property(
		self,
		"offset",
		offset_pos,
		Vector2.ZERO,
		offset_time,
		Tween.TRANS_BOUNCE, Tween.EASE_OUT
	);
	tween.start()
	yield(tween, "tween_all_completed")