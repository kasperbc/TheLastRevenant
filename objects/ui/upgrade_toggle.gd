extends CheckButton

@export var upgrade : GameMan.Upgrades
@export var upgrade_res : Upgrade

func _ready():
	if not upgrade_res:
		return
	
	$UpgradeDescription.text = upgrade_res.description
	tooltip_text = upgrade_res.name

func _process(delta):
	var upgrade_locked = GameMan.get_upgrade_status(upgrade) == GameMan.UpgradeStatus.LOCKED
	visible = !upgrade_locked
	disabled = upgrade_locked
	
	if GameMan.get_upgrade_status(upgrade) == GameMan.UpgradeStatus.DISABLED:
		$UpgradeTexture.texture = upgrade_res.texture_wireframe
		$UpgradeTexture.modulate.a = 0.25
	else:
		$UpgradeTexture.texture = upgrade_res.texture
		$UpgradeTexture.modulate.a = 1


func _on_toggled(toggled_on):
	GameMan.set_upgrade_enabled(upgrade, toggled_on)
