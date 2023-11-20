extends CharacterBody2D

const MOVE_SPEED = 400.0
const MAX_DISTANCE = 300.0

var move_dir
var shoot_position
var moving = false

signal spawned
signal collided(collision_pos)

func _on_spawned():
	move_dir = position.direction_to(get_global_mouse_position())
	shoot_position = position
	moving = true

func _on_collided(_collision_pos):
	moving = false

func _on_hook_released():
	queue_free()

# HOOK MOVEMENT

func _physics_process(delta):
	if not moving:
		return
	
	var collision = move_and_collide(move_dir * MOVE_SPEED * delta)
	
	var distance_traveled = position.distance_to(shoot_position)
	if distance_traveled >= MAX_DISTANCE:
		queue_free()
		return
	
	if not collision:
		return
	
	collided.emit(collision.get_position())
