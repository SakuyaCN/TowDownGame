extends Node

signal playerWeaponListChange()
signal onWeaponChanged()

var player_weapon_list = {}

var is_change_weapon = false

func add_weapon(weapon:BaseGun):
	if !player_weapon_list.has(weapon.weapon_id):
		player_weapon_list[weapon.weapon_id] = weapon
		emit_signal("playerWeaponListChange")
		return true
	return false

func add_weapons(weapons :Array):
	var is_change = false
	for item in weapons:
		add_weapon(item)
	emit_signal("playerWeaponListChange")

func changeWeapon(weapon_id:int):
	if is_change_weapon:
		return
	if player_weapon_list.has(weapon_id):
		is_change_weapon = true
		Utils.player.changeWeapon(weapon_id)
		Engine.time_scale = 0.3

func _physics_process(delta: float) -> void:
	if is_change_weapon && Engine.get_physics_frames() % 60== 0:
		Engine.time_scale = 1
		is_change_weapon = false
