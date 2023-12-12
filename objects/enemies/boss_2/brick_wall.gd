extends StaticBody2D

func _on_boss_detector_area_entered(area):
	if area.get_parent().is_in_group("Boss2"):
		area.get_parent().die()
