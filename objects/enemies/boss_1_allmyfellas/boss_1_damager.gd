extends CharacterBody2D
class_name Boss1Damager

var falling : bool
var down_velocity : float = 0

@export var gravity = 500

func on_missile_hit():
	falling = true

func _process(delta):
	if falling:
		down_velocity += gravity * delta
	
	velocity.y = down_velocity
	
	if is_on_floor():
		damage_boss()
	
	move_and_slide()

func damage_boss():
	get_tree().get_first_node_in_group("Boss1").take_damage()
	
	queue_free()
