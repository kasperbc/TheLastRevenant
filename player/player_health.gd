extends Node

const BASE_MAX_HEALTH = 6

var _current_health
var current_health : 
	get:
		return _current_health
	set(value):
		_current_health = value
		get_tree().root.get_node("/root/Main/UI/Control/HealthSprite").frame = (current_health - 1) % 6
		get_tree().root.get_node("/root/Main/UI/Control/HealthSprite/HealthText").text = str(current_health)
		get_tree().root.get_node("/root/Main/UI/Control/HealthSprite/HealthText").label_settings.font_color = Color("49b2d3")
		if current_health == get_max_health():
			get_tree().root.get_node("/root/Main/UI/Control/HealthSprite/HealthText").label_settings.font_color = Color("82d8e9")
		if current_health == 0:
			get_tree().root.get_node("/root/Main/UI/Control/HealthSprite").animation = "dead"
			get_tree().root.get_node("/root/Main/UI/Control/HealthSprite").frame = 0
			get_tree().root.get_node("/root/Main/UI/Control/HealthSprite/HealthText").visible = false

var invincible = false


func _ready():
	current_health = get_max_health()

func _process(delta):
	pass

func damage():
	if invincible and GameMan.get_player().current_state != PlayerMovement.MoveState.DEBUG:
		return
	
	current_health -= 1
	
	if current_health <= 0:
		die()
		return
	
	get_parent().get_node("Sprite2D").self_modulate = Color(1,0.5,0.5,1)
	get_parent().get_node("Sprite2D").flash_red()
	
	GameMan.get_audioman().play_fx("playerhurt", 0.0, randf_range(0.95, 1.05))
	
	get_tree().paused = true
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	
	
	invincible = true
	await get_tree().create_timer(1).timeout
	invincible = false

func die():
	current_health = 0
	
	get_tree().paused = true
	
	get_tree().root.get_node("/root/Main/UI/Control/HealthSprite/Shaker").start_shake(get_node("/root/Main/UI/Control/HealthSprite"), 5.0, 3.0)
	
	GameMan.get_audioman().play_fx("player_die", 0.0, randf_range(0.95, 1.05))
	
	await get_tree().create_timer(0.5).timeout
	GameMan.get_player().get_node("DeathParticle").process_mode = Node.PROCESS_MODE_ALWAYS
	GameMan.get_player().get_node("DeathParticle").visible = true
	GameMan.get_audioman().play_fx("small_explosion", 0.0, randf_range(0.95, 1.05))
	
	await get_tree().create_timer(0.5).timeout
	GameMan.get_player().get_node("DeathParticle2").process_mode = Node.PROCESS_MODE_ALWAYS
	GameMan.get_player().get_node("DeathParticle2").visible = true
	GameMan.get_audioman().play_fx("small_explosion", 0.0, randf_range(0.95, 1.05))
	
	await get_tree().create_timer(0.5).timeout
	GameMan.get_player().get_node("DeathParticle3").process_mode = Node.PROCESS_MODE_ALWAYS
	GameMan.get_player().get_node("DeathParticle3").visible = true
	GameMan.get_audioman().play_fx("small_explosion", 0.0, randf_range(0.95, 1.05))
	
	await get_tree().create_timer(0.5).timeout
	get_tree().root.get_node("/root/Main/UI/Control/FadeScreen").fade_to_black(1)
	await get_tree().create_timer(1).timeout
	
	if get_tree():
		get_tree().paused = false
	
	GameMan.reload_scene()

func heal():
	current_health += 1
	
	if current_health > get_max_health():
		current_health = get_max_health()

func heal_full():
	current_health = get_max_health()

func get_max_health() -> int:
	return BASE_MAX_HEALTH + (GameMan.get_expansion_count(GameMan.ExpansionType.HEALTH) * 3)
