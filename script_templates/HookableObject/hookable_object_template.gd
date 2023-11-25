extends HookableObject

func _process(delta):
	super(delta)

func _on_hook_attached():
	print("Hooked!")
	super()

func _on_hook_detached():
	print("Detached!")
	super()

func _on_player_attached():
	print("Player attached!")
	super()

func _on_player_detached():
	print("Player detached!")
	super()

func _on_player_near():
	print("Player near!")
	super()
