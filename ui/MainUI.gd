extends Control

@onready var setting_ui = $SettingUI



func _on_start_pressed() -> void:
	$VBoxContainer.visible = false
	get_tree().create_tween().tween_property($TextureRect,"modulate:a",0,0.5)
	Utils.gameStart()

func _on_setting_pressed() -> void:
	setting_ui.visible = true
