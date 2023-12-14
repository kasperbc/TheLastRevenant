extends GroundMove

func ai_state_process(delta):
	super(delta)
	body.get_node("Sprite2D").play("idle")
