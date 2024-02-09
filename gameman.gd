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
	THERMAL_MODULE = 5,
	AUTOCOUNTER = 6
}

enum LevelAreas {
	DEFAULT = 0,
	REVENANT_LAB = 1,
	LIVING_QUARTERS = 2,
	HANGAR = 3,
	VENTILATION = 4,
	WASTE_MANAGEMENT = 5,
	DISTRIBUTION_RAILWAY = 6,
	OBSERVATION_DECK = 7,
	REACTOR = 8,
	WEAPONS = 9,
	ASTEROID_FIELD = 10
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

# var upgrades_collected : Array[Upgrade]
# var upgrades_enabled : Array[bool]

# var latest_recharge_station : int = -1
# var health_expansions_collected : Array[int]
# var speed_expansions_collected : Array[int]
# var range_expansions_collected : Array[int]

# var map_positions_unlocked : Array[Vector2i]
# var map_sources_partial_unlocked : Array[int]

# var bosses_defeated : Array[int]

# var areas_discovered : Array[LevelAreas]

var game_paused : bool
var map_open : bool
# @onready var game_start_timestamp : float = Time.get_unix_time_from_system()

var config : ConfigFile
var default_controls_config : Dictionary

var listening_to_input = false
signal input_listen_ended(event : InputEvent)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if get_tree().root.get_node_or_null("Main"):
		player = get_tree().get_first_node_in_group("Players")
		player_health = player.find_child("HealthMan")
	
	var control_file = FileAccess.open(SettingsMan.KEYBINDS_FILE_PATH, FileAccess.READ).get_as_text()
	var control_json = JSON.new()
	control_json.parse(control_file)
	default_controls_config = control_json.data

func _process(delta):
	if not game_paused and get_tree().current_scene && get_tree().current_scene.name == "Main":
		increment_playtime_count(delta)

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
	var station = SaveMan.get_value("current_station", -1)
	
	if station == -1:
		return
	
	var target_station
	
	var stations = get_tree().get_nodes_in_group("RechargeStations")
	for s in stations:
		if not s is RechargeStation:
			continue
		if s.station_id == station:
			target_station = s
			break
	
	if target_station:
		get_player().set_deferred("global_position", target_station.global_position)
		print("Player has been moved to station %s" % station)

func increment_playtime_count(value):
	var playtime = SaveMan.get_value("playtime", 0)
	playtime += value
	SaveMan.save_value("playtime", playtime)

func get_upgrade_status(value : Upgrades) -> UpgradeStatus:
	var upgrades_collected = SaveMan.get_value("upgrades_collected", [])
	var upgrades_enabled = SaveMan.get_value("upgrades_enabled", [])
	
	for i in upgrades_collected.size():
		if upgrades_collected[i].id == value:
			if upgrades_enabled[i]:
				return UpgradeStatus.ENABLED
			else:
				return UpgradeStatus.DISABLED
	
	return UpgradeStatus.LOCKED

func unlock_upgrade(value : Upgrade):
	var upgrades_collected = SaveMan.get_value("upgrades_collected", [])
	var upgrades_enabled = SaveMan.get_value("upgrades_enabled", [])
	
	if not upgrades_collected.has(value):
		upgrades_collected.append(value)
		upgrades_enabled.append(true)
	
	SaveMan.save_value("upgrades_collected", upgrades_collected)
	SaveMan.save_value("upgrades_enabled", upgrades_enabled)

func set_upgrade_enabled(upgrade : Upgrades, value):
	var upgrades_collected = SaveMan.get_value("upgrades_collected", [])
	var upgrades_enabled = SaveMan.get_value("upgrades_enabled", [])
	
	for i in upgrades_collected.size():
		if upgrades_collected[i].id == upgrade:
			upgrades_enabled[i] = value
	
	SaveMan.save_value("upgrades_enabled", upgrades_enabled)	

func set_latest_recharge_point(id : int):
	SaveMan.save_value("current_station", id)
	print("The latest recharge station has been set to %s!" % id)

func has_collected_expansion(type : ExpansionType, id : int) -> bool:
	if type == ExpansionType.HEALTH:
		var expansions = SaveMan.get_value("health_expansions", [-1])
		return expansions.has(id)
	elif type == ExpansionType.SPEED:
		var expansions = SaveMan.get_value("speed_expansions", [-1])
		return expansions.has(id)
	else:
		var expansions = SaveMan.get_value("range_expansions", [-1])
		return expansions.has(id)

func get_expansion_count(type : ExpansionType) -> int:
	if type == ExpansionType.HEALTH:
		var expansions = SaveMan.get_value("health_expansions", [-1])
		return expansions.size() - 1
	elif type == ExpansionType.SPEED:
		var expansions = SaveMan.get_value("speed_expansions", [-1])
		return expansions.size() - 1
	else:
		var expansions = SaveMan.get_value("range_expansions", [-1])
		return expansions.size() - 1

func collect_expansion(type: ExpansionType, id : int):
	if type == ExpansionType.HEALTH:
		var expansions = SaveMan.get_value("health_expansions", [-1])
		expansions.append(id)
		SaveMan.save_value("health_expansions", expansions)
	elif type == ExpansionType.SPEED:
		var expansions = SaveMan.get_value("speed_expansions", [-1])
		expansions.append(id)
		SaveMan.save_value("speed_expansions", expansions)
	else:
		var expansions = SaveMan.get_value("range_expansions", [-1])
		expansions.append(id)
		SaveMan.save_value("range_expansions", expansions)

func pause_game():
	if get_tree().paused:
		return
	
