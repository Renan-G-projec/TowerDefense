# Ad Maiorem Dei Gloriam!
@tool
extends AnimatedSprite2D

func _ready() -> void:
	frame = range(sprite_frames.get_frame_count("default") - 1).pick_random()
	for child in range(get_child_count()):
		if child != frame:
			get_child(child).visible = false
		else:
			get_child(child).visible = true
