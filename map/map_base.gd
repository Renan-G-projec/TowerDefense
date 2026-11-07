# Ad Maiorem Dei Gloriam!
class_name MapBase
extends Node2D

## TODO: Add all the round changing logic here
var enemy_scene = preload("res://enemies/enemy.tscn")
@export var rounds: Array[RoundData]

@export var current_round: int = 0:
	set(val):
		current_round = clamp(val, 0, rounds.size)
		if current_round == val: return

		round_changed.emit(current_round)
		
signal round_changed(new_round: int)

func start_round() -> void:
	print("[TO IMPLEMENT] Started Round %d" % current_round)
	
	## All the logic should be here
	## An enemy would be a pathfollow2d and should be instantiated on $EnemyLogicalPath? Idk, seems reasonable

func _ready() -> void:
	var path_follow = PathFollow2D.new()
	var enemy = enemy_scene.instantiate()
	enemy.setup(path_follow)
	path_follow.add_child(enemy)
	$EnemyLogicalPath.add_child(path_follow)
