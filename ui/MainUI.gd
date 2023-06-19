extends Control

@onready var setting_ui = $SettingUI

const pre = preload("res://ui/ModeSelect.tscn")

func _ready() -> void:
	Utils.onGameStart.connect(self.onGameStart)

func _on_start_pressed() -> void:
	var ins = pre.instantiate()
	ins.onModeChoose.connect(self.onModeChoose)
	add_child(ins)

func onModeChoose(mode):
	if mode == 0:
		Utils.gameStart()
	else:
		SceneManager.change_scene("res://game/map/SnowWorld/SnowWorld.tscn",
		{ "pattern": "scribbles", "pattern_leave": "squares" }
		)

func onGameStart():
	$VBoxContainer.visible = false
	get_tree().create_tween().tween_property($TextureRect,"modulate:a",0,0.5)

func _on_setting_pressed() -> void:
	setting_ui.visible = true

func _on_mod_pressed() -> void:
	#Utils.showToast("WAIT_MORE")
	pass
