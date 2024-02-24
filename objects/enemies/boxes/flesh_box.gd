extends Enemy
class_name DestroyableBox

@export var flesh = true

func take_damage():
	if GameMan.get_upgrade_status(GameMan.Upgrades.THERMAL_MODULE) != GameMan.UpgradeStatus.ENABLED and flesh:
		return
	super()
