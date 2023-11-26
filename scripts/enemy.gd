extends HookableObject

@onready var player = GameMan.get_player()

func _on_player_attached():
	player.hook_released.emit()
	damage_player()
	super()

func damage_player():
	player.velocity.x = (position.direction_to(player.position) * 200).x
	player.velocity.y = -200.0
