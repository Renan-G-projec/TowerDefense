# Ad Maiorem Dei Gloriam!
class_name EnemyBase
extends PathFollow2D

func _process(delta: float) -> void:
	progress = progress + (20 * delta)
	if progress_ratio >= 0.99:
		queue_free()
