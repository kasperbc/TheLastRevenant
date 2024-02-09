extends Control
class_name LogbookLog

@export var logbook_res : LogbookRes

signal show_log(header, logbook_text)

func _ready():
	$Label.text = logbook_res.header
	
	if get_parent().get_parent() is AreaTab:
		show_log.connect(get_parent().get_parent().show_log)

func _process(delta):
	var logbooks_collected = SaveMan.get_value("logbooks_collected", [-1])
	visible = logbooks_collected.has(logbook_res)

func _on_info_button_pressed():
	show_log.emit(logbook_res.header, logbook_res.text)
