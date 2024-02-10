extends Control


func _ready():
	blink()
	
func blink(): # not 182
	visible = !visible
	await get_tree().create_timer(0.75).timeout
	blink()
