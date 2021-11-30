extends KinematicBody2D

signal player_death
signal glitch

export (float) var speed = 10.0
export (float) var high_jump_force = 100.0
export (float) var jump_force = 50.0
export (float) var gravity = 10.0
export (float) var glitch_jump_force = 50.0
export (PackedScene) var player_glitch


var velocity: Vector2 = Vector2.ZERO
var ability = {
	"high_jump": false,
	"glitch": true,
}

var max_gravity = 10000.0

var is_jump = false

var zoom = false

func _ready():
	var _e = $HitArea.connect("body_entered", self, "_on_hit_area_entered")

	match Global.get_stage_number():
		1, 2:
			ability.high_jump = false
			ability.glitch = true
		3:
			ability.high_jump = false
			ability.glitch = true
		_:
			ability.high_jump = false
			ability.glitch = true


func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.y = min(max_gravity, velocity.y)

	if Input.is_action_pressed("right"):
		velocity.x = speed 
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
		$AnimatedSprite.flip_h = true
	else:
		velocity.x = 0.0

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			if ability.high_jump:
				Sounds.play("jump")
				velocity.y = -high_jump_force

	if Input.is_action_pressed("jump") && Input.is_action_pressed("down"):
		if is_on_floor() && !ability.high_jump:
			velocity.y = -jump_force
			Sounds.play("jump")

	if !is_on_floor():
		is_jump = true

	if is_jump && is_on_floor():
		Sounds.play("ground")
		is_jump = false

	if Input.is_action_just_pressed("glitch"):
		emit_signal("glitch")
			
	# Set Animation
	var _animation_name = "idle"
	if !is_on_floor():
		_animation_name = "air"
	elif velocity.x != 0.0:
		_animation_name = "run"

	$AnimatedSprite.play(_animation_name)

	# Move
	velocity = move_and_slide(velocity, Vector2.UP)

	if zoom:
		$PlayerCamera.zoom.x -= 0.1 * delta
		$PlayerCamera.zoom.y -= 0.1 * delta

func glitch():
	if !ability.glitch: return
	if !is_on_floor(): return

	# Check
	var _ground_col = $CheckGround.get_collider()
	var _can_glitch_col = $CheckGlitch.get_collider()
	var _can_jump_col = $CheckJump.get_collider()

	if _ground_col == null: return

	if _can_jump_col != null: return
	
	if _can_glitch_col != null:
		global_position.y -= 8.0
		return

	velocity.x = 0.0

	var p_pos_x = global_position.x
	var g_pos_x = floor(p_pos_x / 8.0) * 8.0 + 4.0
	var g_pos = Vector2(g_pos_x, global_position.y)

	global_position.x = g_pos_x
	global_position.y -= 16.0
	velocity.y -= glitch_jump_force

	var _g = player_glitch.instance()
	_g.position = g_pos
	owner.add_child(_g)
	

	# Check


func death():
	print("Player is dead.")
	$AnimatedSprite.visible = false
	for _p in $DeathEffect.get_children():
		_p.emitting = true

	set_pause(true)
	Sounds.play("death")
	# emit_signal("player_death")
	yield(get_tree().create_timer(1.0), "timeout")
	Global.load_stage()


func set_pause(flag):
	set_physics_process(!flag)

func camera_zoom():
	zoom = true
	
# Hit enemy or trap
func _on_hit_area_entered(_body):
	if _body.is_in_group("trap"):
		death()
	if _body.is_in_group("enemy"):
		if !_body.is_death:
			death()
