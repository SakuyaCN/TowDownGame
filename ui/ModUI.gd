extends ColorRect



func _on_button_3_pressed() -> void:
	queue_free()


func _on_button_pressed() -> void:
	$NinePatchRect/FileDialog.popup()
