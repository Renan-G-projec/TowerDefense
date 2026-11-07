extends TowerBase

@export var bullet: PackedScene = preload("res://bullets/bullet.tscn")

func _process(delta: float) -> void:
	if enemies.size() > 0:
		$Turrent.look_at(enemies[0].global_position)
		$Turrent.rotation = $Turrent.rotation - PI/2 
		
		
func _on_reload_timer_timeout() -> void:
	if !enemies.is_empty(): shoot()

func shoot() -> void:
	var bullet_instance := bullet.instantiate() as Bullet
	add_child(bullet_instance) # Can be a children of itself as the towers doesnt move
	
	bullet_instance.setup($Turrent.rotation)
	
