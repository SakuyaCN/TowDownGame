extends "res://game/guns/BaseGun.gd"


func _process(delta):
	super._process(delta)
	if OS.get_name() == "Windows" && Input.is_action_pressed("shoot") and can_shoot:
		_shoot()
	elif OS.get_name() != "Windows" && player.look_dir != null and can_shoot:
		_shoot()

func _shoot():
	gun_tip.rotation = direction.angle()
	for i in 3:
		var b = bullet_scene.instantiate()
		b.setOnwer(player)
		b.knockback_speed = knockback_speed
		get_tree().root.add_child(b)
		b.position = gun_tip.global_position
		b.rotation = gun_tip.rotation + deg_to_rad(-15 + i * 15)
		fire(b)
	
	call_deferred("_shootAnim")
	can_shoot = false
	timer.start()

func _shootAnim():
	super._shootAnim()
	audio.play()
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "position", position, timer.wait_time).from(position + Vector2(-1, -1))
	tween.tween_property($Sprite2D, "scale", Vector2(1,1), timer.wait_time).from(Vector2(0.5, 1.1))

func _on_timer_timeout():
	can_shoot = true
