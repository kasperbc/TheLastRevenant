extends EnemyMissile
class_name FatMissile

func on_hit_boss_damager(body : Node2D):
	if not body is Boss1Damager:
		return
	
	body.on_missile_hit()
	die()

func _reset():
	$AI.state = $AI.default_state
	$AI.reset_state()
