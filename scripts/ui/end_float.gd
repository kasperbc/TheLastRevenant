extends AnimatedSprite2D


@onready var float_variation = randf()
@onready var root_pos = global_position

@export var speed = 0.33
@export var strength = 10


func _process(delta):
	global_position.y = root_pos.y + (sin(Time.get_unix_time_from_system() * speed) + float_variation) * strength
