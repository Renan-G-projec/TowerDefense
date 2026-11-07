extends Tower

func _process(delta: float) -> void:
	if enemies.size() > 0:
		$Turrent.look_at(enemies[0].global_position)
		$Turrent.rotation = $Turrent.rotatation - PI/2 
