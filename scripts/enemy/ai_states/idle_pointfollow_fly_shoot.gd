extends IdlePointFollowFlyState
class_name IdlePointFollowFlyShoot

@export var projectile_wait_time : float = 0.5

var time_since_last_projectile = 0.0

func ai_state_process(delta):
	super(delta)
	time_since_last_projectile += delta
	
	if time_since_last_projectile > projectile_wait_time:
		time_since_last_projectile = 0
		shoot_projectile(Vector2.DOWN * 6.0)
