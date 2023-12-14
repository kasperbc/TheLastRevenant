extends Enemy

@export var phases : int
@export var invincibility_time : float = 30.0

var current_phase = 0
var invincible : bool = false

func die():
	current_phase += 1
	
	health = base_health
	
	if current_phase >= phases:
		GameMan.get_player().gravity_multiplier = 0.25
		super()
	else:
		activate_invincibility()
		$AI.on_phase_change(current_phase)

func activate_invincibility():
	invincible = true
	
	await get_tree().create_timer(invincibility_time).timeout
	
	invincible = false

func take_damage():
	if invincible:
		return
	super()

func _on_hook_attached():
	GameMan.get_player().hook_released_early.emit()
