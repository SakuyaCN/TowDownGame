extends Control

@onready var setting_ui = $SettingUI



func _on_start_pressed() -> void:
	$VBoxContainer.visible = false
	Utils.gameStart()

func _on_setting_pressed() -> void:
	setting_ui.visible = true


