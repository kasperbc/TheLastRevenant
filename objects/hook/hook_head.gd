extends AnimatedSprite2D

@export var frames : Array[SpriteFrames]

func _process(delta):
	# sprite
	if GameMan.get_upgrade_status(GameMan.Upgrades.PANTHEONITE_AMPLIFIER) == GameMan.UpgradeStatus.ENABLED:
		sprite_frames = frames[4]
	elif GameMan.get_upgrade_status(GameMan.Upgrades.THERMAL_MODULE) == GameMan.UpgradeStatus.ENABLED:
		sprite_frames = frames[3]
	elif GameMan.get_upgrade_status(GameMan.Upgrades.GALVANIC_MODULE) == GameMan.UpgradeStatus.ENABLED:
		sprite_frames = frames[2]
	elif GameMan.get_upgrade_status(GameMan.Upgrades.VELOCITY_MODULE) == GameMan.UpgradeStatus.ENABLED:
		sprite_frames = frames[1]
	elif GameMan.get_upgrade_status(GameMan.Upgrades.HOOKSHOT) == GameMan.UpgradeStatus.ENABLED:
		sprite_frames = frames[0]
	
	var _frame = 0
	if get_parent().current_state == HookMovement.HookMoveState.STILL:
		_frame = 1
	if GameMan.get_player().bomb_active:
		_frame = 2
	
	frame = _frame
