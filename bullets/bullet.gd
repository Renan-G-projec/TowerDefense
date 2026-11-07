class_name Bullet
extends Area2D

var direction: Vector2
var speed := 40


func setup(angle: float) -> void:
	direction = Vector2.DOWN.rotated(angle)
	rotation = angle

func _process(delta: float) -> void:
	position = position + (speed * delta * direction)
