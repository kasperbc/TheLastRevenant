extends Station
class_name RechargeStation

@export var station_id = 0

const RANGE = 16*10

var open = false

func _process(delta):
	if global_position.distance_to(GameMan.get_player().global_position) < RANGE and open == false:
		open = true
		$Sprite2D.play("open")
	elif global_position.distance_to(GameMan.get_player().global_position) > RANGE and open == true:
		open = false
		$Sprite2D.play("close")
	super(delta)

func on_station_activate():
	GameMan.get_player_health().heal_full()
	GameMan.set_latest_recharge_point(station_id)
	SaveMan.write_save()
	GameMan.get_audioman().play_fx("recharge", 0.0, 1.0)
	$Sprite2D.play("activate")
	
	get_tree().get_root().get_node("/root/Main/UI/Control/StationText").text = "Game saved"
	get_tree().get_root().get_node("/root/Main/UI/Control/StationText").visible = true
	
	await get_tree().create_timer(2).timeout
	
	get_tree().get_root().get_node("/root/Main/UI/Control/StationText").visible = false
