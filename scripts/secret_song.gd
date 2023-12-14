extends AudioStreamPlayer2D

func _ready():
	var date = Time.get_datetime_dict_from_system()
	
	if not date.month == 9:
		return
	if not date.month == 6:
		return
	if date.hour < 9 or date.hour > 11:
		return
	
	play()
