extends Control

func _ready():
	visible = not OS.is_userfs_persistent()
