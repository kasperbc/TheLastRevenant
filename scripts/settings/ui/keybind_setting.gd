extends Setting
class_name KeybindSetting

var keycode_dict = {
	'0': 'None',
	'4194304': 'Special',
	'4194305': 'Escape',
	'4194306': 'Tab',
	'4194307': 'BackTab',
	'4194308': 'Backspace',
	'4194309': 'Enter',
	'4194310': 'KpEnter',
	'4194311': 'Insert',
	'4194312': 'Delete',
	'4194313': 'Pause',
	'4194314': 'Print',
	'4194315': 'SysReq',
	'4194316': 'Clear',
	'4194317': 'Home',
	'4194318': 'End',
	'4194319': 'Left',
	'4194320': 'Up',
	'4194321': 'Right',
	'4194322': 'Down',
	'4194323': 'PageUp',
	'4194324': 'PageDown',
	'4194325': 'Shift',
	'4194326': 'Ctrl',
	'4194327': 'Meta',
	'4194328': 'Alt',
	'4194329': 'CapsLock',
	'4194330': 'NumLock',
	'4194331': 'ScrollLock',
	'4194332': 'F1',
	'4194333': 'F2',
	'4194334': 'F3',
	'4194335': 'F4',
	'4194336': 'F5',
	'4194337': 'F6',
	'4194338': 'F7',
	'4194339': 'F8',
	'4194340': 'F9',
	'4194341': 'F10',
	'4194342': 'F11',
	'4194343': 'F12',
	'4194344': 'F13',
	'4194345': 'F14',
	'4194346': 'F15',
	'4194347': 'F16',
	'4194348': 'F17',
	'4194349': 'F18',
	'4194350': 'F19',
	'4194351': 'F20',
	'4194352': 'F21',
	'4194353': 'F22',
	'4194354': 'F23',
	'4194355': 'F24',
	'4194356': 'F25',
	'4194357': 'F26',
	'4194358': 'F27',
	'4194359': 'F28',
	'4194360': 'F29',
	'4194361': 'F30',
	'4194362': 'F31',
	'4194363': 'F32',
	'4194364': 'F33',
	'4194365': 'F34',
	'4194366': 'F35',
	'4194433': 'KpMultiply',
	'4194434': 'KpDivide',
	'4194435': 'KpSubtract',
	'4194436': 'KpPeriod',
	'4194437': 'KpAdd',
	'4194438': 'Kp0',
	'4194439': 'Kp1',
	'4194440': 'Kp2',
	'4194441': 'Kp3',
	'4194442': 'Kp4',
	'4194443': 'Kp5',
	'4194444': 'Kp6',
	'4194445': 'Kp7',
	'4194446': 'Kp8',
	'4194447': 'Kp9',
	'4194370': 'Menu',
	'4194371': 'Hyper',
	'4194373': 'Help',
	'4194376': 'Back',
	'4194377': 'Forward',
	'4194378': 'Stop',
	'4194379': 'Refresh',
	'4194380': 'VolumeDown',
	'4194381': 'VolumeMute',
	'4194382': 'VolumeUp',
	'4194388': 'MediaPlay',
	'4194389': 'MediaStop',
	'4194390': 'MediaPrevious',
	'4194391': 'MediaNext',
	'4194392': 'MediaRecord',
	'4194393': 'Homepage',
	'4194394': 'Favorites',
	'4194395': 'Search',
	'4194396': 'Standby',
	'4194397': 'OpenUrl',
	'4194398': 'LaunchMail',
	'4194399': 'LaunchMedia',
	'4194400': 'Launch0',
	'4194401': 'Launch1',
	'4194402': 'Launch2',
	'4194403': 'Launch3',
	'4194404': 'Launch4',
	'4194405': 'Launch5',
	'4194406': 'Launch6',
	'4194407': 'Launch7',
	'4194408': 'Launch8',
	'4194409': 'Launch9',
	'4194410': 'LaunchA',
	'4194411': 'LaunchB',
	'4194412': 'LaunchC',
	'4194413': 'LaunchD',
	'4194414': 'LaunchE',
	'4194415': 'LaunchF',
	'4194416': 'Globe',
	'4194417': 'Keyboard',
	'4194418': 'JisEisu',
	'4194419': 'JisKana',
	'8388607': 'Unknown',
	'32': 'Space',
	'33': 'Exclam',
	'34': 'Quotedbl',
	'35': 'Numbersign',
	'36': 'Dollar',
	'37': 'Percent',
	'38': 'Ampersand',
	'39': 'Apostrophe',
	'40': 'ParenLeft',
	'41': 'ParenRight',
	'42': 'Asterisk',
	'43': 'Plus',
	'44': 'Comma',
	'45': 'Minus',
	'46': 'Period',
	'47': 'Slash',
	'48': '0',
	'49': '1',
	'50': '2',
	'51': '3',
	'52': '4',
	'53': '5',
	'54': '6',
	'55': '7',
	'56': '8',
	'57': '9',
	'58': 'Colon',
	'59': 'Semicolon',
	'60': 'Less',
	'61': 'Equal',
	'62': 'Greater',
	'63': 'Question',
	'64': 'At',
	'65': 'A',
	'66': 'B',
	'67': 'C',
	'68': 'D',
	'69': 'E',
	'70': 'F',
	'71': 'G',
	'72': 'H',
	'73': 'I',
	'74': 'J',
	'75': 'K',
	'76': 'L',
	'77': 'M',
	'78': 'N',
	'79': 'O',
	'80': 'P',
	'81': 'Q',
	'82': 'R',
	'83': 'S',
	'84': 'T',
	'85': 'U',
	'86': 'V',
	'87': 'W',
	'88': 'X',
	'89': 'Y',
	'90': 'Z',
	'91': 'BracketLeft',
	'92': 'Backslash',
	'93': 'BracketRight',
	'94': 'Asciicircum',
	'95': 'Underscore',
	'96': 'QuoteLeft',
	'123': 'BraceLeft',
	'124': 'Bar',
	'125': 'BraceRight',
	'126': 'Asciitilde',
	'165': 'Yen',
	'167': 'Section'
}

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
		curr_value[GameMan.get_user_setting("control_method")]["key"] = value.keycode
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
	
	if key_dict["type"] == 0:
		return keycode_dict[str(key_dict["key"])]
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
