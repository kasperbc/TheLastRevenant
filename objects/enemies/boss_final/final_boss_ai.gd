extends EnemyAI

func on_phase_change(phase : int):
	print("Phase %s" % phase)
	
	for x in get_tree().get_nodes_in_group("FinalBossPhases"):
		if x.phase_id == phase:
			x.process_mode = Node.PROCESS_MODE_INHERIT
			x.visible = true
		elif x.phase_id < phase:
			x.queue_free()
	
	if body.get_node_or_null("FinalBossCannon/AI/rotate_at_player_shoot"):
		body.get_node("FinalBossCannon/AI/rotate_at_player_shoot").speed_multiplier = 1 + (0.15 * phase)
