extends Node

enum GUN_TYPE { #枪械类型
	ASSAULT_RIFLES = 1 << 0, #突击步枪
	SUBMACHINE_GUNSRELOAD = 1 << 1, #冲锋枪
	MACHINE_GUNS = 1 << 2, #机枪
	SNIPER_RIFLES = 1 << 3, #狙击步枪
	SHOTGUNS = 1 << 4, #霰弹枪
	LASER_WEAPONS = 1 << 5, #激光武器
}

enum GUN_CHANGE_TYPE { #切枪类型
	CHANGE, #切换枪械
	RELOAD #切换子弹
}

enum ATTACHMENTS_TYPE { #配件类型
	WEAPON_OPTICS, #瞄准镜
	WEAPON_MUZZLE, #枪口
	WEAPON_BARREL, #枪口
	WEAPON_UNDERBARREL, #枪口
	WEAPON_AMMUNITION, #枪口
	WEAPON_STOCK, #枪口
	WEAPON_TACTICAL, #枪口
	WEAPON_PERKS, #枪口
}

const weapon_list = {
	"0" = preload("res://game/guns/GunSprite.tscn"),
	"1" = preload("res://game/guns/ShotgunBlaster.tscn"),
	"2" = preload("res://game/guns/Sniper.tscn"),
	"3" = preload("res://game/guns/BabyZapZap.tscn"),
	"4" = preload("res://game/guns/AlienRifle.tscn"),
	"5" = preload("res://game/guns/EmpireShotgun.tscn"),
	"6" = preload("res://game/guns/BoomBoi.tscn"),
	"7" = preload("res://game/guns/AlienMachine.tscn"),
	"8" = preload("res://game/guns/RebalShotgun.tscn")
}

const weapon_money_list = {
	"0" = 10,
	"1" = 10,
	"2" = 10,
	"3" = 10,
	"4" = 50,
	"5" = 50,
	"6" = 100,
	"7" = 100,
	"8" = 100
}

var am_list = [
	preload("res://game/attachments/ExtendedRifleMagazine.tscn"),
	preload("res://game/attachments/MachineGunMagazine.tscn"),
	preload("res://game/attachments/QuickExpansionMagazine.tscn"),
	preload("res://game/attachments/QuickdrawMagazine.tscn"),
	preload("res://game/attachments/ShotgunShellPouch.tscn"),
	preload("res://game/attachments/UniversalExtendedMagazines.tscn"),
	preload("res://game/attachments/SubmachineGunMagazine.tscn")
]

const hitlabel = preload("res://ui/widgets/HitLabel.tscn")

var canvasLayer:CanvasLayer
var player:Player
var freeze_frame = false
var shake = 1.0 #振动幅度
var is_game_start = false #游戏是否开始

var is_inv_show = false #是否展示背包

var crosshair_position = Vector2.ZERO

var temp_am_list = []

signal onGameStart()

func _ready() -> void:
	TranslationServer.set_locale("zh_CN")

func getTempAmList():
	if temp_am_list.is_empty():
		am_list.shuffle()
		for i in 5:
			temp_am_list.append(am_list[i])
	return temp_am_list

func gameStart():
	is_game_start = true
	emit_signal("onGameStart")

#伤害数字
func showHitLabel(num,traget:Node2D):
	var ins = hitlabel.instantiate()
	ins.setNumber(num)
	traget.add_child(ins)

#获取配件类型名称
func getAttachmentsName(type:ATTACHMENTS_TYPE):
	match type:
		ATTACHMENTS_TYPE.WEAPON_OPTICS :return "WEAPON_OPTICS"
		ATTACHMENTS_TYPE.WEAPON_MUZZLE :return "WEAPON_MUZZLE"
		ATTACHMENTS_TYPE.WEAPON_BARREL :return "WEAPON_BARREL"
		ATTACHMENTS_TYPE.WEAPON_UNDERBARREL :return "WEAPON_UNDERBARREL"
		ATTACHMENTS_TYPE.WEAPON_AMMUNITION :return "WEAPON_AMMUNITION"
		ATTACHMENTS_TYPE.WEAPON_STOCK :return "WEAPON_STOCK"
		ATTACHMENTS_TYPE.WEAPON_TACTICAL :return "WEAPON_TACTICAL"
		ATTACHMENTS_TYPE.WEAPON_PERKS :return "WEAPON_PERKS"

#获取武器类型名称
func getWeaponName(type:GUN_TYPE):
	match type:
		GUN_TYPE.ASSAULT_RIFLES :return "ASSAULT_RIFLES"
		GUN_TYPE.SUBMACHINE_GUNSRELOAD :return "SUBMACHINE_GUNSRELOAD"
		GUN_TYPE.MACHINE_GUNS :return "MACHINE_GUNS"
		GUN_TYPE.SNIPER_RIFLES :return "SNIPER_RIFLES"
		GUN_TYPE.SHOTGUNS :return "SHOTGUNS"
		GUN_TYPE.LASER_WEAPONS :return "LASER_WEAPONS"

func freezeFrame(scale):
	#OS.delay_msec(50)
	#return
	if !freeze_frame && scale > 0:
		# 冻结帧
		freeze_frame = true
		# 将时间比例设置为0.1
		Engine.time_scale = scale

func showToast(msg,time = 1):
	canvasLayer.showToast(msg,time)

func crosshairChange(is_change):
	canvasLayer.crosshairChange(is_change)

#func _physics_process(delta):
#	if freeze_frame && Engine.get_physics_frames() % 2 == 0:
		# 暂停一帧
#		freeze_frame = false
		# 将时间比例设置为1
#		Engine.time_scale = 1
#		return
