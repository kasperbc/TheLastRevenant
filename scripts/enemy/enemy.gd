extends HookableObject
class_name Enemy

@onready var health_pickup = preload("res://objects/pickups/pickup_health.tscn")

@export var manual_velocity : bool = false
@export_group("Damage")
@export var health : float = 1.0
@export var infinite_health = false
@export var death_particle : PackedScene
@export var stun_time : float = 1.0
@export var shake_on_stun : bool = true
@export var pooled : bool = false
@export var pool_identifier : String = ""
@export var insta_kill : bool = false
@export var death_sound = "thud2"
@export var death_sound_volume = -6.0
@export_group("Pickups")
@export var drop_health_pickups = true
@export var health_pickup_amount = 1
@export var health_pickup_chance = 1.0
@export var health_pickup_spread = Vector2(5.0, 5.0)
@export var health_pickup_offset = Vector2.ZERO
@export_group("Contact")
@export var contact_damage = true
@export var destroy_on_contact = false
@export var knockback = Vector2(200, -200)
@export_group("Boss")
@export var boss = false
@export var boss_music : String
@export var post_boss_music : String
@export var post_boss_music_volume : int
@export var boss_id : int

var stunned
@onready var base_health = health

signal died

func _ready():
	var bosses_defeated = SaveMan.get_value("bosses_defeated", [-1])
	if boss and bosses_defeated.has(boss_id):
		queue_free()

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
	if stunned:
		return
	
	GameMan.get_player().hook_released.emit()
	
	if not insta_kill:
		GameMan.get_player_health().damage()
	else:
		GameMan.get_player_health().die()
	
	knock_back_player(Vector2(knockback))

func knock_back_player(amount : Vector2):
	GameMan.get_player().velocity.x = (position.direction_to(GameMan.get_player().position) * amount.x).x
	GameMan.get_player().velocity.y = amount.y

func take_damage():
	if stunned:
		return
	
	
	
	if not infinite_health:
		var damage = 1
		if GameMan.get_upgrade_status(GameMan.Upgrades.GALVANIC_MODULE) == GameMan.UpgradeStatus.ENABLED:
			damage = 1.5
		
		if GameMan.get_upgrade_status(GameMan.Upgrades.AUTOCOUNTER) == GameMan.UpgradeStatus.ENABLED and not Input.is_action_just_pressed("hook_attack") and not GameMan.get_player().bomb_active:
			damage /= 2
		
		if GameMan.get_upgrade_status(GameMan.Upgrades.PANTHEONITE_AMPLIFIER) == GameMan.UpgradeStatus.ENABLED:
			if boss:
				damage *= 100
			else:
				damage *= 5
		
		health -= damage
	
	await get_tree().create_timer(0.06, true, false, true).timeout
	get_tree().paused = true
	await get_tree().create_timer(0.1, true, false, true).timeout
	get_tree().paused = false
	
	if health <= 0:
		die()
	else:
		stun()

func stun():
	stunned = true
	if hook_attached:
		GameMan.get_player().hook_released.emit()
	
	var _stun_time = stun_time
	if GameMan.get_upgrade_status(GameMan.Upgrades.GALVANIC_MODULE) == GameMan.UpgradeStatus.ENABLED:
		_stun_time *= 1.5
	
	if get_node_or_null("Shaker"):
		$Shaker.start_shake(self, 2.0, _stun_time)
	
	await get_tree().create_timer(_stun_time).timeout
	
	stunned = false

func die():
	died.emit()
	
	if death_particle:
		var part = death_particle.instantiate()
		get_parent().add_child(part)
		if part is Node2D:
			part.global_position = global_position
	
	if drop_health_pickups and health_pickup_chance >= randf():
		for x in health_pickup_amount:
			var pickup = health_pickup.instantiate()
			get_parent().call_deferred("add_child", pickup)
			pickup.global_position = global_position + health_pickup_offset
			pickup.global_position.x += randf_range(-health_pickup_spread.x, health_pickup_spread.x)
			pickup.global_position.y += randf_range(-health_pickup_spread.y, health_pickup_spread.y)
			pickup.base_pos = pickup.global_position
	
	if boss:
		if not boss_music == "":
			if boss_music == GameMan.get_audioman().current_song:
				GameMan.get_audioman().stop_music()
				if not post_boss_music == "":
					GameMan.get_audioman().fade_to_music(post_boss_music, 2, post_boss_music_volume)
		if boss_music == "":
			GameMan.get_audioman().stop_music()
			if not post_boss_music == "":
				GameMan.get_audioman().fade_to_music(post_boss_music, 2, post_boss_music_volume)
		
		var bosses_defeated = SaveMan.get_value("bosses_defeated", [-1])
		bosses_defeated.append(boss_id)
		SaveMan.save_value("bosses_defeated", bosses_defeated)
	
	if hook_attached:
		GameMan.get_player().hook_released_early.emit()
	
	if not death_sound == "":
		GameMan.get_audioman().play_fx(death_sound, death_sound_volume, randf_range(0.95, 1.05))
	
	if not pooled:
		queue_free()
	if pooled:
		PoolMan.return_to_pool(self, pool_identifier)

func _reset():
	pass
