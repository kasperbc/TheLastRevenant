extends Enemy

func on_player_attacked():
	if not GameMan.get_upgrade_status(GameMan.Upgrades.THERMAL_MODULE) == GameMan.UpgradeStatus.ENABLED:
		return
	
	super()
