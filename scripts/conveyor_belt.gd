extends Node2D

@onready var size : int = get_meta("size") * 16
@onready var speed : int = get_meta("speed")
@onready var wait_time : int = get_meta("wait_time")
@onready var claw = $Internal/Claw

var end_pos_l : Vector2
var end_pos_r : Vector2

@onready var moving_left = false if get_meta("start_from_left") else true
var moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Internal/Belt.region_rect.size = Vector2(size * 2, 6)
	$Internal/BeltEndL.position = Vector2(-size - 2, -1)
	$Internal/BeltEndR.position = Vector2(size + 2, -1)
	for c in get_child_count():
		if c == 0:
			continue
		get_child(c).reparent(claw)
	
	end_pos_l = claw.position - Vector2(size - 6, 0)
	end_pos_r = claw.position + Vector2(size - 6, 0)
	
	claw.position = end_pos_l if get_meta("start_from_left") else end_pos_r

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		move(delta)

func move(delta):
	var end_pos = end_pos_l if moving_left else end_pos_r
	
	claw.position = claw.position.move_toward(end_pos, speed * delta)
	if claw.position == end_pos:
		on_reach_end_pos()

func on_reach_end_pos():
	var particle = claw.get_node("StopParticle")
	particle.process_material.direction = Vector3(-1, -1, 0) if moving_left else Vector3(1, -1, 0)
	particle.restart()
	
	moving_left = !moving_left
	
	
	if wait_time <= 0:
		return
	
	moving = false
	
	await get_tree().create_timer(wait_time).timeout
	
	moving = true
