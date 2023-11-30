extends EnemyAIState
class_name PursuePlayer

@export var speed : float = 50.0

func ai_state_process(delta):
	move_towards_player(speed)
