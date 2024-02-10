extends TextureRect
class_name TitleScroll

@export var speed = 10

func _process(delta):
	global_position += Vector2.UP * speed * delta
	if global_position.y < -1440.0:
		global_position.y += 1440.0
