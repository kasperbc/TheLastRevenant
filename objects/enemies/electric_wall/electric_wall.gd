extends Enemy
class_name ElectricWall

func _ready():
	$Sprite2D.scale.y = 1 / scale.y
	$Sprite2D.region_rect.size.y = 16 * scale.y

func _process(delta):
	super(delta)
	set_collision_layer_value(1, GameMan.get_upgrade_status(GameMan.Upgrades.GALVANIC_MODULE) != GameMan.UpgradeStatus.ENABLED)
	set_collision_mask_value(2, GameMan.get_upgrade_status(GameMan.Upgrades.GALVANIC_MODULE) != GameMan.UpgradeStatus.ENABLED)

func on_player_contact():
	if GameMan.get_upgrade_status(GameMan.Upgrades.GALVANIC_MODULE) == GameMan.UpgradeStatus.ENABLED:
		return
	
	GameMan.get_audioman().play_fx("shock", -8, randf_range(0.95, 1.05))
	damage_player()

func on_player_attacked():
	pass
