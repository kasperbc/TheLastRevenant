extends AnimatedSprite2D

@export var frames : Array[SpriteFrames]

func _process(delta):
	rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(global_position.direction_to(get_global_mouse_position())))
	
	if GameMan.get_upgrade_status(GameMan.Upgrades.THERMAL_MODULE) == GameMan.UpgradeStatus.ENABLED:
		sprite_frames = frames[3]
	elif GameMan.get_upgrade_status(GameMan.Upgrades.GALVANIC_MODULE) == GameMan.UpgradeStatus.ENABLED:
		sprite_frames = frames[2]
	elif GameMan.get_upgrade_status(GameMan.Upgrades.VELOCITY_MODULE) == GameMan.UpgradeStatus.ENABLED:
		sprite_frames = frames[1]
	elif GameMan.get_upgrade_status(GameMan.Upgrades.HOOKSHOT) == GameMan.UpgradeStatus.ENABLED:
		sprite_frames = frames[0]
