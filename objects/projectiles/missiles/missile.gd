extends Enemy
class_name EnemyMissile

@export var damage_while_hooked : bool = false

func damage_player():
	if GameMan.get_player().current_state != PlayerMovement.MoveState.NORMAL and not damage_while_hooked:
		return
	super()

func _reset():
	$AI.reset_state()

func _borrow():
	$SmokeParticle.restart()

func on_wall() -> bool:
	var space = get_world_2d().direct_space_state
	
	var query = PhysicsPointQueryParameters2D.new()
	query.collision_mask = collision_mask
	query.position = global_position
	query.collide_with_areas = false
	var result = space.intersect_point(query)
	
	if result:
		return true
	return false

func get_wall_collider():
	var space = get_world_2d().direct_space_state
	
	var query = PhysicsPointQueryParameters2D.new()
	query.collision_mask = collision_mask
	query.position = global_position
	query.collide_with_areas = false
	var result = space.intersect_point(query)
	
	if result:
		return result[0].collider
	
	return null
