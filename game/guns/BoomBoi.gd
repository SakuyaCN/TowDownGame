extends "res://game/guns/BaseGun.gd"

@export var cast_count = 2 #激光目标个数

@onready var cast = $RayCast2D
@onready var line_2d = $RayCast2D/Line2D
@onready var particles_box = $RayCast2D/Line2D/GPUParticles2D
@onready var particles_end = $RayCast2D/GPUParticles2D2
@onready var tick = $tick

var is_cast = false
var one_bullet_array = []

func _shoot():
	super._shoot()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - gun_tip.global_position).normalized()
	gun_tip.rotation = direction.angle()
	openFire()

func _shootAnim():
	super._shootAnim()
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "position", position, timer.wait_time).from(position + Vector2(-1, -1))
	tween.tween_property($Sprite2D, "scale", Vector2(1,1), timer.wait_time).from(Vector2(0.5, 1.1))
	add_child(particles_pre.instantiate())

func _on_timer_timeout():
	can_shoot = true

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var cast_point = cast.target_position
	cast.force_raycast_update()
	if is_cast:
		if cast.is_colliding():
			var coller = cast.get_collider()
			cast_point = to_local(cast.get_collision_point())
			particles_end.global_rotation = cast.get_collision_normal().angle()
			if coller is BaseMonster && one_bullet_array.size() < cast_count:
				bulletHurt(coller)
		
	line_2d.points[1] = cast_point
	particles_box.position = cast_point * 0.5
	particles_box.process_material.emission_box_extents.x = cast_point.length() * 0.5
	particles_end.position = cast_point + Vector2(2,0)

func bulletHurt(coller):
	if one_bullet_array.has(coller):
		return
	var bullet = bullet_scene.instantiate()
	fire(bullet,false,false)
	if bullet:
		coller.hitFlash(null,bullet)
		one_bullet_array.append(coller)

func openFire():
	if bullets_count == 0:
		return
	bullets_count -= 1
	is_cast = true
	openLaser()
	await get_tree().create_timer(0.4).timeout
	stopLaser()

func openLaser():
	audio.play()
	player.set_knockback(recoil)
	tick.start()
	particles_end.emitting = true
	particles_box.emitting = true
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(line_2d,"width",6.0,0.2)

func stopLaser():
	tick.stop()
	is_cast = false
	particles_end.emitting = false
	particles_box.emitting = false
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(line_2d,"width",0.0,0.2)


func _on_tick_timeout() -> void:
	one_bullet_array.clear()
