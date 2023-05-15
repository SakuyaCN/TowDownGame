extends TextureRect

var gun:BaseGun
var am:BaseAttachment
var id

signal onWeaponClick(gun)
signal onAmClick(am)

signal mouseEvent(is_show)

func setData(id):
	self.id = id
	self.gun = Utils.weapon_list[id].instantiate()
	$TextureRect.texture = gun.image
	$Label.text = str(Utils.weapon_money_list[id])
	tooltip_text = gun.weapon_name

func setAmData(id):
	self.id = id
	self.am = Utils.am_dict[id].instantiate()
	texture = null
	$TextureRect.texture = am.am_image
	#$Label.text = str(Utils.weapon_money_list[id])
	#tooltip_text = gun.weapon_name

func _make_custom_tooltip(for_text: String) -> Object:
	var setting = LabelSettings.new()
	setting.font_size = 12
	var label = Label.new()
	label.text = for_text
	label.label_settings = setting
	return label

func _exit_tree() -> void:
	if gun:
		gun.queue_free()
	if am:
		am.queue_free()

func _on_button_pressed() -> void:
	if gun != null:
		emit_signal("onWeaponClick",id,gun)
	if am != null:
		emit_signal("onAmClick",id,am)


func _on_button_mouse_entered() -> void:
	emit_signal("mouseEvent",true,am)


func _on_button_mouse_exited() -> void:
	emit_signal("mouseEvent",false,null)
