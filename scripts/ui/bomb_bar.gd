extends TextureProgressBar

func _process(delta):
	if not GameMan.get_upgrade_status(GameMan.Upgrades.THERMAL_MODULE) == GameMan.UpgradeStatus.ENABLED:
		visible = false
		return
	else:
		visible = true
		value = 1 - (GameMan.get_player().bomb_last_use_timestamp - Time.get_unix_time_from_system() + PlayerMovement.BOMB_COOLDOWN) / PlayerMovement.BOMB_COOLDOWN
