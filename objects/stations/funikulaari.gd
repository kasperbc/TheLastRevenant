extends CharacterBody2D

var going : bool = false
var moving : bool = false

@export var dir = 1
@export var warp_pos : Vector2

const ACCELERATION = 500.0
const TOP_SPEED = 1500.0

var current_speed : float = 0.0
var start_pos : Vector2

func _ready():
	start_pos = global_position
	$AnimatedSprite2D/WheelSprite.play("default")

func _process(delta):
	$AnimatedSprite2D/WheelSprite.speed_scale = velocity.x / (TOP_SPEED / 15)
	
	if not moving:
		return
	
	current_speed += ACCELERATION * delta
	current_speed = clamp(current_speed, 0, TOP_SPEED)
	
	
	velocity.x = current_speed * dir
	move_and_slide()

func _on_player_detection_body_entered(body):
	if not body.is_in_group("Players"):
		return
	
	go()

func go():
	if going:
		return
	
	GameMan.get_audioman().play_fx("thud2", -4, 1.0)
	GameMan.get_audioman().stop_music()
	going = true
	
	current_speed = 0.0
	
	$Door.set_deferred("disabled", false)
	$Ceiling.set_deferred("disabled", false)
	$AnimatedSprite2D.frame = 1
	
	await get_tree().create_timer(1).timeout
	
	GameMan.get_audioman().play_fx("accelerate", -4, 1.0)
	moving = true
	
	await get_tree().create_timer(3).timeout
	
	get_tree().root.get_node("Main/UI/Control/FadeScreen").fade_to_black(1)
	
	await get_tree().create_timer(1).timeout
	
	GameMan.get_player().set_deferred("global_position", warp_pos)
	
	await get_tree().create_timer(1).timeout
	
	get_tree().root.get_node("Main/UI/Control/FadeScreen").fade_to_transparent(1)
	
	$Door.set_deferred("disabled", true)
	$Ceiling.set_deferred("disabled", false)
	$AnimatedSprite2D.frame = 0
	
	going = false
	moving = false
	global_position = start_pos
