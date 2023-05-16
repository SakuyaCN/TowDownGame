extends Node2D
class_name BaseAttachment

@export var am_id = 0 #配件ID
@export var am_name = "" #配件名称
@export var am_image:Texture #配件图片
@export_enum("WEAPON_OPTICS","WEAPON_MUZZLE","WEAPON_BARREL","WEAPON_UNDERBARREL","WEAPON_AMMUNITION","WEAPON_STOCK","WEAPON_TACTICAL","WEAPON_PERKS") var am_type = "WEAPON_OPTICS" #配件类型
@export_multiline var am_info = "" #介绍
#@export_flags("ASSAULT_RIFLES", "SUBMACHINE_GUNSRELOAD", "MACHINE_GUNS","SNIPER_RIFLES","SHOTGUNS","LASER_WEAPONS") var weapon_type = 0 #限制穿戴
@export var money = 20 #价格

@export_group("武器可用类型")
@export var ASSAULT_RIFLES = false
@export var SUBMACHINE_GUNSRELOAD = false
@export var MACHINE_GUNS = false
@export var SNIPER_RIFLES = false
@export var SHOTGUNS = false
@export var LASER_WEAPONS = false

var use_type = []#可用类型
var id = Time.get_ticks_usec() #配件在背包中的ID

var gun:BaseGun
	
func _ready() -> void:
	name = str(id)
	_checkTypeList()

#当前配件是否可用安装到枪械
func canUseAm(type):
	return use_type.has(type)

#可用类型
func _checkTypeList():
	use_type.clear()
	if ASSAULT_RIFLES:use_type.append("ASSAULT_RIFLES")
	if SUBMACHINE_GUNSRELOAD:use_type.append("SUBMACHINE_GUNSRELOAD")
	if MACHINE_GUNS:use_type.append("MACHINE_GUNS")
	if SNIPER_RIFLES:use_type.append("SNIPER_RIFLES")
	if SHOTGUNS:use_type.append("SHOTGUNS")
	if LASER_WEAPONS:use_type.append("LASER_WEAPONS")

#装备上武器
func onWeaponUp(gun):
	self.gun = gun
	onStart()
	gunUpdate()

#取消武器
func onWeaponDown():
	onDestroy()
	gunUpdate()
	self.gun = null

func onStart():
	pass

func onDestroy():
	pass

func gunUpdate():
	gun.updateGun()
