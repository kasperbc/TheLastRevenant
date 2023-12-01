extends Pickup
class_name PickupUpgrade

@export var upgrade : Upgrade

func pick_up():
	GameMan.unlock_upgrade(upgrade)
	
	get_tree().paused = true
	get_tree().get_root().get_node("/root/Main/UI/Control/UpgradeText/Name").text = upgrade.name.capitalize()
	get_tree().get_root().get_node("/root/Main/UI/Control/UpgradeText/Description").text = upgrade.description.capitalize()
	get_tree().get_root().get_node("/root/Main/UI/Control/UpgradeText").visible = true
	await get_tree().create_timer(3).timeout
	get_tree().paused = false
	get_tree().get_root().get_node("/root/Main/UI/Control/UpgradeText").visible = false
	
	super()
