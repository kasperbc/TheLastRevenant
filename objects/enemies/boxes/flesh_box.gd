extends Enemy

func take_damage():
	if GameMan.get_upgrade_status(GameMan.Upgrades.THERMAL_MODULE) != GameMan.UpgradeStatus.ENABLED:
		return
	super()
