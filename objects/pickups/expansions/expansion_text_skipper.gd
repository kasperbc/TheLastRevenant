extends UpgradeTextSkipper

func try_skip_upgrade_text():
	if not get_parent().in_freeze:
		return
	
	get_parent().hide_expansion_text()
	get_parent().destroy_self()
	get_tree().get_root().get_node("/root/Main/UI/Control/ExpansionText").visible = false
