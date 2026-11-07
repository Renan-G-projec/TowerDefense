# Ad Maiorem Dei Gloriam!
class_name MapBase
extends Node2D

## TODO: Add all the round changing logic here

var enemy_scene: PackedScene = preload("res://enemies/enemy.tscn")
var arrow_scene: PackedScene = preload("res://bullets/arrow.tscn")
var beam_scene: PackedScene = preload("res://bullets/beam.tscn")

@export var rounds: Array[RoundData]

@export var current_round: int = 0:
	set(val):
		current_round = clamp(val, 0, rounds.size)
		if current_round == val: return

		round_changed.emit(current_round)
		
signal round_changed(new_round: int)


func _ready() -> void:
	$TowerArcher.connect("shoot", create_arrow)
	$TowerMage.connect("shoot", create_beam)
	start_round()


func start_round() -> void:
	print("[TO IMPLEMENT] Started Round %d" % current_round)
	
	var enemy = enemy_scene.instantiate()
	%EnemyLogicalPath.add_child(enemy)


func create_arrow(pos: Vector2, angle: float, bullet_enum: Data.Bullet) -> void:
	var arrow = arrow_scene.instantiate()
	arrow.setup(pos, angle, bullet_enum)
	$Bullets.add_child(arrow)

func create_beam(pos: Vector2, angle: float, bullet_enum: Data.Bullet) -> void:
	var beam = beam_scene.instantiate()
	beam.setup(pos, angle, bullet_enum)
	$Bullets.add_child(beam)
