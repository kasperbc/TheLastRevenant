extends CPUParticles2D

func detach_particle():
	name = "OrphanMissile"
	
	var gp = get_parent().get_parent()
	get_parent().remove_child(self)
	gp.add_child(self)
	
	emitting = false
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3
	timer.timeout.connect(death_timer_timeout)
	timer.autostart = true

func death_timer_timeout():
	queue_free()
