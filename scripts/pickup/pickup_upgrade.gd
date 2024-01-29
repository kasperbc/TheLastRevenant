extends Pickup
class_name PickupUpgrade

@export var upgrade : Upgrade
var in_upgrade_text = false

func _ready():
	if not GameMan.get_upgrade_status(upgrade.id) == GameMan.UpgradeStatus.LOCKED:
		destroy_self()

func pick_up():
	GameMan.unlock_upgrade(upgrade)
	
	show_upgrade_text()
	await get_tree().create_timer(3).timeout
	hide_upgrade_text()
	
	super()

func show_upgrade_text():
	GameMan.get_audioman().pause_music()
	GameMan.get_audioman().play_fx("core_item_obtained", -12.0)
	in_upgrade_text = true
	get_tree().paused = true
	get_tree().get_root().get_node("/root/Main/UI/Control/UpgradeText/Name").text = upgrade.name
	get_tree().get_root().get_node("/root/Main/UI/Control/UpgradeText/Description").text = upgrade.description
	get_tree().get_root().get_node("/root/Main/UI/Control/UpgradeText").visible = true
	
func hide_upgrade_text():
	if not in_upgrade_text:
		return
	
	GameMan.get_audioman().fade_unpause_music(2)
	
	in_upgrade_text = false
	get_tree().paused = false
	get_tree().get_root().get_node("/root/Main/UI/Control/UpgradeText").visible = false
