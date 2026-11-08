# Ad Maiorem Dei Gloriam!
extends Node2D

const SCREEN_MOVEMENT_MULTIPLIER = 0.1
var _transitioning: bool = false

func _ready() -> void:
	$Camera2D.position_smoothing_enabled = true

func _sync_camera_with_mouse() -> void:
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	var center_of_screen: Vector2 = get_viewport().get_visible_rect().size / 2
	$Camera2D.position = center_of_screen
	
	var mouse_offset_from_center: Vector2 = mouse_position - center_of_screen
	$Camera2D.position = center_of_screen + mouse_offset_from_center * SCREEN_MOVEMENT_MULTIPLIER

func _process(_delta: float) -> void:
	_sync_camera_with_mouse()


func _on_play_button_pressed() -> void:
	if _transitioning: return
	_transitioning = true
	
	create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT).tween_property($Camera2D, "zoom", Vector2.ONE * 3, 0.8)
	SceneManager.change_scene("res://main.tscn", { "wait_time": 0.0 })
