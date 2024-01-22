extends Sprite2D

@export var show : bool = false

func _physics_process(delta):
	if not show:
		hide_self()
		return
	
	if GameMan.get_upgrade_status(GameMan.Upgrades.VISUALIZER) != GameMan.UpgradeStatus.ENABLED:
		hide_self()
		return
	
	var space_state = get_world_2d().direct_space_state
	
	var end_dir = GameMan.get_player().global_position.direction_to(get_global_mouse_position())
	if not GameMan.get_player().joy_aim_dir == Vector2.ZERO:
		end_dir = GameMan.get_player().joy_aim_dir
	
	var end_pos = GameMan.get_player().global_position + (end_dir * 1000)
	var query = PhysicsRayQueryParameters2D.create(GameMan.get_player().global_position, end_pos)
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
