# Ad Maiorem Dei Gloriam!
class_name EnemyBase
extends Area2D

@export var life: float = 100:
	set(val):
		if val == life: return
		if val < 0:
			died.emit()
			queue_free()
		
		life = max(0, val)
		life_changed.emit(life)

@export var money_on_death: int = 5
@export var damage: int = 10
@export var speed: float = 20

@onready var sprite: Sprite2D = $Sprite2D
@onready var parent: PathFollow2D = get_parent()

signal died()
signal life_changed(new_life: float)

var _tween: Tween
var _slow_multiplier: float = 1.0
var _slow_time_left: float = 0.0

var _sway: Tween

func _ready() -> void:
	await get_tree().create_timer(randf_range(0.0, 0.4))
	_sway = create_tween().set_loops().set_trans(Tween.TRANS_QUAD)
	_sway.tween_property($Sprite2D, "rotation", -0.2, 0.4)
	_sway.tween_property($Sprite2D, "rotation", 0.2, 0.4)

func _process(delta: float) -> void:
	parent.progress += speed * delta * _slow_multiplier

func take_damage(damage_amout: float) -> void:
	life -= damage_amout
	
	sprite.scale = Vector2(1.2, 0.8)
	sprite.self_modulate = Color.WHITE * 10
	
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	_tween.tween_property(sprite, "scale", Vector2.ONE, 0.3)
	_tween.tween_property(sprite, "self_modulate", Color.WHITE, 0.3)

func apply_slow(amount: float, duration: float, tint:Color = Color(0.6,0.8,1.0)) -> void:
	_slow_multiplier = min(_slow_multiplier , 1 - amount)
	_slow_time_left = max(_slow_time_left, duration)
	sprite.modulate = tint

func _update_slow(delta: float) -> void:
	if _slow_time_left <= 0.0:
		return
	_slow_time_left = _slow_time_left - delta
	if _slow_time_left <= 0.0:
		_slow_multiplier = 1.0
		sprite.modulate = Color.WHITE
