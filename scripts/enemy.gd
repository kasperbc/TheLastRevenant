extends HookableObject
class_name Enemy

@onready var player = GameMan.get_player()

@export var health : int

func _on_player_attached():
	player_attached()
	super()

func _on_player_attacked():
	player_attacked()
	super()

func player_attached():
	damage_player()

func player_attacked():
	die()

func damage_player():
	player.hook_released.emit()
	GameMan.get_player_health().damage()
	knock_back_player(Vector2(200, -200))

func knock_back_player(amount : Vector2):
	player.velocity.x = (position.direction_to(player.position) * amount.x).x
	player.velocity.y = amount.y

func die():
	player.hook_released_early.emit()
	queue_free()
