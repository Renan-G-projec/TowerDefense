# Ad Maiorem Dei Gloriam!
class_name MapBase
extends Node2D

## TODO: Add all the round changing logic here

var enemy_scene = preload("res://enemies/enemy.tscn")
var bullet_scene = preload("res://bullets/bullet.tscn")

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
	var enemy = enemy_scene.instantiate()
	%EnemyLogicalPath.add_child(enemy)
	$Towers/TowerBasic.connect('shoot', create_bullet)
	
func create_bullet(pos: Vector2, angle: float, bullet_enum: Data.Bullet) -> void:
	var bullet = bullet_scene.instantiate()
	bullet.setup(pos, angle, bullet_enum)
	$Bullets.add_child(bullet)
