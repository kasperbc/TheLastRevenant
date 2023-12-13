extends Node

class_name GameManager

var player : Node
var player_health : Node


enum Upgrades {
	DEFAULT = 0,
	HOOKSHOT = 1,
	VISUALIZER = 2,
	VELOCITY_MODULE = 3,
	GALVANIC_MODULE = 4,
	THERMAL_MODULE = 5
}

enum UpgradeStatus {
	LOCKED = 0, # not unlocked
	ENABLED = 1, # unlocked & enabled
	DISABLED = 2 # unlocked & not enabled
}

enum ExpansionType {
	HEALTH = 0,
	SPEED = 1,
	RANGE = 2
}

var upgrades_collected : Array[Upgrade]
var upgrades_enabled : Array[bool]

var latest_recharge_station : int = -1
var health_expansions_collected : Array[int]
var speed_expansions_collected : Array[int]
var range_expansions_collected : Array[int]

var map_positions_unlocked : Array[Vector2i]
var map_sources_partial_unlocked : Array[int]

var bosses_defeated : Array[int]

var game_paused : bool
@onready var game_start_timestamp : float = Time.get_unix_time_from_system()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if get_tree().root.get_node_or_null("Main"):
		player = get_tree().get_first_node_in_group("Players")
		player_health = player.find_child("HealthMan")

func _process(delta):
	if Input.is_action_just_pressed("pause_game"):
		if game_paused:
			unpause_game()
		else:
			pause_game()

func get_player() -> PlayerMovement:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Players")
	
	return player

func get_player_health() -> Node:
	if not is_instance_valid(player_health):
		player_health = get_player().find_child("HealthMan")
	
	return player_health

func reload_scene():
	get_tree().reload_current_scene()
	PoolMan.reset_pools()

func move_player_to_latest_recharge_station():
	if latest_recharge_station == -1:
		return
	
	var target_station
	
	var stations = get_tree().get_nodes_in_group("RechargeStations")
	for s in stations:
		if not s is RechargeStation:
			continue
		if s.station_id == latest_recharge_station:
			target_station = s
			break
	
	if target_station:
		get_player().global_position = target_station.global_position
		print("Player has been moved to station %s" % latest_recharge_station)

func get_upgrade_status(value : Upgrades) -> UpgradeStatus:
	for i in upgrades_collected.size():
		if upgrades_collected[i].id == value:
			if upgrades_enabled[i]:
				return UpgradeStatus.ENABLED
			else:
				return UpgradeStatus.DISABLED
	
	return UpgradeStatus.LOCKED

func unlock_upgrade(value : Upgrade):
	if not upgrades_collected.has(value):
		upgrades_collected.append(value)
		upgrades_enabled.append(true)

func set_upgrade_enabled(upgrade : Upgrades, value):
	for i in upgrades_collected.size():
		if upgrades_collected[i].id == upgrade:
			upgrades_enabled[i] = value

func set_latest_recharge_point(id : int):
	latest_recharge_station = id
	print("The latest recharge station has been set to %s!" % id)

func has_collected_expansion(type : ExpansionType, id : int) -> bool:
	if type == ExpansionType.HEALTH:
		return health_expansions_collected.has(id)
	elif type == ExpansionType.SPEED:
		return speed_expansions_collected.has(id)
	else:
		return range_expansions_collected.has(id)

func get_expansion_count(type : ExpansionType) -> int:
	if type == ExpansionType.HEALTH:
		return health_expansions_collected.size()
	elif type == ExpansionType.SPEED:
		return speed_expansions_collected.size()
	else:
		return range_expansions_collected.size()

func collect_expansion(type: ExpansionType, id : int):
	if type == ExpansionType.HEALTH:
		health_expansions_collected.append(id)
	elif type == ExpansionType.SPEED:
		speed_expansions_collected.append(id)
	else:
		range_expansions_collected.append(id)

func pause_game():
	if get_tree().paused:
		return
	
	game_paused = true
	get_tree().paused = true

func unpause_game():
	game_paused = false
	get_tree().paused = false

func load_title_screen():
	get_tree().change_scene_to_file("res://title_screen.tscn")
	game_paused = false
	upgrades_collected.clear()
	upgrades_enabled.clear()
	health_expansions_collected.clear()
	speed_expansions_collected.clear()
	range_expansions_collected.clear()
	map_positions_unlocked.clear()
	map_sources_partial_unlocked.clear()
	bosses_defeated.clear()

func load_main():
	get_tree().change_scene_to_file("res://main.tscn")
	game_start_timestamp = Time.get_unix_time_from_system()

func load_end_screen():
	get_tree().change_scene_to_file("res://end_screen.tscn")
