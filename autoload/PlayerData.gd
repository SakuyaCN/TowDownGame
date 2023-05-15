extends Node

signal playerWeaponListChange() #武器列表改变
signal onWeaponChanged() #切换武器
signal onWeaponChangeAnim(id) #切换武器动作
signal onWeaponBulletsChange(bullet,max_bullet) #武器子弹数量变化

signal onHpChange(hp,max_hp)#血量变化
signal onGoldChange(gold)#血量变化

var player_am_list = {} #配件列表
var player_weapon_list = {} #武器列表
var player_hp_max = 10: #最大血量
	set(value):
		player_hp_max = value
		emit_signal("onHpChange",player_hp,player_hp_max)
var player_hp = 10: #当前血量
	set(value):
		player_hp = value
		emit_signal("onHpChange",player_hp,player_hp_max)
var gold = 10:
	set(value):
		gold = value
		emit_signal("onGoldChange",gold)

var is_change_weapon = false
#添加一把武器
func add_weapon(weapon:BaseGun):
	if !player_weapon_list.has(weapon.weapon_id):
		player_weapon_list[weapon.weapon_id] = weapon
		emit_signal("playerWeaponListChange")
		return true
	return false

#添加一堆武器
func add_weapons(weapons :Array):
	var is_change = false
	for item in weapons:
		add_weapon(item)
	emit_signal("playerWeaponListChange")

func add_attachment(am:BaseAttachment):
	if !player_am_list.has(am.id):
		player_am_list[am.id] = am
		add_child(am)

func changeWeapon(weapon_id:int):
	if is_change_weapon:
		return
	if player_weapon_list.has(weapon_id):
		is_change_weapon = true
		Utils.player.changeWeapon(weapon_id)
		#Engine.time_scale = 0.1

func _physics_process(delta: float) -> void:
	if is_change_weapon && Engine.get_physics_frames() % 90 == 0:
		Engine.time_scale = 1
		is_change_weapon = false
