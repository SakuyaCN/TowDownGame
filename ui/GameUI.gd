extends Control

const weapon_item_pre = preload("res://ui/widgets/WeaponListItem.tscn")
const weapon_bullet_pre = preload("res://ui/widgets/BulletCountItem.tscn")

@onready var weapon_lsit_node = $HBoxContainer
@onready var weapon_change_image = $WeaponChangeUI/WeaponImage
@onready var weapon_bullet_list = $Container/BulletHbox

func _ready() -> void:
	PlayerData.playerWeaponListChange.connect(self.playerWeaponListChange)
	PlayerData.onWeaponChangeAnim.connect(self.onWeaponChangeAnim)
	PlayerData.onWeaponBulletsChange.connect(self.onWeaponBulletsChange)

func playerWeaponListChange():
	for item in PlayerData.player_weapon_list:
		if !weapon_lsit_node.has_node(str(item)):
			var ins = weapon_item_pre.instantiate()
			ins.name = str(item)
			ins.local_id = item
			weapon_lsit_node.add_child(ins)

func onWeaponChangeAnim(weapon_id):
	var weapon:BaseGun = PlayerData.player_weapon_list[weapon_id]
	weapon_change_image.texture = weapon.image
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(weapon_change_image,"modulate:a",1.0,0.3).from(0.0)
	tween.tween_property(weapon_change_image,"modulate:a",0.0,0.3).from(1.0).set_delay(0.5)
	loadWeaponBullets(weapon_id)

func loadWeaponBullets(weapon_id):
	for item in weapon_bullet_list.get_children():
		item.queue_free()
	var weapon:BaseGun = PlayerData.player_weapon_list[weapon_id] 
	for item in weapon.bullets_count:
		var ins = weapon_bullet_pre.instantiate()
		weapon_bullet_list.add_child(ins)

func onWeaponBulletsChange(bullet,bullet_max):
	if weapon_bullet_list.get_child_count() > 0:
		weapon_bullet_list.get_child(0).destory()
