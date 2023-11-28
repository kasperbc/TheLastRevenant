extends HookableObject
class_name Enemy

@onready var player = GameMan.get_player()

@export var health : int

# hookable object functions
func _on_hook_attached():
	on_hook_attached()
	super()

func _on_player_attacked():
	on_player_attacked()
	super()

# enemy signals
func _on_contact_detection_body_entered(body : Node2D):
	if not body.is_in_group("Players"):
		return
	
	on_player_contact()

# enemy functions
func on_hook_attached():
	if GameMan.get_player_health().invincible:
		GameMan.get_player().hook_released_early.emit()

func on_player_contact():
	damage_player()

func on_player_attacked():
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
