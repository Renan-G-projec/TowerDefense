# Ad Maiorem Dei Gloriam!
class_name Main
extends Node

# This just points to the main, nothing else
static var current_main: Main = null

func _ready() -> void:
	current_main = self

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_game()

func pause_game():
	SceneManager.change_scene("res://menu.tscn", { "wait_time": 0.0 })
