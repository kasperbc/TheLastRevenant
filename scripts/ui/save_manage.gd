extends Panel


func _on_close_button_pressed():
	visible = false

func _on_save_manage_button_pressed():
	visible = true

func _on_import_save_pressed():
	$Panel/ImportDialog.popup()

func on_save_file_selected(path):
	SaveMan.import_save(path)


func _on_export_save_pressed():
	$Panel/ExportDialog.popup()

func on_save_file_exported(path):
	SaveMan.export_save(path)


func _on_delete_save_pressed():
	$Panel/DeleteConfirmationDialog.popup()

func _on_delete_confirmation_dialog_confirmed():
	SaveMan.remove_save()
