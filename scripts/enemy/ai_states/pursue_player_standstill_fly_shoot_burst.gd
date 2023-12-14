extends PursuePlayerStandstillFlyShoot
class_name PursuePlayerStandstillFlyShootBurst

@export var burst_amount = 3
@export var time_between_burst_shot = 0.2

func shoot():
	super()
	
	if ai_controller.can_see_player():
		for i in burst_amount - 1:
			await get_tree().create_timer(time_between_burst_shot).timeout
			shoot_projectile_towards_player(Vector2.ZERO, 5.0)
