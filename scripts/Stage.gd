extends Node2D

export (int) var glitch_n = 3

var tween: Tween = Tween.new()
var glitch_sprites = []
var prev_a = 0.0

onready var glitch_sprite: Sprite = $StageGlitch
onready var main_map: TileMap = $Main

func _ready():
	add_child(tween)
	prev_a = main_map.modulate.a
	var used_cells = main_map.get_used_cells()
	for _cell in used_cells:
		var _cellv = main_map.map_to_world(_cell)
		var _sprite = glitch_sprite.duplicate()
		_sprite.set_position(_cellv + Vector2(4.0, 4.0))
		_sprite.set_visible(false)
		_sprite.set_modulate(main_map.get_modulate())
		glitch_sprites.push_back(_sprite)
		add_child(_sprite)

func glitch():
	var _a = min(1.0, main_map.modulate.a * 1.5)
	tween.interpolate_property(
		self,
		"modulate:a",
		_a,
		prev_a,
		0.9,
		Tween.TRANS_BOUNCE,
		Tween.EASE_IN_OUT
	)
	tween.start()
		
	for _gs in glitch_sprites:
		if randi() % glitch_n == 0:
			_gs.frame = randi() % (_gs.get_hframes() * _gs.get_vframes())
			_gs.glitch()

	yield(tween, "tween_all_completed")
