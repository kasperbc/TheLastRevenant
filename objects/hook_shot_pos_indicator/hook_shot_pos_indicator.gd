extends Sprite2D

@export var show : bool = false

func _physics_process(delta):
	if GameMan.get_player().get_hooks_fired_amount() >= PlayerMovement.MAX_HOOKS or not show:
		hide_self()
		return
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(GameMan.get_player().position, get_global_mouse_position())
	query.exclude = [GameMan.get_player()]
	var result = space_state.intersect_ray(query)
	
	if not result:
		hide_self()
		return
	
	if GameMan.get_player().position.distance_to(result.position) > HookMovement.MAX_DISTANCE:
		hide_self()
		return
	
	show_self()
	global_position = result.position

func hide_self():
	visible = false
	
func show_self():
	visible = true
