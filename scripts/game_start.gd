extends Node

func _ready():	
	if not GameMan.latest_recharge_station == -1:
		return
	
	GameMan.get_player().current_state = PlayerMovement.MoveState.DISABLED
	
	await get_tree().create_timer(0.1).timeout
	GameMan.get_audioman().play_fx("download", -4, 0.95)
	
	await get_tree().create_timer(1).timeout
	
	GameMan.get_audioman().play_fx("download", -4, 0.95)
	
	await get_tree().create_timer(1.6).timeout
	
	GameMan.get_audioman().play_fx("download", -4, 1)
	
	await get_tree().create_timer(1.7).timeout
	
	GameMan.get_audioman().play_fx("thud2", -4, 1.05)
	
	await get_tree().create_timer(2.5).timeout
	
	GameMan.get_audioman().play_fx("boom", -4, randf_range(0.95, 1.05))
	
	if not GameMan.get_player().current_state == PlayerMovement.MoveState.DEBUG:
		GameMan.get_player().current_state = PlayerMovement.MoveState.NORMAL
