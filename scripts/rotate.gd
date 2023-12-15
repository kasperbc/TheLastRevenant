extends Sprite2D
# ur welcome risto

func _process(delta):
	visible = get_parent().invincible
	
	rotate(deg_to_rad(90 * delta))
