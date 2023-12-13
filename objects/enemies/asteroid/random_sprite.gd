extends AnimatedSprite2D

func _ready():
	flip_h = randf() > 0.5
	flip_v = randf() > 0.5
	
	frame = randi_range(0,1)
