extends Enemy

func damage_player():
	if GameMan.get_player().current_state != PlayerMovement.MoveState.NORMAL:
		return
	super()
