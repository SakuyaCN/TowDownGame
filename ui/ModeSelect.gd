extends Control

signal onModeChoose(mode)

func _on_button_pressed() -> void:
	emit_signal("onModeChoose",0)
	queue_free()


func _on_button_2_pressed() -> void:
	emit_signal("onModeChoose",1)
	queue_free()
