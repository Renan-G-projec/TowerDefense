# Ad Maiorem Dei Gloriam!
class_name TowerBase
extends Node2D

var enemies: Array

var is_being_placed: bool = false
signal placed()
signal cancelled()

func is_on_valid_position() -> bool:
	return !$PlaceOnMap.has_overlapping_bodies() && !$PlaceOnMap.has_overlapping_areas()

func _on_enemy_detection_area_area_entered(area: Area2D) -> void:
	if !is_being_placed && !(area in enemies) && area.get_parent() is EnemyBase:
		enemies.append(area)

func _on_enemy_detection_area_area_exited(area: Area2D) -> void:
	if !is_being_placed && area in enemies && area.get_parent() is EnemyBase:
		enemies.erase(area)

func _process(delta: float) -> void:
	if is_being_placed:
		
		global_position = get_global_mouse_position()

		if !is_on_valid_position():
			modulate = Color(1.0, 0.231, 0.443, 0.502)
		else:
			modulate = Color(0.275, 1.0, 0.502, 0.502)
		
		if Input.is_action_just_pressed("place_tower") && is_on_valid_position():
			place()
		
		if Input.is_action_just_pressed("ui_cancel"):
			cancelled.emit()
			queue_free()

func place() -> void:
	is_being_placed = false
	modulate = Color.WHITE
	
	for enemy_area in $EnemyDetectionArea.get_overlapping_areas():
		if enemy_area.get_parent() is EnemyBase:
			enemies.append(enemy_area)
	
	placed.emit()
