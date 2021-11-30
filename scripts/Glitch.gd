extends KinematicBody2D

func _ready():
	var _s = $Sprite
	var _frame_size = _s.hframes * _s.vframes
	_s.frame = randi() % _frame_size