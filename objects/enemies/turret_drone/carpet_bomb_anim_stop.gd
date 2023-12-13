extends AnimationPlayer

func _process(delta):
	if get_parent().get_parent().stunned:
		speed_scale = 0
	else:
		speed_scale = 1
