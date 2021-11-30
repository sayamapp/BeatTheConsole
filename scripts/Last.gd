extends Node

onready var player = get_node("../Player")
onready var fire_scene = preload("res://scenes/Fire.tscn")
onready var fire_wall_scene = preload("res://scenes/FireWall.tscn")

var is_fall = false

var fire_wall = false
var firewall_pos = Vector2.ZERO

func _ready():
	Sounds.play("last")
	$Timer.connect("timeout", self, "_on_timer_timeout")
	$Gravity.connect("body_entered", self, "_on_gravity_body_entered")
	$GravityEnd.connect("body_entered", self, "_on_gravity_end_body_entered")
	$FireWall.connect("body_entered", self, "_on_fire_wall_body_entered")
	$FireWall2.connect("body_entered", self, "_on_fire_wall2_body_entered")
	$Timer.start()

func _on_timer_timeout():
	var _fire = fire_scene.instance()
	if fire_wall: return
	if !is_fall:
		var _pos_x = rand_range(player.position.x - 200, player.position.x + 200)
		var _pos_y = player.position.y - 100.0
		_fire.global_position = Vector2(_pos_x, _pos_y)
	else:
		var _pos_x = rand_range(player.position.x - 100, player.position.x + 100)
		var _pos_y = player.position.y - 20.0
		_fire.global_position = Vector2(_pos_x, _pos_y)
	owner.add_child(_fire)


func _on_gravity_body_entered(_body):
	if _body.name == "Player":
		is_fall = true
		player.max_gravity = 100.0


func _on_gravity_end_body_entered(_body):
	if _body.name == "Player":
		is_fall = false
		player.max_gravity = 10000.0

func _on_fire_wall_body_entered(_body):
	fire_wall = true
	firewall_pos = $FireWallStartPos.global_position
	$Timer2.connect("timeout", self, "_on_firewall")
	$Timer2.start()

func  _on_firewall():
	var _fw = fire_wall_scene.instance()
	_fw.global_position = firewall_pos
	firewall_pos.x += 16.0
	owner.add_child(_fw)

func  _on_fire_wall2_body_entered(_body):
	if _body.name == "Player":
		Sounds.stop("last")
		player.camera_zoom()
		$Timer2.wait_time = 0.27
		$Timer2.start()


		
