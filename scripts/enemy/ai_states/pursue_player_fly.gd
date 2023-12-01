extends EnemyAIState
class_name PursuePlayerFly

@export var speed : float = 50.0
@export var offset : Vector2 = Vector2.ZERO
@export var max_distance : float = 0.0

func ai_state_process(delta):
	move_towards_player(speed, offset, max_distance)
