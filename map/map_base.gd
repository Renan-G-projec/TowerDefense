# Ad Maiorem Dei Gloriam!
class_name MapBase
extends Node2D

## TODO: Add all the round changing logic here

var enemy_scene: PackedScene = preload("res://enemies/enemy_base.tscn")

@export var rounds: Array[RoundData]

@export var current_round: int = 0:
	set(val):
		current_round = clampi(val, 0, rounds.size() - 1)
		if current_round == val: return
		
		round_changed.emit(current_round)
		
signal round_changed(new_round: int)

@export var lifes: int = 100:
	set(val):
		if val == lifes: return
		lifes = max(0, val)
		
		if val < 0:
			game_over.emit()
			
		lifes_changed.emit(lifes)

signal lifes_changed(new_lifes: int)

var _number_of_entities: int = 0

signal win()
signal game_over()
signal earned_money(quantity: int)

func start_round() -> void:
	var current_round_data: RoundData = rounds[current_round]
	_number_of_entities = current_round_data.get_number_of_enemies()
	
	earned_money.emit(current_round_data.money_on_start)
	
	for enemy in current_round_data.enemies:
		print(enemy)
		for enemy_index in current_round_data.enemies.get(enemy, 0):

			var enemy_instance: EnemyBase = enemy.instantiate()
			%EnemyLogicalPath.add_child(enemy_instance)
			
			enemy_instance.died.connect(_on_enemy_died.bind(enemy_instance))
			
			await get_tree().create_timer(current_round_data.spawn_delay).timeout

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start_round") && _number_of_entities <= 0:
		start_round()

func _on_target_area_area_entered(area: Area2D) -> void:
	if "damage" in area:
		lifes -= area.damage
	else:
		lifes -= 1
	
	_number_of_entities -= 1
	if _number_of_entities <= 0:
		current_round += 1
		if current_round >= rounds.size() && lifes > 0:
			win.emit()
	
	area.queue_free()

func _on_enemy_died(enemy: EnemyBase) -> void:
	earned_money.emit(enemy.money_on_death)
	_number_of_entities -= 1
	if _number_of_entities <= 0:
		current_round += 1
		if current_round >= rounds.size() && lifes > 0:
			win.emit()