	game_paused = true
	get_tree().paused = true

func unpause_game():
	game_paused = false
	map_open = false
	get_tree().paused = false

func load_title_screen():
	get_tree().change_scene_to_file("res://title_screen.tscn")
	get_tree().paused = false
	game_paused = false

func load_main():
	get_tree().change_scene_to_file("res://main.tscn")

func load_end_screen():
	get_tree().change_scene_to_file("res://end_screen.tscn")

func get_audioman() -> AudioManager:
	return get_tree().root.get_node_or_null("/root/Main/AudioManager")

func get_user_setting(key):
	if config == null:
		config = ConfigFile.new()
		config.load(SettingsMan.SETTING_FILE_PATH)
	
	return config.get_value(SettingsMan.SETTING_USER_SECTION, key)

func get_keybind_setting(key):
	if config == null:
		config = ConfigFile.new()
		config.load(SettingsMan.SETTING_FILE_PATH)
	
	return config.get_value(SettingsMan.SETTING_KEYBIND_SECTION, key)

func on_setting_change(refresh_ui = false):
	config = ConfigFile.new()
	
	config.load(SettingsMan.SETTING_FILE_PATH)
	update_input_map()
	
	if not refresh_ui:
		return
	
	var settings_man = get_tree().get_first_node_in_group("SettingsMan")
	if settings_man:
		settings_man.refresh_settings_ui()

func update_input_map():
	var controls_data = config.get_section_keys(SettingsMan.SETTING_KEYBIND_SECTION)
	var control_method = get_user_setting("control_method")
	
	for action in InputMap.get_actions():
		if action.contains("debug"):
			continue
		
		if not controls_data.has(str(action)):
			continue
		
		var c_data = config.get_value(SettingsMan.SETTING_KEYBIND_SECTION, str(action))
		var m_data = c_data[control_method]
		
		InputMap.action_erase_events(action)
		
		var new_event
		
		var control_key = m_data["key"]
		var control_type = m_data["type"]
		if control_type == 0:
			new_event = InputEventKey.new()
			new_event.physical_keycode = control_key
		elif control_type == 1:
			new_event = InputEventMouseButton.new()
			new_event.button_index = control_key
		elif control_type == 2:
			new_event = InputEventJoypadButton.new()
			new_event.button_index = control_key
		elif control_type == 3:
			new_event = InputEventJoypadMotion.new()
			new_event.axis = control_key
			
			var invert = m_data["invert"]
			new_event.axis_value = -1.0 if invert else 1.0
		
		InputMap.action_add_event(action, new_event)

func listen_to_input(keybind_btn):
	await get_tree().create_timer(0.1).timeout
	
	listening_to_input = true
	input_listen_ended.connect(keybind_btn.on_listen_end)

func _unhandled_key_input(event):
	#if Input.is_action_just_pressed("pause_game"):
		#toggle_pause()
	if Input.is_action_just_pressed("debug_pause"):
		toggle_pause()
	elif Input.is_action_just_pressed("open_map"):
		toggle_map()

func toggle_map():
	if game_paused:
		unpause_game()
	else:
		map_open = true
		pause_game()

func toggle_pause():
	if game_paused:
		unpause_game()
	else:
		pause_game()

func _input(event):
	if not listening_to_input:
		return
	
	
	var event_type = -1
	if event is InputEventKey:
		event_type = 0
	elif event is InputEventMouseButton:
		event_type = 1
	elif event is InputEventJoypadButton:
		event_type = 2
	elif event is InputEventJoypadMotion:
		event_type = 3
	
	if event_type == -1:
		return
	
	var valid_types = default_controls_config[get_user_setting("control_method")]["valid_input_types"]
	var valid = false
	for t in valid_types:
		if event_type == t:
			valid = true
	
	if not valid:
		return
	
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) < 0.4:
			return
	
	input_listen_ended.emit(event)
	listening_to_input = false

func get_input_action_key_str(action : String) -> String:
	if not InputMap.has_action(action):
		return "[No action found]"
	
	var input_action = InputMap.action_get_events(action)[0]
	
	if input_action is InputEventKey:
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(input_action.physical_keycode)
		return OS.get_keycode_string(keycode)
	
	return input_action.as_text()

func discover_area(area : LevelArea):
	var areas_discovered = SaveMan.get_value("areas_discovered", [-1])
	
	if areas_discovered.has(area.id):
		return
	areas_discovered.append(area.id)
	SaveMan.save_value("areas_discovered", areas_discovered)
	
	get_tree().root.get_node("Main/UI/Control/NewAreaLabel").show_area_text(area)
