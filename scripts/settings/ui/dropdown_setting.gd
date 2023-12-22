extends Setting
class_name DropdownSetting

var items : Array[String]
var item_internal_names : Array[String]

func _init(setting_name : String, setting_internal_name : String, setting_items : Array[String], setting_item_internal_names : Array[String]):
	super(setting_name, setting_internal_name, setting_item_internal_names[0])
	
	items = setting_items
	item_internal_names = setting_item_internal_names

func get_setting_type():
	return "Dropdown"

func create_ui_setter():
	var dropdown = OptionButton.new()
	dropdown.custom_minimum_size = Vector2(100,50)
	
	for i in items.size():
		dropdown.add_item(items[i], i)
	
	var value = get_setting_value()
	value = item_internal_names.find(value)
	
	if not value == null:
		dropdown.selected = value
		dropdown.item_selected.connect(save_setting_value)
	else:
		dropdown.queue_free()
		return null
	
	return dropdown

func save_setting_value(value):
	value = item_internal_names[value]
	
	super(value)
