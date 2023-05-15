extends NinePatchRect

const wi_pre = preload("res://ui/widgets/ShopWeaponItem.tscn")
@onready var shop_weapon_list = $ScrollContainer/GridContainer
@onready var shop_am_list = $ScrollContainer2/GridContainer
@onready var dialog = $Control
@onready var dilaog_label = $Control/TextureRect/Label
@onready var tip = $Tooltip

var choose_id = null
var choose_am : BaseAttachment= null

func _enter_tree():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Utils.crosshairChange(false)

func _exit_tree():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	Utils.crosshairChange(true)

func _ready() -> void:
	for id in Utils.weapon_list:
		var ins = wi_pre.instantiate()
		shop_weapon_list.add_child(ins)
		ins.setData(id)
		ins.onWeaponClick.connect(self.onWeaponClick)
	loadAmList()

func loadAmList():
	for item in Utils.getTempAmList():
		var ins = wi_pre.instantiate()
		shop_am_list.add_child(ins)
		ins.setAmData(item)
		ins.mouseEvent.connect(self.mouseEvent)
		ins.onAmClick.connect(self.onAmClick)

func onWeaponClick(id,gun:BaseGun):
	choose_id = id
	dialog.visible = true
	dilaog_label.text = tr("BUY_WEAPON_TIP") + tr(gun.weapon_name)

func onAmClick(id,am:BaseAttachment):
	choose_id = id
	choose_am = am
	dialog.visible = true
	dilaog_label.text = tr("BUY_AM_TIP") + tr(am.am_name)

func _on_button_pressed() -> void:
	dialog.visible = false
	if choose_am != null:
		if PlayerData.gold >= choose_am.money:
			PlayerData.gold-= choose_am.money
			PlayerData.add_attachment(Utils.am_dict[choose_id].instantiate())
			Utils.showToast("BUY_OK")
		else:
			Utils.showToast("BUY_ERROR")
	elif choose_id != null:
		if PlayerData.gold >= Utils.weapon_money_list[choose_id]:
			PlayerData.gold-= Utils.weapon_money_list[choose_id]
			PlayerData.add_weapon(Utils.weapon_list[choose_id].instantiate())
			Utils.showToast("BUY_OK")
		else:
			Utils.showToast("BUY_ERROR")

func _on_button_2_pressed() -> void:
	dialog.visible = false
	choose_id = null
	choose_am = null

func mouseEvent(show,am):
	tip.visible = show
	tip.setData(am)

#关闭
func _on_button_3_pressed() -> void:
	queue_free()
