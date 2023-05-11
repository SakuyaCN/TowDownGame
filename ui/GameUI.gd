extends Control

const weapon_item_pre = preload("res://ui/widgets/WeaponListItem.tscn")
const weapon_bullet_pre = preload("res://ui/widgets/BulletCountItem.tscn")

@onready var box_top = $hpUI
@onready var bottom_bls = $Container

@onready var weapon_lsit_node = $HBoxContainer
@onready var weapon_change_image = $WeaponChangeUI/WeaponImage
@onready var weapon_bullet_list = $Container/BulletHbox
@onready var ammo_count_label = $Container/Label
@onready var weapon_change_name = $WeaponChangeUI/WeaponImage/Label
@onready var hp_bar = $hpUI/ProgressBar

func _ready() -> void:
	Utils.onGameStart.connect(self.onGameStart)
	PlayerData.playerWeaponListChange.connect(self.playerWeaponListChange) #武器列表化监听
	PlayerData.onWeaponChangeAnim.connect(self.onWeaponChangeAnim) #武器化监听
	PlayerData.onWeaponBulletsChange.connect(self.onWeaponBulletsChange) #武器化监听
	PlayerData.onHpChange.connect(func hpChange(hp,max_hp): #血量变化监听
		hp_bar.max_value = max_hp;hp_bar.value = hp)

func onGameStart():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tween.tween_property(box_top,"position:y",box_top.position.y,0.3).from(box_top.position.y-box_top.size.y)
	tween.tween_property(bottom_bls,"position:y",bottom_bls.position.y,0.3).from(bottom_bls.position.y+bottom_bls.size.y)
	tween.tween_property(weapon_lsit_node,"position:y",weapon_lsit_node.position.y,0.3).from(weapon_lsit_node.position.y+weapon_lsit_node.size.y)
	show()

func playerWeaponListChange():
	for item in PlayerData.player_weapon_list:
		if !weapon_lsit_node.has_node(str(item)):
			var ins = weapon_item_pre.instantiate()
			ins.name = str(item)
			ins.local_id = item
			weapon_lsit_node.add_child(ins)

func onWeaponChangeAnim(weapon_id,tag = Utils.GUN_CHANGE_TYPE.CHANGE):
	if tag == Utils.GUN_CHANGE_TYPE.CHANGE:
		var weapon:BaseGun = PlayerData.player_weapon_list[weapon_id]
		weapon_change_name.text = weapon.weapon_name
		ammo_count_label.text = "%s / %s" %[weapon.bullets_count,weapon.bullets_max_count]
		weapon_change_image.texture = weapon.image
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(weapon_change_image,"modulate:a",1.0,0.3).from(0.0)
		tween.tween_property(weapon_change_image,"modulate:a",0.0,0.3).from(1.0).set_delay(0.5)
	call_deferred("loadWeaponBullets",weapon_id)

func loadWeaponBullets(weapon_id):
	for item in weapon_bullet_list.get_children():
		item.free()
	weapon_bullet_list.get_children().clear()
	var weapon:BaseGun = PlayerData.player_weapon_list[weapon_id]
	var local_count =  weapon.bullets_max_count - weapon.bullets_count
	var index = 1
	for item in weapon.bullets_count:
		var ins = weapon_bullet_pre.instantiate()
		ins.name = str(local_count + index)
		weapon_bullet_list.add_child(ins)
		index += 1

func onWeaponBulletsChange(bullet,bullet_max):
	ammo_count_label.text = "%s / %s" %[bullet,bullet_max]
	var local_count =  bullet_max - bullet
	if weapon_bullet_list.has_node(str(local_count)):
		weapon_bullet_list.get_node(str(local_count)).destory()
