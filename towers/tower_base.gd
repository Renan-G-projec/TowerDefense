# Ad Maiorem Dei Gloriam!
class_name TowerBase
extends Node2D

@export var bullet: PackedScene = preload("res://bullets/bullet.tscn")

var enemies: Array[EnemyBase]

var is_being_placed: bool = false
signal placed()
signal cancelled()

func is_on_valid_position() -> bool:
	return !$PlaceOnMap.has_overlapping_bodies() && !$PlaceOnMap.has_overlapping_areas()

func _on_enemy_detection_area_area_entered(area: Area2D) -> void:
	if !is_being_placed && !(area in enemies) && area is EnemyBase:
		enemies.append(area as EnemyBase)

func _on_enemy_detection_area_area_exited(area: Area2D) -> void:
	if !is_being_placed && area in enemies && area is EnemyBase:
		enemies.erase(area as EnemyBase)

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
	
	for enemy in $EnemyDetectionArea.get_overlapping_areas():
		if enemy is EnemyBase:
			enemies.append(enemy as EnemyBase)
	
	placed.emit()


var _tween: Tween

func _on_reload_timer_timeout() -> void:
	if !enemies.is_empty(): shoot()

func shoot() -> void:
	assert(!enemies.is_empty(), "Tried to shoot but enemies array is empty")
	
	if _tween:
		_tween.kill()
	_tween = create_tween().set_trans(Tween.TRANS_CIRC)
	
	$Base.scale = Vector2(1.1, 0.9)
	_tween.tween_property($Base, "scale", Vector2.ONE, 0.3)
	
	var bullet_instance := bullet.instantiate() as Bullet
	add_child(bullet_instance) # Can be a children of itself as the towers doesnt move
	
	var direction: Vector2 = (enemies[0].global_position - global_position).normalized()
	bullet_instance.direction = direction
