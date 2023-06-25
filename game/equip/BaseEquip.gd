extends Node2D
class_name BaseEquip

const equip_texture_pre = preload("res://ui/snow/EquipTexture.tscn")

@export var equip_name = "" #武器名称
@export var equip_image :Texture #武器图片
@export var equip_info = "" #武器说明
@export_enum("q", "space", "mouse_right") var equip_quick_key = "q" #绑定键位
@export var cd_time = 60 #CD冷却时间


var temp_cd = 0 #当前冷却读秒
var in_equ = false #是否装备中
var timer = Timer.new()
var equip_texture_ins #状态UI

func _ready():
	timer.wait_time = 0.1
	timer.timeout.connect(self.on_timeout)
	add_child(timer)

func _input(event):
	if Input.is_action_pressed(equip_quick_key) && temp_cd <= 0:
		temp_cd = cd_time
		timer.start()
		openFire()

func on_timeout():
	if temp_cd > 0:
		temp_cd -= 0.1
		print(temp_cd)
		if temp_cd == 0:
			timer.stop()

func _enter_tree():
	in_equ = true
	if !equip_texture_ins:
		equip_texture_ins = equip_texture_pre.instantiate()
		equip_texture_ins.name = equip_name
		equip_texture_ins.setEquip(self)
		EquipServer.addUI(equip_texture_ins)

func _exit_tree():
	in_equ = false
	if equip_texture_ins:
		EquipServer.removeUI(equip_texture_ins)

func openFire():
	get_node("Root").look_at(get_global_mouse_position())
