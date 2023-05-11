extends ColorRect

@onready var volume_slider = $VBoxContainer/VBoxContainer/Control2/volume
@onready var shake_slider = $VBoxContainer/VBoxContainer/Control/shake

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shake = ConfigUtils.getConfig("setting","shake")
	var volume = ConfigUtils.getConfig("setting","volume")
	if volume != null:
		volume_slider.value = volume
	if shake != null:
		shake_slider.value = shake

#语言旋转
func _on_language_item_selected(index: int) -> void:
	if index == 0:
		TranslationServer.set_locale("en")
	else:
		TranslationServer.set_locale("zh_CN")

func _on_shake_value_changed(value: float) -> void:
	Utils.shake = value
	ConfigUtils.setConfig("setting","shake",value)


func _on_volume_value_changed(value: float) -> void:
	if value == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),false)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),(value - 50) / 5)
	ConfigUtils.setConfig("setting","volume",value)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Utils.is_game_start && !visible:
			show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true
			set_process_unhandled_input(true)
		elif visible:
			hide()
			get_tree().paused = false
			if Utils.is_game_start:
				Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
			
	
