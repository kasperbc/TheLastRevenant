extends PursuePlayerStandstillFly
class_name PursuePlayerStandstillFlyShoot

@export var time_before_first_shot : float = 0.75
@export var shoot_rate : float = 1.0
var time_since_last_shot : float = 0.0

func _on_state_activate():
	super()
	time_since_last_shot = shoot_rate - time_before_first_shot

func ai_state_process(delta):
	super(delta)
	
	time_since_last_shot += delta
	if time_since_last_shot > shoot_rate:
		time_since_last_shot = 0
		shoot()

func shoot():
	if body.hook_attached:
		return
	
	if ai_controller.can_see_player():
		shoot_projectile_towards_player(Vector2.ZERO, 5.0)

#func shoot_projectile(offset):
	#super(offset)
	#
	#if is_instance_valid(last_projectile):
		#if last_projectile.get_node_or_null("AI/fly_towards_point"):
			#var player_dir = body.global_position.direction_to(GameMan.get_player().global_position)
			#last_projectile.get_node("AI/fly_towards_point").set_dir(Vector2.RIGHT.angle_to(player_dir))
			#last_projectile.damage_while_hooked = true
