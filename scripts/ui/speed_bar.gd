extends TextureProgressBar

func _process(delta):
	if not GameMan.get_upgrade_status(GameMan.Upgrades.VELOCITY_MODULE) == GameMan.UpgradeStatus.ENABLED:
		visible = false
		return
	else:
		visible = true
		value = 1 - (GameMan.get_player().velocity.length() / 400)
