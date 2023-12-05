extends Enemy

func _ready():
	$Sprite2D.scale.x = 1 / scale.x
	$Sprite2D.region_rect.size.x = 16 * scale.x

func _on_hook_attached():
	GameMan.get_player().hook_released_early.emit()

func on_player_contact():
	damage_player()

func on_player_attacked():
	pass
