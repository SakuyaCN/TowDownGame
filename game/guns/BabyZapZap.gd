extends "res://game/guns/BaseGun.gd"

func _shoot():
	super._shoot()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - gun_tip.global_position).normalized()
	gun_tip.rotation = direction.angle()
	createBullet()

func createBullet():
	for i in 3:
		var b = bullet_scene.instantiate()
		b.setOnwer(player)
		get_tree().root.add_child(b)
		b.position = gun_tip.global_position
		b.rotation = gun_tip.rotation
		fire(b)
		call_deferred("_shootAnim")
		await get_tree().create_timer(0.15).timeout

func _shootAnim():
	super._shootAnim()
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "position", position, 0.15).from(position + Vector2(-1, -1))
	tween.tween_property($Sprite2D, "scale", Vector2(1,1), 0.15).from(Vector2(0.5, 1.1))

func _on_timer_timeout():
	can_shoot = true
