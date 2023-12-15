extends PhysicsBody2D
class_name DestructiblePipe

func _ready():
	$Sprite2D.scale.y = 1 / scale.y
	$Sprite2D.region_rect.size.y = scale.y * 16

func _on_area_entered(area):
	if area.get_parent().is_in_group("Boss2"):
		area.get_parent().get_node("AI/go_in_direction").current_speed /= 2
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


