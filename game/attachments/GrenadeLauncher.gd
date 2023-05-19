extends "res://game/attachments/BaseAttachment.gd"

var can_shoot = true

const pre = preload("res://game/other/Grenade.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right") && can_shoot && gun != null && gun.is_use:
		can_shoot = false
		$Timer.start()
		openFire()

func _on_timer_timeout() -> void:
	can_shoot = true

func openFire():
	$AudioStreamPlayer2D.play()
	var ins = pre.instantiate()
	ins.global_position = gun.global_position
	get_tree().root.add_child(ins)
	ins.launch(get_global_mouse_position())
