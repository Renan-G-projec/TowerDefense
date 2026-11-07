extends TowerBase

@export var bullet: PackedScene = preload("res://bullets/bullet.tscn")		

var _tween: Tween

func _on_reload_timer_timeout() -> void:
	if !enemies.is_empty(): shoot()

func shoot() -> void:
	assert(!enemies.is_empty(), "Tried to shoot but enemies array is empty")
	
	if _tween:
		_tween.kill()
	_tween = create_tween().set_trans(Tween.TRANS_CIRC)
	
	$Base.scale = Vector2(1.1, 0.9)
	_tween.tween_property($Base, "scale", Vector2.ONE, 0.3)
	
	var bullet_instance := bullet.instantiate() as Bullet
	add_child(bullet_instance) # Can be a children of itself as the towers doesnt move
	
	var direction: Vector2 = (enemies[0].global_position - global_position).normalized()
	bullet_instance.direction = direction
	
