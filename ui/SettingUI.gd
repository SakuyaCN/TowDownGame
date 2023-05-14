extends ColorRect

@onready var volume_slider = $VBoxContainer/VBoxContainer/Control2/volume
@onready var shake_slider = $VBoxContainer/VBoxContainer/Control/shake
@onready var language_ui = $VBoxContainer/VBoxContainer/language
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var language = ConfigUtils.getConfig("setting","language")
	var shake = ConfigUtils.getConfig("setting","shake")
	var volume = ConfigUtils.getConfig("setting","volume")
	if volume != null:
		volume_slider.value = volume
	if shake != null:
		shake_slider.value = shake
	if language != null:
		language_ui.select(language)
		_on_language_item_selected(language)

#语言旋转
func _on_language_item_selected(index: int) -> void:
	if index == 0:
		TranslationServer.set_locale("en")
	else:
		TranslationServer.set_locale("zh_CN")
	ConfigUtils.setConfig("setting","language",index)

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

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") && !Utils.is_inv_show:
		if Utils.is_game_start && !visible:
			show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Utils.crosshairChange(false)
			get_tree().paused = true
		elif visible:
			hide()
			get_tree().paused = false
			if Utils.is_game_start:
				Utils.crosshairChange(true)
				Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
			
	
