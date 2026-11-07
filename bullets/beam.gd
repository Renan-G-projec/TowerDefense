class_name Beam
extends Area2D

var direction: Vector2 = Vector2.RIGHT
@export var speed: float = 80
@export var damage: float = 15

@export_group("Slow Effect")
@export_range(0.0, 1.0) var slow_amount: float = 0.5
@export var slow_duration: float = 2.0
@export var slow_tint: Color = Color(0.6, 0.8, 1.0)


func setup(pos: Vector2, angle: float, bullet_enum) -> void:
	position = pos
	direction = Vector2.DOWN.rotated(angle)
	rotation = angle


func _process(delta: float) -> void:
	position += speed * delta * direction


func _on_area_entered(area: Area2D) -> void:
	var enemy: EnemyBase = area.get_parent() as EnemyBase
	if enemy:
		enemy.take_damage(damage)
		enemy.apply_slow(slow_amount, slow_duration, slow_tint)
		queue_free()


func _on_lifetime_timeout() -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	

	
