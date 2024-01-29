extends Control

@export var area : LevelArea

signal show_log(log_text)

func _ready():
	$AreaIcon.texture = area.icon
	$Label.text = area.name
	
	if get_parent().get_parent() is AreaTab:
		show_log.connect(get_parent().get_parent().show_log)

func _process(delta):
	visible = GameMan.areas_discovered.has(area.id)

func _on_info_button_pressed():
	show_log.emit(area.description)
