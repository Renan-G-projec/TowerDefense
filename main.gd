# Ad Maiorem Dei Gloriam!
class_name Main
extends Node

var current_money: int = 0:
	set(val):
		current_money = val
		current_money_changed.emit(current_money)
signal current_money_changed(new_money: int)

# to activate dev features such as add money
var _is_dev_build: bool = false

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

func purchase(tower: TowerData) -> bool:
	if current_money < tower.price: return false
	current_money -= tower.price
	
	if _is_dev_build: print("[TO IMPLEMNENT] Purchased tower %s" % tower.name)
	
	return true
		
