extends "res://game/guns/BaseGun.gd"


func _process(delta):
	super._process(delta)
	queue_redraw()

func _draw():
	var point = $GunTip.position + Vector2($GunTip.global_position.distance_to(get_global_mouse_position()),0)
	draw_line($GunTip.position+Vector2(5,0),point-Vector2(5,0),Color.WHITE,1)

func _shoot():
	super._shoot()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - gun_tip.global_position).normalized()
	gun_tip.rotation = direction.angle()
	var b = bullet_scene.instantiate()
	b.setOnwer(player)
	get_tree().root.add_child(b)
	b.position = gun_tip.global_position
	b.rotation = gun_tip.rotation
	fire(b)

func _shootAnim():
	super._shootAnim()
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "position", position, timer.wait_time).from(position + Vector2(-1, -1))
	tween.tween_property($Sprite2D, "scale", Vector2(1,1), timer.wait_time).from(Vector2(0.5, 1.1))

func _on_timer_timeout():
	can_shoot = true
