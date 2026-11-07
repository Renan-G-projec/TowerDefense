# Ad Maiorem Dei Gloriam!
class_name Main
extends Node

var current_money: int = 0:
	set(val):
		current_money = val
		current_money_changed.emit(current_money)
signal current_money_changed(new_money: int)

@onready var map: MapBase = $MapBase

# to activate dev features such as add money
var _is_dev_build: bool = false

var _is_placing_tower: bool = false

func _ready() -> void:
	_is_dev_build = OS.has_feature("editor")
	
	# Connects all to the cards to the current money and the purchased signal
	for card in %TowerCardContainer.get_children():
		if card is TowerCard:
			card._update_price_color(current_money)
			current_money_changed.connect(card._update_price_color)
			card.purchased.connect(purchase)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_game()
	
	# Debug stuff
	if _is_dev_build:
		if Input.is_action_just_pressed("ui_up"):
			print("[DEBUG]: Added %d money" % 10)
			current_money += 10
		if Input.is_action_just_pressed("ui_down"):
			print("[DEBUG]: Deducted %d money" % 10)
			current_money -= 10

func pause_game() -> void:
	SceneManager.change_scene("res://menu.tscn", { "wait_time": 0.0 })

func purchase(tower: TowerData) -> void:
	if !tower.scene: return
	if _is_placing_tower: return
	if current_money < tower.price: return
	
	_enter_building_state()
	
	var tower_scene: TowerBase = tower.scene.instantiate()
	map.add_child(tower_scene)
	tower_scene.is_being_placed = true
	
	var on_tower_placed: Callable = func() -> void:
		_exit_building_state()
		current_money -= tower.price
	
	var on_tower_placing_cancelled: Callable = func() -> void:
		_enter_building_state()
	
	tower_scene.placed.connect(on_tower_placed)
	tower_scene.cancelled.connect(on_tower_placing_cancelled)
	return

var _building_animations_tween: Tween
func _reset_building_tween() -> void:
	if _building_animations_tween:
		_building_animations_tween.kill()
	_building_animations_tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)

func _enter_building_state() -> void:
	_reset_building_tween()
	_is_placing_tower = true
	_building_animations_tween.tween_property($GUI/MainUI/PanelContainer, "position", Vector2(8, -39), 0.1)
	_building_animations_tween.tween_property($GUI/MainUI/PanelContainer, "offset_transform_scale", Vector2.ONE * 0.9, 0.3)

func _exit_building_state() -> void:
	_reset_building_tween()
	_is_placing_tower = false
	_building_animations_tween.tween_property($GUI/MainUI/PanelContainer, "position", Vector2(8, 0), 0.1).set_ease(Tween.EASE_OUT)
	_building_animations_tween.tween_property($GUI/MainUI/PanelContainer, "offset_transform_scale", Vector2.ONE, 0.1)


func _on_map_base_game_over() -> void:
	print("GAME_OVER")
