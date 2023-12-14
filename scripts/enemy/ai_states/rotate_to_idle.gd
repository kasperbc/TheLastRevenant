extends EnemyAIState

@onready var idle_angle = body.rotation

@export var rotate_speed : float = 2.0

func ai_state_process(delta):
	body.rotation = rotate_toward(body.rotation, idle_angle, rotate_speed * speed_multiplier * delta)
