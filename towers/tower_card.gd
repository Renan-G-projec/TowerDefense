# Ad Maiorem Dei Gloriam!
@tool
class_name TowerCard
extends Button

@export var data: TowerData:
	set(val):
		if val == data: return
		data = val
		
		_sync_with_data(data)

func _sync_with_data(tower_data: TowerData = data) -> void:
	%Icon.texture = tower_data.icon
	%Name.text = tower_data.name
	%Price.text = str(tower_data.price)
