extends HookableObject

func _process(delta):
	super(delta)

func _on_player_near():
	GameMan.get_player().hook_released_early.emit()
	open_vent()

func open_vent():
	$CollisionShape2D.disabled = true
	
	$UpperVent.rotation_degrees = 90
	$LowerVent.rotation_degrees = -90
