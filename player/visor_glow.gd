extends AnimatedSprite2D

@onready var player_sprite = get_parent()

func _process(delta):
	position.x = -3 if player_sprite.flip_h else 3
	flip_h = player_sprite.flip_h
