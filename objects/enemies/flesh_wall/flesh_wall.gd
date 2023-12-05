extends Enemy

func _on_hook_attached():
	if not GameMan.get_upgrade_status(GameMan.Upgrades.THERMAL_MODULE) == GameMan.UpgradeStatus.ENABLED:
		GameMan.get_player().hook_released_early.emit()

func on_player_attacked():
	if not GameMan.get_upgrade_status(GameMan.Upgrades.THERMAL_MODULE) == GameMan.UpgradeStatus.ENABLED:
		return
	
	super()
