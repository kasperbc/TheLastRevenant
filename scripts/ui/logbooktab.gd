extends Control
class_name LogbookTab


func on_show_log(header, logbook_text):
	$LogbookPanel/LogbookHeader.text = header
	$LogbookPanel/LogbookText.text = logbook_text
	
	$LogbookPanel.visible = true


func _on_close_button_pressed():
	$LogbookPanel.visible = false
