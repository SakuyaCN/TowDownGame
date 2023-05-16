extends "res://game/monster/BaseMonster.gd"

var area_player = null

func _ready():
	super._ready()
	anim.play("idle")

func _on_area_2d_body_entered(body):
	if body is Player && !is_die:
		area_player = body
		is_atk = true
		$AtkTimer.start()

func onAtk():
	if is_die:
		return
	anim.play("atk")
	await anim.animation_finished
	anim.play("idle")

func _on_animated_sprite_2d_frame_changed():
	if anim.animation == "atk" && anim.frame == 5 && area_player != null && !is_die:
		area_player.onHit(hurt)


func _on_area_2d_body_exited(body):
	if body is Player:
		is_atk = false
		area_player = null

func _on_atk_timer_timeout():
	onAtk()
