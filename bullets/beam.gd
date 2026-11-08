class_name Beam
extends Bullet

@export_group("Slow Effect")
@export_range(0.0, 1.0) var slow_amount: float = 0.5
@export var slow_duration: float = 2.0
@export var slow_tint: Color = Color(0.6, 0.8, 1.0)

func _init() -> void:
	speed = 250
	damage = 6

func _ready() -> void:
	var tween: Tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	$AnimatedSprite2D.scale = Vector2(1.4, 0.6)
	tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.3)

func _process(delta: float) -> void:
	position += speed * delta * direction

func _on_area_entered(area: Area2D) -> void:
	var enemy: EnemyBase = area as EnemyBase
	if enemy:
		enemy.take_damage(damage)
		enemy.apply_slow(slow_amount, slow_duration, slow_tint)
		queue_free()

func _on_lifetime_timeout() -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()	
