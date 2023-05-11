extends CanvasLayer

func _ready() -> void:
	pass

func _on_virtual_joystick_2_on_touch(vector) -> void:
	Utils.player.setGunLookat(vector)
