extends KinematicBody2D

export (float) var speed = 10.0
export (float) var gravity = 100.0 
export (float) var jump_force = 100.0
export (PackedScene) var enemy_glitch

var velocity = Vector2.ZERO
var is_death = false

onready var particle = $DeathEffect/CPUParticles2D

func _ready():
	$HitArea.connect("body_entered", self, "_on_hitarea_entered")

func _physics_process(delta):
	velocity.y += gravity * delta

	if is_on_floor():
		velocity.x = speed
	else:
		velocity.x = 0.0

	velocity = move_and_slide(velocity, Vector2.UP)

func glitch():
	if is_death: return
	if !is_on_floor(): return
	if $CheckRay.get_collider() != null: return
	if $CheckGround.get_collider() == null: return

	velocity.x = 0.0

	var p_pos_x = global_position.x
	var g_pos_x = floor(p_pos_x / 8.0) * 8.0 + 4.0
	var g_pos = Vector2(g_pos_x, global_position.y)

	global_position.x = g_pos_x
	global_position.y -= 8.0
	velocity.y -= jump_force

	var _g = enemy_glitch.instance()
	_g.position = g_pos
	owner.add_child(_g)

func _on_hitarea_entered(_body):
	set_physics_process(false)
	Sounds.play("slime_death")
	particle.emitting = true
	$AnimatedSprite.visible = false
	print("death @ Enemy")
	is_death = true
