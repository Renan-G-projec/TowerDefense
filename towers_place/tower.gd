class_name Tower
extends Node2D

var enemies: Array

func _process(delta: float) -> void:
	print(enemies)
	
func _on_enemy_detection_area_area_entered(area: Area2D) -> void:
	if area not in enemies:
			enemies.append(area)
	pass # Replace with function body.


func _on_enemy_detection_area_area_shape_exited(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area in enemies:
		enemies.erase(area)
