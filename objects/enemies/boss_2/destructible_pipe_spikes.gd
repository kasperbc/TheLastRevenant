extends Enemy
class_name DestructibleSpikes

func _ready():
	super()
	$Sprite2D.scale.y = 1 / scale.y
	$Sprite2D.region_rect.size.y = scale.y * 16

func _on_area_entered(area):
	if area.get_parent().is_in_group("Boss2"):
		destroy_self()

func destroy_self():
	var particles = $CPUParticles2D
	remove_child(particles)
	get_parent().add_child(particles)
	particles.global_position = global_position
	
	particles.scale = Vector2.ONE
	particles.amount = randi_range(2,4) * scale.y
	particles.emission_rect_extents = Vector2(5, scale.y * 8.0)
	particles.emitting = true
	queue_free()
