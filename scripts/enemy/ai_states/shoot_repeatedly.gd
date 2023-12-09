extends EnemyAIState
class_name ShootRepeatedly

@export var wait_time : float = 1.0
@export var projectile_offset : Vector2

var time_since_last_shot = 0.0

func _on_state_activate():
	time_since_last_shot = 0.0

func ai_state_process(delta):
	time_since_last_shot += delta
	
	if time_since_last_shot > wait_time:
		time_since_last_shot = 0.0
		shoot_projectile(projectile_offset)

