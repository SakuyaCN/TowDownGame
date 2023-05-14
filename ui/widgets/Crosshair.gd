extends TextureRect


func _ready() -> void:
	set_process(false)
	Utils.onGameStart.connect(self.onGameStart)

func onGameStart():
	set_process(true)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _process(delta: float) -> void:
	global_position = get_global_mouse_position() - size  / 2
	
