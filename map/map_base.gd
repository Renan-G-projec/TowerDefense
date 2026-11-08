# Ad Maiorem Dei Gloriam!
class_name MapBase
extends Node2D

## TODO: Add all the round changing logic here

@export var rounds: Array[RoundData]

@export var current_round: int = 0:
	set(val):
		if current_round == val: return
		current_round = max(0, val)
		
		round_changed.emit(current_round)

@export var lifes: int = 100:
	set(val):
		if val == lifes: return
		lifes = max(0, val)
		
		if val < 0:
			game_over.emit()
			
		lifes_changed.emit(lifes)

var _number_of_entities: int = 0
var _is_on_round: bool = false

signal round_finished()
signal round_started()
signal round_changed(new_round: int)
signal lifes_changed(new_lifes: int)
signal win()
signal game_over()
signal earned_money(quantity: int)

# Starts the current round, spawning the enemies periodically and connecting the signals of the enemies
func start_round() -> void:
	if _is_on_round: return
	
	var current_round_data: RoundData = rounds[current_round]
	_number_of_entities = current_round_data.get_number_of_enemies()
	_is_on_round = true
	
	round_started.emit()
	
	for enemy in current_round_data.enemies:
		for enemy_index in current_round_data.enemies.get(enemy, 0):
			spawn_enemy(enemy)
			await get_tree().create_timer(current_round_data.spawn_delay).timeout

func spawn_enemy(enemy: PackedScene) -> void:
	var enemy_instance: EnemyBase = enemy.instantiate()
	var enemy_path_follow := PathFollow2D.new()
	
	enemy_path_follow.rotates = false
	
	
	%EnemyLogicalPath.add_child(enemy_path_follow)
	enemy_path_follow.add_child(enemy_instance)
	
	enemy_instance.died.connect(_on_enemy_died.bind(enemy_instance))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start_round") && _number_of_entities <= 0:
		start_round()

func _on_target_area_area_entered(area: Area2D) -> void:
	if "damage" in area:
		lifes -= area.damage
	else:
		lifes -= 10
	
	_number_of_entities -= 1
	if _number_of_entities <= 0:
		_finish_round()
	
	area.queue_free()

func _on_enemy_died(enemy: EnemyBase) -> void:
	earned_money.emit(enemy.money_on_death)
	_number_of_entities -= 1
	if _number_of_entities <= 0:
		_finish_round()

func _finish_round() -> void:
	_is_on_round = false
	if lifes > 0:
		earned_money.emit(rounds[current_round].money_on_finish)
	
		current_round += 1
		
		round_finished.emit()
	
		if current_round >= rounds.size():
			win.emit()
