extends Sprite2D

var changing_background = false

const BG_SCALE = 0.3725

func _ready():
	$Background2.region_enabled = true
	$Background2.region_rect.size = region_rect.size

func _process(delta):
	global_position = get_parallax_position()
	$Background2.global_position = get_parallax_position()
	
	if changing_background:
		self_modulate.a -= delta
		
		if self_modulate.a <= 0:
			texture = $Background2.texture
			
			scale.x = BG_SCALE / (texture.get_size().x / 1280)
			scale.y = BG_SCALE / (texture.get_size().y / 720)
			
			self_modulate.a = 1
			changing_background = false

func change_background(texture_to : CompressedTexture2D):	
	changing_background = true
	self_modulate.a = 1
	
	$Background2.texture = texture_to
	
	$Background2.scale.x = BG_SCALE / (texture_to.get_size().x / 1280)
	$Background2.scale.y = BG_SCALE / (texture_to.get_size().y / 720)
	

func get_parallax_position() -> Vector2:
	return get_viewport().get_camera_2d().get_screen_center_position() / 1.5
	#
	#var bg_offset = base_pos - get_viewport().get_camera_2d().get_screen_center_position()
	#var bg_steps = ceil(bg_offset.x / HORIZONTAL_STEP)
	#
	#print(bg_offset)
	#
	#var result = base_pos
	#result.x -= HORIZONTAL_STEP * 2 * bg_steps
#
	#return result
