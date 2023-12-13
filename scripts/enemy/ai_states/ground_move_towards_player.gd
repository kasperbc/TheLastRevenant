extends GroundMove
class_name GroundMoveTowardsPlayer


func ai_state_process(delta):
	var player_dir = get_player_dir_x()
	dir = player_dir
	
	super(delta)

func get_player_dir_x():
	var player_dir = get_player_dir().x
	return clamp(player_dir * 100, -1,1)

func get_player_dir():
	return body.global_position.direction_to(GameMan.get_player().global_position)
