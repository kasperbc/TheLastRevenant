extends HookableObject

@export var light_off : bool = false
@export var off_sprite : CompressedTexture2D
@export var broken_sprite : CompressedTexture2D
@export var turn_on_light_when_near : bool = false
@export var light_turn_on_range : float = 100.0

@onready var is_on = not light_off
var on_sprite : CompressedTexture2D

var broken = false

func _ready():
	on_sprite = $Sprite2D.texture
	
	if light_off:
		turn_off_light()

func _process(delta):
	if not is_on and turn_on_light_when_near and not broken:
		var distance_to_player = GameMan.get_player().global_position.distance_to(global_position)
		
		if distance_to_player < light_turn_on_range:
			play_turn_on_anim()

func play_turn_on_anim():
	GameMan.get_audioman().play_fx("thud", -12, randf_range(1.15, 1.2))
	is_on = true
	turn_on_light()
	
	for x in randi_range(0, 3):
		await get_tree().create_timer(randf_range(0.05, 0.5)).timeout
		
		turn_off_light()
		
		await get_tree().create_timer(randf_range(0.05, 0.2)).timeout
		
		turn_on_light()

func turn_on_light():
	$PointLight2D.visible = true
	$Sprite2D.texture = on_sprite

func turn_off_light():
	$PointLight2D.visible = false
	$Sprite2D.texture = off_sprite

func _on_player_attacked():
	if not broken:
		break_light()
	super()

func break_light():
	get_tree().paused = true
	
	await get_tree().create_timer(0.05).timeout
	
	get_tree().paused = false
	
	$Sprite2D.texture = broken_sprite
	GameMan.get_audioman().play_fx("thud", -12, randf_range(0.95, 1.05))
	GameMan.get_audioman().play_fx("shock", -12, randf_range(0.95, 1.05))
	$BreakParticles.emitting = true
	
	turn_off_light()
	set_collision_layer_value(7, 0)
	broken = true
	is_on = false
