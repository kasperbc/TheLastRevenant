extends AnimatedSprite2D

var time_since_flash_started : float = 1.0

func _process(delta):
	time_since_flash_started += delta
	time_since_flash_started = clamp(time_since_flash_started, 0.5, 1)
	
	self_modulate.g = time_since_flash_started
	self_modulate.b = time_since_flash_started

func flash_red():
	time_since_flash_started = 0
