extends TowerBase

func _on_reload_timer_timeout() -> void:
	if enemies.is_empty():
		return
	
	var target_pos: Vector2 = enemies[0].global_position
	var angle := (target_pos - global_position).angle()
	shoot.emit(position, angle - PI/2, Data.Bullet.ARROW)
		
