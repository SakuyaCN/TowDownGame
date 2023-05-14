extends Control

@onready var image = $TextureRect

var local_id

signal mouseEvent(show,am)
signal onTouchDown(id)
signal onTouchUp(id)

func _ready() -> void:
	setData(local_id)

func setData(id):
	var am :BaseAttachment = PlayerData.player_am_list[id]
	image.texture = am.am_image

func _on_button_button_down() -> void:
	emit_signal("onTouchDown",local_id)


func _on_button_button_up() -> void:
	emit_signal("onTouchUp",local_id)


func _on_mouse_entered():
	emit_signal("mouseEvent",true,PlayerData.player_am_list[local_id])


func _on_mouse_exited():
	emit_signal("mouseEvent",false,null)

