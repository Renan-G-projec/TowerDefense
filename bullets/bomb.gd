class_name Bomb
extends Bullet

@export_group("Splash Effect")
@export var splash_radius: float = 32.0

@export_range(0.0, 1.0) var edge_damage_multiplier: float = 0.5
@export var damage_frame: int = 0

var _exploded: bool = false

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if _sprite.sprite_frames.has_animation("fly"):
		_sprite.play("fly")
	else:
		_sprite.animation = "exploding"
		_sprite.frame = 0
		_sprite.stop()
	
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	_sprite.scale = Vector2(0.6, 0.6)
	tween.tween_property(_sprite, "scale", Vector2.ONE, 0.2)

func _process(delta: float) -> void:
	if _exploded:
		return
	position = position + (speed * delta * direction)

func _on_area_entered(area: Area2D) -> void:
	if _exploded: return
	if area is EnemyBase:
		_exploded = true
		_explode.call_deferred()

func _explode() -> void:
	monitoring = false
	monitorable = false
	rotation = 0.0
	
	_sprite.play("exploding")
	while  _sprite.frame < damage_frame and _sprite.is_playing():
		await  _sprite.frame_changed
	_deal_splash_damage()
	if _sprite.is_playing():
		await _sprite.animation_finished
	queue_free()

func _deal_splash_damage() -> void:
	for area in $BlastArea.get_overlapping_areas():
		var enemy := area as EnemyBase
		if enemy == null:
			continue
		
		var distance := enemy.global_position.distance_squared_to(global_position)
		var closeness := 1.0 - clampf(distance / splash_radius, 0.0, 1.0)
		var multiplier := lerpf(edge_damage_multiplier, 1.0, closeness)
		
		enemy.take_damage(damage * multiplier)
	
	
	
	
	
