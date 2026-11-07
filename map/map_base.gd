# Ad Maiorem Dei Gloriam!
class_name MapBase
extends Node2D

## TODO: Add all the round changing logic here

var enemy_scene: PackedScene = preload("res://enemies/enemy.tscn")

@export var rounds: Array[RoundData]

@export var current_round: int = 0:
	set(val):
		if val >= rounds.size():
			win.emit()
		
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

signal win()
signal game_over()

func start_round() -> void:
	var enemy = enemy_scene.instantiate()
	%EnemyLogicalPath.add_child(enemy)

func _ready() -> void:
	start_round()

func _on_target_area_area_entered(area: Area2D) -> void:
	if "damage" in area:
		lifes -= area.damage
	else:
		lifes -= 1
	
	area.queue_free()
