extends TowerBase

func _process(delta: float) -> void:
	if enemies.size() > 0:
		$Turrent.look_at(enemies[0].global_position)
		$Turrent.rotation = $Turrent.rotation - PI/2 
		
		
func _on_reload_timer_timeout() -> void:
	shoot.emit(position, $Turrent.rotation, Data.Bullet.ARROW)
	pass # Replace with function body.
