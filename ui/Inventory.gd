extends Control

const weapon_item_pre = preload("res://ui/widgets/WeaponTopItem.tscn")
const attachmont_item_pre = preload("res://ui/widgets/AttachmentUIItem.tscn")

@onready var weapon_lsit_node = $Panel/HBoxContainer
@onready var am_list_node = $Panel/ScrollContainer/GridContainer
@onready var choose_image = $Panel/WeaponMain/iamge
@onready var choose_name = $Panel/WeaponMain/iamge/Label
@onready var touch_texture = $TouchTexture
@onready var tip = $Tooltip

@onready var weapon_am_nodes = [$Panel/WeaponMain/GridContainer/Control,$Panel/WeaponMain/GridContainer/Control2, $Panel/WeaponMain/GridContainer/Control3, $Panel/WeaponMain/GridContainer/Control4, $Panel/WeaponMain/GridContainer/Control5, $Panel/WeaponMain/GridContainer/Control6, $Panel/WeaponMain/GridContainer/Control7, $Panel/WeaponMain/GridContainer/Control8]

var choose_gun :BaseGun = Utils.player.gun

func _enter_tree() -> void:
	Utils.is_inv_show = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = true

func _exit_tree() -> void:
	if !Utils.pause_state:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		get_tree().paused = false
	Utils.is_inv_show = false
	

func _ready() -> void:
	for node in weapon_am_nodes:
		node.mouseEvent.connect(self.mouseEvent)
		node.checkTouchDown.connect(self.checkTouchDown)

	for item in PlayerData.player_weapon_list:
		if !weapon_lsit_node.has_node(str(item)):
			var ins = weapon_item_pre.instantiate()
			ins.weapon_click.connect(self.weapon_click)
			ins.name = str(item)
			ins.local_id = item
			weapon_lsit_node.add_child(ins)
	loadBag()
	if choose_gun:
		setWeaponChoose()
		loadWeaponAm()

func loadBag():
	for item in am_list_node.get_children():
		item.queue_free()
	am_list_node.get_children().clear()
	await get_tree().create_timer(0.01).timeout
	for item in PlayerData.player_am_list:
		if !am_list_node.has_node(str(item)) && PlayerData.player_am_list[item].gun == null:
			var ins = attachmont_item_pre.instantiate()
			ins.mouseEvent.connect(self.mouseEvent)
			ins.onTouchDown.connect(self.onTouchDown)
			ins.onTouchUp.connect(self.onTouchUp)
			ins.name = str(item)
			ins.local_id = item
			am_list_node.add_child(ins)

func mouseEvent(show,am):
	tip.visible = show
	tip.setData(am)

func loadWeaponAm():
	for item in weapon_am_nodes:
		if choose_gun.attachments_dict.has(item.am_type):
			item.setData(choose_gun.attachments_dict[item.am_type])
		else:
			item.setData(null)

func weapon_click(id) -> void:
	choose_gun = PlayerData.player_weapon_list[id]
	setWeaponChoose()
	
func setWeaponChoose():
	choose_image.texture = choose_gun.image
	choose_name.text = tr(choose_gun.weapon_name) + " · "+ tr(choose_gun.weapon_type)
	loadWeaponAm()

func onTouchDown(id):
	var am :BaseAttachment = PlayerData.player_am_list[id]
	touch_texture.visible = true 
	touch_texture.texture = am.am_image
	touch_texture.global_position = get_global_mouse_position()
	set_process(true)
	checkTouchState(id)

func onTouchUp(id):
	touch_texture.visible = false 
	touch_texture.texture = null
	set_process(false)
	for item in weapon_am_nodes:
		if item.get_global_rect().has_point(get_global_mouse_position()):
			checkTouchUp(id,item)
			break
	for node in weapon_am_nodes:
		node.setState(true)

func checkTouchState(id):
	var am :BaseAttachment = PlayerData.player_am_list[id]
	for node in weapon_am_nodes:
		node.setState(am.am_type == node.am_type and am.canUseAm(choose_gun.weapon_type))

func checkTouchUp(id,node:WeaponAmItem):
	var am :BaseAttachment = PlayerData.player_am_list[id]
	if node.state:
		choose_gun.addAttachMent(am)
		loadWeaponAm()
		Utils.showToast("INVENTORY_AM_UP")
		loadBag()

func checkTouchDown(am:BaseAttachment):
	choose_gun.removeAttachMent(am)
	loadWeaponAm()
	loadBag()
	Utils.showToast("INVENTORY_AM_DOWN")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Utils.crosshairChange(true)
		queue_free()

func _process(delta: float) -> void:
	if touch_texture.visible:
		var mouse_position = get_global_mouse_position() - Vector2(12,12)
		touch_texture.global_position = mouse_position
