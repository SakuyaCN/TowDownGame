extends Node

enum GUN_CHANGE_TYPE { #切枪类型
	CHANGE, #切换枪械
	RELOAD #切换子弹
}

const weapon_list = {
	"0" = preload("res://game/guns/GunSprite.tscn"),
	"1" = preload("res://game/guns/ShotgunBlaster.tscn"),
	"2" = preload("res://game/guns/Sniper.tscn"),
	"3" = preload("res://game/guns/BabyZapZap.tscn"),
	"4" = preload("res://game/guns/AlienRifle.tscn"),
	"5" = preload("res://game/guns/EmpireShotgun.tscn"),
	"6" = preload("res://game/guns/BoomBoi.tscn"),
	"7" = preload("res://game/guns/AlienMachine.tscn")
}

const hitlabel = preload("res://ui/widgets/HitLabel.tscn")

var player:Player
var freeze_frame = false
var shake = 1.0 #振动幅度
var is_game_start = false #游戏是否开始

signal onGameStart()

func _ready() -> void:
	TranslationServer.set_locale("zh_CN")

func gameStart():
	is_game_start = true
	emit_signal("onGameStart")

#伤害数字
func showHitLabel(num,traget:Node2D):
	var ins = hitlabel.instantiate()
	ins.setNumber(num)
	traget.add_child(ins)

func freezeFrame(scale):
	#OS.delay_msec(50)
	#return
	if !freeze_frame && scale > 0:
		# 冻结帧
		freeze_frame = true
		# 将时间比例设置为0.1
		Engine.time_scale = scale

#func _physics_process(delta):
#	if freeze_frame && Engine.get_physics_frames() % 2 == 0:
		# 暂停一帧
#		freeze_frame = false
		# 将时间比例设置为1
#		Engine.time_scale = 1
#		return
