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

@onready var sprite: Sprite2D = $Sprite2D
@onready var parent: PathFollow2D = get_parent()

signal died()
signal life_changed(new_life: float)

var _tween: Tween

func _process(delta: float) -> void:
	parent.progress += 20 * delta

func take_damage(damage_amout: float) -> void:
	life -= damage_amout
	
	sprite.scale = Vector2(1.2, 0.8)
	sprite.self_modulate = Color.WHITE * 10
	
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	_tween.tween_property(sprite, "scale", Vector2.ONE, 0.3)
	_tween.tween_property(sprite, "self_modulate", Color.WHITE, 0.3)
	
