extends PointLight2D

var time : float
@onready var time_offset = randf_range(0, 1)
@onready var speed = randf_range(0.5,1)

func _process(delta):
	time += delta
	
	texture_scale = 1 - (sin((time + time_offset) * speed) * 0.05)
