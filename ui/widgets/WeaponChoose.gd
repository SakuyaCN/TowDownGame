extends Control

const item_pre = preload("res://ui/widgets/WeaponChooseItem.tscn")

signal onWeaponChoosed()

func _enter_tree() -> void:
	Utils.crosshairChange(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _exit_tree() -> void:
	Utils.crosshairChange(true)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _ready() -> void:
	var guns = Utils.weapon_list.keys().duplicate()
	
	for i in 3:
		guns.shuffle()
		var gun = guns.pop_back()
		var ins = item_pre.instantiate()
		$Panel/HBoxContainer.add_child(ins)
		ins.setData(gun)
		ins.onWeaponClick.connect(self.weaponClick)

func weaponClick(id):
	PlayerData.add_weapon(Utils.weapon_list[id].instantiate())
	emit_signal("onWeaponChoosed")
	queue_free()
