extends GPUParticles2D


func _process(delta):
	var hook : HookMovement = get_parent().get_node("Hook")
	
	emitting = false
	if GameMan.get_upgrade_status(GameMan.Upgrades.PANTHEONITE_AMPLIFIER) != GameMan.UpgradeStatus.ENABLED:
		return
	
	global_position = hook.global_position
	
	emitting = hook.visible
	
	if hook.current_state == HookMovement.HookMoveState.MOVING or hook.current_state == HookMovement.HookMoveState.RETURNING:
		amount_ratio = 1
	else:
		amount_ratio = 0.1
