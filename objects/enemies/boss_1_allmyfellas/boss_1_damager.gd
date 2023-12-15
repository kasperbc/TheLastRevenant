extends CharacterBody2D
class_name Boss1Damager

var falling : bool
var fallen : bool
var down_velocity : float = 0

@export var gravity = 500

func on_missile_hit():
	falling = true
	GameMan.get_audioman().play_fx("thud2", -4, randf_range(0.95, 1.05))

func _process(delta):
	if falling:
		down_velocity += gravity * delta
	
	velocity.y = down_velocity
	
	if is_on_floor() and falling:
		damage_boss()
	
	move_and_slide()

func damage_boss():
	if fallen:
		return
	fallen = true
	
	GameMan.get_audioman().play_fx("big_explosion", -8, randf_range(0.95, 1.05))
	GameMan.get_audioman().play_fx("big_explosion2", -8, randf_range(0.95, 1.05))
	
	var boss = get_tree().get_first_node_in_group("Boss1")
	boss.take_damage()
	$FallParticle.emitting = true
	$Sprite2D.visible = false
	set_collision_layer_value(5, false)
