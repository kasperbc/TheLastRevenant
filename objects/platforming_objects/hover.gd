extends AnimatedSprite2D

@export var intensity = 1.0
@export var speed = 1.0
var time_alive : float = 0.0

func _process(delta):
	time_alive += delta
	
	position.y = sin(time_alive * speed) * intensity
