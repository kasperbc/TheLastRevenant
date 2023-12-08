extends CPUParticles2D

func _process(delta):
	global_position = get_parent().global_position

	emitting = get_parent().process_mode != PROCESS_MODE_DISABLED
