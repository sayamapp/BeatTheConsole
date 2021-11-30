extends KinematicBody2D

signal get_key

export (float) var jump_force = 100.0
export (float) var gravity = 100.0
export (PackedScene) var key_glitch

var is_visible = true
var velocity = Vector2.ZERO

func _ready():
	$HitArea.connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = 0.0
	velocity = move_and_slide(velocity, Vector2.UP)

func glitch():
	if !is_visible: return
	if !is_on_floor(): return
	if $CheckRay.get_collider() != null: return

	var _g = key_glitch.instance()
	_g.position = global_position
	owner.add_child(_g)
	position.y -= 8.0
	velocity.y -= jump_force

func _on_body_entered(_body):
	if !is_visible: return
	
	visible = false
	is_visible = false
	Sounds.play("key")
	emit_signal("get_key")
