extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() == "Windows":
		$Control.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Control/Label.text = "FPS:%s" %Engine.get_frames_per_second()

func _on_virtual_joystick_2_on_touch(vector) -> void:
	Utils.player.setGunLookat(vector)
