extends Node

signal playerWeaponListChange() #武器列表改变
signal onWeaponChanged() #切换武器
signal onWeaponChangeAnim(id) #切换武器动作
signal onPlayerFireRateChange(player_fire_rate) #玩家复活信号
signal onWeaponBulletsChange(bullet,max_bullet) #武器子弹数量变化
signal onAmmoChange(ammo) #备用子弹数量变化
signal onPlayerDeath() #玩家死亡信号
signal onPlayerResurrect() #玩家复活信号

signal onRewardChange(reward)#血量变化
signal onHpChange(hp,max_hp)#血量变化
signal onGoldChange(gold)#血量变化
signal onPlayerLevelChange(level) #玩家等级信号
signal onPlayerExpChange(exp,max_exp) #玩家经验信号

var player_fire_rate = 1: #全局武器间隔
	set(value):
		player_fire_rate = value
		emit_signal("onPlayerFireRateChange",player_fire_rate)
var player_ammo = 100:#子弹数量
	set(value):
		player_ammo = value
		emit_signal("onAmmoChange",player_ammo)
var player_am_list = {} #配件列表
var player_weapon_list = {} #武器列表
var player_reward = {} #奖励列表
var player_hp_max = 5: #最大血量
	set(value):
		player_hp_max = value
		emit_signal("onHpChange",player_hp,player_hp_max)
var player_hp = 5: #当前血量
	set(value):
		player_hp = value
		emit_signal("onHpChange",player_hp,player_hp_max)
		if player_hp <= 0:
			emit_signal("onPlayerDeath")
var gold = 9999:
	set(value):
		gold = value
		emit_signal("onGoldChange",gold)

var player_speed = 1.0 #玩家额外移速加成
var player_damage = 0.3 #玩家基础伤害
var base_bullet_damage = 0 #子弹伤害增幅
var base_bullet_speed = 0 #射速增幅
var base_reload_speed = 0 #换弹增幅
var base_aim_enh = 0 #子弹暴击增幅
var base_magazine_count = 0 #子弹数量加成
var reward_point = 0:
	set(value):
		reward_point = value
		emit_signal("onRewardChange",reward_point)

var player_level = 1:
	set(value):
		player_level = value
		player_damage += 0.3
		player_hp_max += 0.5
		reward_point += 1
		emit_signal("onPlayerLevelChange",player_level)

var player_exp = 0:
	set(value):
		var max = getMaxExp()
		if player_exp >= max:
			player_exp = 0
			player_level += 1
		else:
			player_exp = value
		emit_signal("onPlayerExpChange",player_exp,max)

#设置血量
func resurrectPlayer(hp, ammo_percentage):
	if hp >= player_hp_max:
		player_hp = player_hp_max
	else:
		player_hp = hp
	if Utils.player.gun != null:
		var player_ammo_percentage = (player_ammo / Utils.player.gun.bullets_max_count) * 100
		if player_ammo_percentage < ammo_percentage:
			player_ammo = Utils.player.gun.bullets_max_count * ammo_percentage * 0.01
	emit_signal("onPlayerResurrect")

#回复血量
func addPlayerHp(hp):
	if hp + player_hp >= player_hp_max:
		player_hp = player_hp_max
	else:
		player_hp += hp
	#emit_signal("onPlayerResurrect")

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

func getMaxExp():
	return pow(player_level,2.2) + 15
