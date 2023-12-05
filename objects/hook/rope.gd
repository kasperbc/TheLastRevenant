extends Sprite2D
class_name Rope

@export var sprites : Array[CompressedTexture2D]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_pos = GameMan.get_player().global_position
	var hook_pos = get_parent().global_position
	var distance = hook_pos.distance_to(player_pos)
	
	# size
	region_rect.size.x = distance

	# position
	global_position = hook_pos + hook_pos.direction_to(player_pos) * distance / 2

	# rotation
	rotation = Vector2.RIGHT.angle_to(hook_pos.direction_to(player_pos))
	
	# sprite
	if GameMan.get_upgrade_status(GameMan.Upgrades.THERMAL_MODULE) == GameMan.UpgradeStatus.ENABLED:
		texture = sprites[3]
	elif GameMan.get_upgrade_status(GameMan.Upgrades.GALVANIC_MODULE) == GameMan.UpgradeStatus.ENABLED:
		texture = sprites[2]
	elif GameMan.get_upgrade_status(GameMan.Upgrades.VELOCITY_MODULE) == GameMan.UpgradeStatus.ENABLED:
		texture = sprites[1]
	elif GameMan.get_upgrade_status(GameMan.Upgrades.HOOKSHOT) == GameMan.UpgradeStatus.ENABLED:
		texture = sprites[0]
