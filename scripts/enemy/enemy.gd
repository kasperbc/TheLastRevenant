extends HookableObject
class_name Enemy

@onready var player = GameMan.get_player()

@export var health : int = 1
@export var death_particle : PackedScene
@export_group("Contact")
@export var contact_damage = true
@export var destroy_on_contact = false

signal died

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

# damage / health
func on_hook_attached():
	if GameMan.get_player_health().invincible:
		GameMan.get_player().hook_released_early.emit()

func on_player_contact():
	if contact_damage:
		damage_player()
	if destroy_on_contact:
		die()

func on_player_attacked():
	take_damage()

func damage_player():
	player.hook_released.emit()
	GameMan.get_player_health().damage()
	knock_back_player(Vector2(200, -200))

func knock_back_player(amount : Vector2):
	player.velocity.x = (position.direction_to(player.position) * amount.x).x
	player.velocity.y = amount.y

func take_damage():
	
	get_tree().paused = true
	# await get_tree().create_timer(0.05, true, false, true).timeout
	get_tree().paused = false
	
	
	health -= 1
	
	if health == 0:
		die()
		return
	else:
		knock_back_player(Vector2(200, -300))

func die():
	died.emit()
	
	if death_particle:
		var part = death_particle.instantiate()
		get_parent().add_child(part)
		if part is Node2D:
			part.global_position = global_position
	
	if hook_attached:
		player.hook_released_early.emit()
	queue_free()
