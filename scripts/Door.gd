extends AnimatedSprite

signal door_entered

var is_open = false

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")


func _on_body_entered(_body):
	if is_open && _body.name == "Player":
		emit_signal("door_entered")
		print("door entered @ Door")

func open():
	is_open = true
	play("open")