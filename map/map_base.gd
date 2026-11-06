# Ad Maiorem Dei Gloriam!
class_name MapBase
extends Node2D

## TODO: Add all the round changing logic here

var current_round: int = 0:
	set(val):
		if current_round == val: return
		
		current_round = val
		round_changed.emit(current_round)
signal round_changed(new_round: int)

func start_round() -> void:
	print("[TO IMPLEMENT] Started Round %d" % current_round)
	
	## All the logic should be here
	## An enemy would be a pathfollow2d and should be instantiated on $EnemyLogicalPath? Idk, seems reasonable
