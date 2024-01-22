extends Setting
class_name KeybindSetting

var action_name

func _init(setting_name : String, setting_internal_name : String, setting_action_name : String):
	action_name = setting_action_name
	
	var default_controls_file = FileAccess.get_file_as_string(SettingsMan.KEYBINDS_FILE_PATH)
	var json = JSON.new()
	json.parse(default_controls_file)
	
	var controls_data = json.data
	var control_dict = {}
	
	for method in controls_data:
		control_dict[method] = {}
		for action in controls_data[method]["actions"]:
			if action == "hook_aim":
				continue
			if not action == setting_action_name:
				continue
			
			var type = controls_data[method]["actions"][action]["type"]
			if type == 0 or type == 1 or type == 2:
				control_dict[method]["type"] = type
				control_dict[method]["key"] = controls_data[method]["actions"][action]["key"]
			elif type == 3:
				control_dict[method]["type"] = type
				control_dict[method]["key"] = controls_data[method]["actions"][action]["key"]
				control_dict[method]["invert"] = controls_data[method]["actions"][action]["invert"]
	
	super(setting_name, setting_internal_name, control_dict)

func get_setting_type():
	return "Keybind"

func create_ui_setter():
	var button = Button.new()
	button.custom_minimum_size = Vector2(150,0)
	
	var value = get_setting_value()
	
	if not value == null:
		button.text = get_button_text()
		button.pressed.connect(listen_to_input)
	else:
		button.queue_free()
		return null
	
	ui_setter = button
	return button

func get_setting_value():
	var s_file = ConfigFile.new()
	s_file.load(SettingsMan.SETTING_FILE_PATH)
	
	if s_file.has_section_key(SettingsMan.SETTING_KEYBIND_SECTION, internal_name):
		var dict = s_file.get_value(SettingsMan.SETTING_KEYBIND_SECTION, internal_name)
		return dict[GameMan.get_user_setting("control_method")]
	else:
		print("Setting %s not found!" % internal_name)
		return null

func save_setting_value(value):
	if value == null:
		return
	
	var curr_value = GameMan.get_keybind_setting(internal_name)
	
	if value is InputEventKey:
		curr_value[GameMan.get_user_setting("control_method")]["type"] = 0
		curr_value[GameMan.get_user_setting("control_method")]["key"] = value.physical_keycode
	elif value is InputEventMouseButton:
		curr_value[GameMan.get_user_setting("control_method")]["type"] = 1
		curr_value[GameMan.get_user_setting("control_method")]["key"] = value.button_index
	elif value is InputEventJoypadButton:
		curr_value[GameMan.get_user_setting("control_method")]["type"] = 2
		curr_value[GameMan.get_user_setting("control_method")]["key"] = value.button_index
	elif value is InputEventJoypadMotion:
		curr_value[GameMan.get_user_setting("control_method")]["type"] = 3
		curr_value[GameMan.get_user_setting("control_method")]["key"] = value.axis
		curr_value[GameMan.get_user_setting("control_method")]["invert"] = value.axis_value < 0
	
	value = curr_value
	
	var s_file = ConfigFile.new()
	GameMan.on_setting_change()
	
	var result = s_file.load(SettingsMan.SETTING_FILE_PATH)
	print("Changed setting %s (Result: %s, Value %s)" % [internal_name, result, value])
	if not result == OK:
		return
	
	s_file.set_value(SettingsMan.SETTING_KEYBIND_SECTION, internal_name, value)
	s_file.save(SettingsMan.SETTING_FILE_PATH)
	
	GameMan.on_setting_change()

func listen_to_input():
	if GameMan.listening_to_input:
		return
	
	ui_setter.disabled = true
	ui_setter.text = "Listening..."
	GameMan.listen_to_input(self)

func on_listen_end(event : InputEvent):
	ui_setter.disabled = false
	GameMan.input_listen_ended.disconnect(on_listen_end)
	save_setting_value(event)
	ui_setter.text = get_button_text()

func get_button_text() -> String:
	var key_dict = GameMan.get_keybind_setting(internal_name)[GameMan.get_user_setting("control_method")]
	
	if key_dict.is_empty():
		push_error("Key Dict is empty! Did you forget to assign a key in default_controls.json?")
	
	if key_dict["type"] == 0:
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(key_dict["key"])
		return OS.get_keycode_string(keycode)
	elif key_dict["type"] == 1:
		return "Mouse " + str(key_dict["key"])
	elif key_dict["type"] == 2:
		return "Joypad " + str(key_dict["key"])
	elif key_dict["type"] == 3:
		var text = "Joypad axis " + str(key_dict["key"])
		if key_dict["invert"]:
			text += " -"
		else:
			text += " +"
		
		return text
	return "Unknown"
