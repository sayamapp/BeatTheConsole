extends KinematicBody2D

var is_death = false

var start_pos_y = 0.0
var pos_y = 0.0

func _ready():
	start_pos_y = position.y
	pos_y = position.y

func _physics_process(delta):
	pos_y -= 100.0 * delta
	position.y = max(pos_y, start_pos_y - 150.0)
