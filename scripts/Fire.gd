extends KinematicBody2D

var gravity = 100.0
var velocity = Vector2.ZERO

var is_death = false

func _ready():
	$Timer.connect("timeout", self, "_on_timeout")

func _physics_process(delta):
	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)

func _on_timeout():
	queue_free()
