# Ad Maiorem Dei Gloriam!
@tool
class_name TowerCard
extends Button

@export var data: TowerData:
	set(val):
		if val == data: return
		data = val
		
		_sync_with_data(data)

signal purchased(tower: TowerData)

const ENOUGH_MONEY_COLOR = Color.LIME_GREEN
const NOT_ENOUGH_MONEY_COLOR = Color.RED

func _sync_with_data(tower_data: TowerData = data) -> void:
	%Icon.texture = tower_data.icon
	%Name.text = tower_data.name
	%Price.text = str(tower_data.price)

func _update_price_color(money: int) -> void:
	if money >= data.price:
		%Price.add_theme_color_override("font_color", ENOUGH_MONEY_COLOR)
		disabled = false
	else:
		%Price.add_theme_color_override("font_color", NOT_ENOUGH_MONEY_COLOR)
		disabled = true
		


func _on_pressed() -> void:
	purchased.emit(data)
