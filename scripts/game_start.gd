extends Node

func _ready():
	await get_tree().create_timer(6.5).timeout
	
	if not GameMan.get_player().current_state == PlayerMovement.MoveState.DEBUG:
		GameMan.get_player().current_state = PlayerMovement.MoveState.NORMAL
