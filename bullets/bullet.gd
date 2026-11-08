# Ad Maiorem Dei Gloriam!
class_name Bullet
extends Area2D

var direction: Vector2 = Vector2.RIGHT:
	set(val):
		direction = val
		rotation = direction.angle()

@export var speed: float = 300
@export var damage: float = 10

func _ready() -> void:
	var tween: Tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	$Sprite2D.scale = Vector2(1.4, 0.6)
	tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.3)


func _process(delta: float) -> void:
	position += speed * delta * direction


func _on_area_entered(area: Area2D) -> void:
	var enemy: EnemyBase = area as EnemyBase
	if enemy:
		enemy.take_damage(damage)
		queue_free()


func _on_lifetime_timeout() -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
