extends CanvasLayer

func _ready() -> void:
	if OS.get_name() == "Windows":
		$Control.hide()

func _process(delta: float) -> void:
	$Control/Label.text = "FPS:%s" %Engine.get_frames_per_second()

func _on_virtual_joystick_2_on_touch(vector) -> void:
	Utils.player.setGunLookat(vector)
