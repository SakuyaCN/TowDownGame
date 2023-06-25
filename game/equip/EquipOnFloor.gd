extends Node2D

var equip:BaseEquip
var is_pick = false

func _ready():
	if equip:
		$TextureRect.texture = equip.equip_image

func _unhandled_input(event):
	if Input.is_action_pressed("e") && $Label.visible && !is_pick:
		get_viewport().set_input_as_handled()
		is_pick = true
		EquipServer.addEquipToPlayer(equip)
		queue_free()

func _on_timer_timeout():
	queue_free()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "show":
		$AnimationPlayer.play("new_animation")

func _on_area_2d_body_entered(body):
	if body is Player:
		$Label.visible = true

func _on_area_2d_body_exited(body):
	if body is Player:
		$Label.visible = false

