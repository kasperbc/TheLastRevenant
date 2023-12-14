extends Node

func _ready():	
	if not GameMan.latest_recharge_station == -1:
		return
	
	GameMan.get_player().current_state = PlayerMovement.MoveState.DISABLED
	
	await get_tree().create_timer(6.5).timeout
	
	
	if not GameMan.get_player().current_state == PlayerMovement.MoveState.DEBUG:
		GameMan.get_player().current_state = PlayerMovement.MoveState.NORMAL
