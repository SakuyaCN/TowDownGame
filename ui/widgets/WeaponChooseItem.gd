extends Control

var gun:BaseGun
var id
signal onWeaponClick(gun)

func _ready() -> void:
	pass # Replace with function body.

func setData(id):
	self.id = id
	self.gun = Utils.weapon_list[id].instantiate()
	$TextureRect.texture = gun.image
	$Label.text = tr(gun.weapon_name)

func _exit_tree() -> void:
	gun.queue_free()

func _on_button_pressed() -> void:
	emit_signal("onWeaponClick",id)
