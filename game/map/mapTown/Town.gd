extends Node2D

@onready var map_under = $TileMap
@onready var pos_start = $TileMap2/Level_1/pos_start
@onready var pos_end = $TileMap2/Level_1/pos_end
@onready var timer = $CanvasLayer/Timer
@onready var monster_root = $TileMap2/MonsterRoot
@onready var shopBtn = $CanvasLayer/openShop
const weapon_choose = preload("res://ui/widgets/WeaponChoose.tscn")
const monster_pre = preload("res://game/monster/Monster 2/Monster2.tscn")


var level = 1

var time_out = 0

func _ready():
	pass

func _on_portal_2_move_out() -> void:
	var ins = weapon_choose.instantiate()
	ins.onWeaponChoosed.connect(self.onWeaponChoosed)
	Utils.canvasLayer.add_child(ins)

func onWeaponChoosed():
	Utils.showToast("游戏即将开始！",2)
	$CanvasLayer/timeout.visible = true
	$CanvasLayer/level.visible = true
	await get_tree().create_timer(3).timeout
	Utils.showToast("怪物将从随机方向进攻，请坚持到回合结束！",2)
	timer.start()
	time_out = 30

func _on_timer_timeout() -> void:
	time_out -= 1
	$CanvasLayer/timeout.text = "剩余时间：%s"%time_out
	if time_out == 0:
		onLevelEnd()
		return
	var ins = monster_pre.instantiate()
	ins.global_position = getPoint()
	ins.setData()
	monster_root.add_child(ins)

func onLevelEnd():
	timer.stop()
	for item in monster_root.get_children():
		item.queue_free()
	Utils.showToast("回合胜利！",2)
	Utils.player.global_position = $PositionHome.global_position

func getPoint():
	var random_point = Vector2(randi_range(pos_start.global_position.x, pos_end.global_position.x), randi_range(pos_start.global_position.y, pos_end.global_position.y))
	return random_point


func _on_shop_body_entered(body: Node2D) -> void:
	if body is Player:
		shopBtn.visible = true


func _on_shop_body_exited(body: Node2D) -> void:
	if body is Player:
		shopBtn.visible = false
