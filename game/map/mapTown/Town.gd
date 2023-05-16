extends Node2D

@onready var map_under = $TileMap
@onready var pos_start = $TileMap2/Level_1/pos_start
@onready var pos_end = $TileMap2/Level_1/pos_end
@onready var pos_level_5 = $TileMap2/Level_5/pos_start
@onready var pos_level_11 = $TileMap2/Level_11
@onready var monster_root = $TileMap2/MonsterRoot
@onready var shopBtn = $CanvasLayer/openShop
@onready var kill_playr = $Kill
@onready var portal_start = $TileMap2/PortalRoot/Portal 
@onready var portal_lv1 = $TileMap2/PortalRoot/Portal2 
@onready var portal_lv5 = $TileMap2/PortalRoot/Portal3 
@onready var portal_lv11 = $TileMap2/PortalRoot/Portal4 

@onready var timer = $CanvasLayer/Timer

const gold = preload("res://game/items/Gold.tscn")
const score_board = preload("res://ui/widgets/Scoreboard.tscn")
const weapon_choose = preload("res://ui/widgets/WeaponChoose.tscn")
const monster_pre = preload("res://game/monster/Monster 2/Monster2.tscn")
const death_borad = preload("res://ui/widgets/DeathBoard.tscn")

var level = 10

var time_dict = {
	"1" = 20,
	"2" = 30,
	"3" = 40,
	"4" = 50,
	"5" = 60,
	"6" = 30,
	"7" = 30,
	"8" = 30,
	"9" = 30,
	"10" = 30,
	"11" = 30,
	"12" = 30,
	"13" = 30,
	"14" = 30,
	"15" = 30,
}

var monster_attr = {
	"1" = {'speed' = 50,'hp' = 1,'hurt' = 1},
	"2" = {'speed' = 55,'hp' = 2,'hurt' = 1},
	"3" = {'speed' = 60,'hp' = 3,'hurt' = 2},
	"4" = {'speed' = 70,'hp' = 4,'hurt' = 2},
	"5" = {'speed' = 80,'hp' = 5,'hurt' = 2},
	"6" = {'speed' = 120,'hp' = 6,'hurt' = 3},
	"7" = {'speed' = 120,'hp' = 6,'hurt' = 3},
	"8" = {'speed' = 120,'hp' = 7,'hurt' = 3},
	"9" = {'speed' = 120,'hp' = 7,'hurt' = 3},
	"10" = {'speed' = 120,'hp' = 8,'hurt' = 3},
	"11" = {'speed' = 100,'hp' = 8,'hurt' = 3},
	"12" = {'speed' = 100,'hp' = 8,'hurt' = 4},
	"13" = {'speed' = 100,'hp' = 9,'hurt' = 4},
	"14" = {'speed' = 100,'hp' = 9,'hurt' = 4},
	"15" = {'speed' = 100,'hp' = 9,'hurt' = 4}
}

var level_info = {
	time = 0,
	kill = 0,
	gold = 0
}

var time_out = 0

func _ready():
	portal_start.next_area = portal_lv5
	Utils.onGameStart.connect(self.onGameStart)
	PlayerData.onPlayerDeath.connect(self.onPlayerDeath)

func _unhandled_input(event: InputEvent) -> void:
	if $CanvasLayer/openShop.visible && Input.is_action_just_pressed("e"):
		var ins = Utils.shop_pre.instantiate()
		$CanvasLayer.add_child(ins)

func onGameStart():
	$CanvasLayer/level.visible = true
	$CanvasLayer/timeout.visible = true

func onPlayerDeath():
	timer.paused = true
	var ins = death_borad.instantiate()
	ins.setOnClick(func callback(success):
		if success:
			timer.paused = false
			PlayerData.resurrectPlayer(PlayerData.player_hp_max)
		else:
			PlayerData.resurrectPlayer(1)
			onLevelEnd(false)
		)
	$CanvasLayer.add_child(ins)

func _on_portal_2_move_out() -> void:
	Utils.showToast("GAME_START_BEGIN",2)
	$CanvasLayer/timeout.visible = true
	$CanvasLayer/level.visible = true
	$CanvasLayer/level.text = tr("DIFFICULTY LEVEL") + " " + str(level)
	await get_tree().create_timer(3).timeout
	Utils.showToast("START_TIP",2)
	timer.start()
	time_out = time_dict[str(level)]

func _on_timer_timeout() -> void:
	if Utils.player.is_dead == false:
		time_out -= 1
		level_info.time += 1
		$CanvasLayer/timeout.text =tr("REMAINING TIME") + str(time_out)
		if time_out == 0:
			onLevelEnd(true)
			return
		var ins = monster_pre.instantiate()
		ins.global_position = getPoint()
		ins.setData(monster_attr[str(level)])
		ins.setDeathCallBack(self.onMonsterDeath)
		monster_root.add_child(ins)

#回合结束
func onLevelEnd(is_victory):
	timer.stop()
	$CanvasLayer/timeout.text =tr("REMAINING TIME")
	for item in monster_root.get_children():
		item.queue_free()
	if is_victory:
		roundVictory()
	else:
		Utils.player.global_position = $PositionHome.global_position
	await get_tree().create_timer(1).timeout
	portal_start.reset()
	portal_lv1.reset()
	portal_lv5.reset()

#回合胜利
func roundVictory():
	level += 1
	Utils.showToast("VICTORY IN THE ROUND",1)
	var score_board_ins = score_board.instantiate()
	score_board_ins.setCallBack(func setPosition():
		Utils.player.global_position = $PositionHome.global_position
		level_info = {
			time = 0,
			kill = 0,
			gold = 0
		}
	)
	$CanvasLayer.add_child(score_board_ins)
	score_board_ins.setData(level_info)
	if [1,2,3,4,5].has(level):
		timer.wait_time = 1
		portal_start.next_area = portal_lv1
	elif [6,7,8,9,10].has(level):
		timer.wait_time = 0.5
		portal_start.next_area = portal_lv5
	elif [11,12,13,14,15].has(level):
		timer.wait_time = 0.5
		portal_start.next_area = portal_lv11

#获取坐标点
func getPoint():
	var random_point = Vector2(randi_range(pos_start.global_position.x, pos_end.global_position.x), randi_range(pos_start.global_position.y, pos_end.global_position.y))
	if [6,7,8,9,10].has(level):
		random_point = pos_level_5.global_position
	elif [11,12,13,14,15].has(level):
		var node = pos_level_11.get_child(randi()%pos_level_11.get_child_count())
		random_point = node.global_position
	return random_point

func _on_shop_body_entered(body: Node2D) -> void:
	if body is Player:
		shopBtn.visible = true

func _on_shop_body_exited(body: Node2D) -> void:
	if body is Player:
		shopBtn.visible = false

#进入地图
func _on_portal_move_in(next_area):
	if Utils.player.gun == null:
		Utils.showToast("PLEASE PURCHASE A WEAPON FIRST")
	else:
		Utils.player.global_position = next_area.global_position

#怪物死亡
func onMonsterDeath(monster_ins):
	level_info.kill += 1
	var ins = gold.instantiate()
	ins.global_position = monster_ins.global_position
	ins.setGiveCallBack(func onGive():
		level_info.gold += 1)
	monster_root.add_child(ins)
	kill_playr.play()
