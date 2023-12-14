extends Sprite2D

var changing_background = false

func _process(delta):
	position = get_viewport().get_camera_2d().get_screen_center_position()
	
	if changing_background:
		self_modulate.a -= delta
		
		if self_modulate.a <= 0:
			texture = $Background2.texture
			self_modulate.a = 1
			changing_background = false

func change_background(texture_to : CompressedTexture2D):
	if changing_background:
		return
	
	changing_background = true
	$Background2.texture = texture_to
