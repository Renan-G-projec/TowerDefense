class_name Bullet
extends Area2D

var direction: Vector2 = Vector2.RIGHT
@export var speed: float = 80
@export var damage: float = 15

func _process(delta: float) -> void:
	position += speed * delta * direction

func _on_area_entered(area: Area2D) -> void:
	var enemy: EnemyBase = area.get_parent() as EnemyBase
	if enemy:
		enemy.take_damage(damage)
		queue_free()


func _on_lifetime_timeout() -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
