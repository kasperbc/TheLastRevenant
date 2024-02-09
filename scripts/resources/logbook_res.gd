extends Resource
class_name LogbookRes

@export_multiline var text : String
@export var header : String

func _init(_text = "Logbook Text", _header = "Logbook Header"):
	text = _text
	header = _header
