extends HookableObject

func _on_hook_attached():
	print("Hooked!")

func _on_hook_detached():
	print("Detached!")

func _on_player_attached():
	print("Player attached!")

func _on_player_detached():
	print("Player detached!")

func _on_player_near():
	print("Player near!")
