# Ad Maiorem Dei Gloriam!
class_name TowerBase
extends Node2D

var enemies: Array


func _on_enemy_detection_area_area_entered(area: Area2D) -> void:
	if area not in enemies:
			enemies.append(area)

func _on_enemy_detection_area_area_exited(area: Area2D) -> void:
	if area in enemies:
		enemies.erase(area)
