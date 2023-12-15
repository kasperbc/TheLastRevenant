extends HookableObject

func _ready():
	$Sprite2D.scale.y = 1 / scale.y
	$Sprite2D.region_rect.size.y = scale.y * 16

func _process(delta):
	super(delta)

func _on_player_attached():
	try_pass_player_through()

func _on_player_near():
	try_pass_player_through()

func try_pass_player_through():
	if not GameMan.get_upgrade_status(GameMan.Upgrades.VELOCITY_MODULE) == GameMan.UpgradeStatus.ENABLED:
		return
	
	GameMan.get_player().hook_released_early.emit()
	GameMan.get_player().velocity.x *= 1.05
	
	GameMan.get_audioman().play_fx("launch", -4, randf_range(0.95, 1.05))
	GameMan.get_audioman().play_fx("thud2", -6, randf_range(0.95, 1.05))
	
	temporarily_disable_collision()

func temporarily_disable_collision():
	set_collision_layer_value(1, false)
	
	await get_tree().create_timer(0.3).timeout
	
	set_collision_layer_value(1, true)
