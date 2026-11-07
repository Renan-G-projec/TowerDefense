# Ad Maiorem Dei Gloriam!
class_name TowerBase
extends Node2D

var enemies: Array

func is_on_valid_position() -> bool:
	return !$PlaceOnMap.has_overlapping_bodies() && !$PlaceOnMap.has_overlapping_bodies()

func _on_enemy_detection_area_area_entered(area: Area2D) -> void:
	if area not in enemies && area.get_parent() is EnemyBase:
		enemies.append(area)

func _on_enemy_detection_area_area_exited(area: Area2D) -> void:
	if area in enemies && area.get_parent() is EnemyBase:
		enemies.erase(area)
