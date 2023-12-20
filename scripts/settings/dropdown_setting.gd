extends Setting
class_name DropdownSetting

var items : Array[String]

func _init(setting_name : String, setting_internal_name : String, setting_items : Array[String]):
	super(setting_name, setting_internal_name, 0)
	
	items = setting_items

func get_setting_type():
	return "Dropdown"

func create_ui_setter():
	var dropdown = OptionButton.new()
	dropdown.custom_minimum_size = Vector2(100,50)
	
	for i in items.size():
		print("added item %s" % items[i])
		dropdown.add_item(items[i], i)
	dropdown.selected = 0
	
	return dropdown
