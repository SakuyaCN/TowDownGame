extends "res://game/guns/BaseGun.gd"


func _process(delta):
	super._process(delta)
	if OS.get_name() == "Windows" && Input.is_action_pressed("shoot") and can_shoot:
		_shoot()
	elif OS.get_name() != "Windows" && player.look_dir != null and can_shoot:
		_shoot()
	queue_redraw()

func _draw():
	var point = $GunTip.position + Vector2($GunTip.global_position.distance_to(get_global_mouse_position()),0)
	draw_line($GunTip.position+Vector2(5,0),point-Vector2(5,0),Color.WHITE,1)

func _shoot():
	player.set_knockback(knockback_speed)
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - gun_tip.global_position).normalized()
	gun_tip.rotation = direction.angle()
	var b = bullet_scene.instantiate()
	b.setOnwer(player)
	get_tree().root.add_child(b)
	b.position = gun_tip.global_position
	b.rotation = gun_tip.rotation
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
	add_child(particles_pre.instantiate())

func _on_timer_timeout():
	can_shoot = true