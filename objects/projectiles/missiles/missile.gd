extends Enemy
class_name EnemyMissile

@export var damage_while_hooked : bool = false

func damage_player():
	if GameMan.get_player().current_state != PlayerMovement.MoveState.NORMAL and not damage_while_hooked:
		return
	super()

func _reset():
	$AI.reset_state()

func _borrow():
	$SmokeParticle.restart()
