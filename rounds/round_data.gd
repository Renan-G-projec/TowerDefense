# Ad Maiorem Dei Gloriam!
class_name RoundData
extends Resource

@export var enemies: Dictionary[PackedScene, int]
@export var spawn_delay: float = 2 # Time between 2 enemies instantiation
@export var money_on_start: int = 50

func get_number_of_enemies() -> int:
	return enemies.values().reduce(func (accumulator, value) -> int: return accumulator + value)
