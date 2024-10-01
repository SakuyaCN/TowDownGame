extends Node2D

@onready var pos_start = $TileMap2/Level_1/pos_start
@onready var pos_end = $TileMap2/Level_1/pos_end
@onready var pos_level_1 = $TileMap2/Level_1
@onready var pos_level_5 = $TileMap2/Level_5/pos_start
@onready var pos_level_11 = $TileMap2/Level_11
@onready var pos_level_16 = $TileMap2/Level_16
@onready var pos_level_21 = $TileMap2/Level_21
@onready var pos_level_26 = $TileMap2/Level_26
@onready var monster_root = $TileMap2/MonsterRoot
@onready var shopBtn = $CanvasLayer/openShop
@onready var kill_playr = $Kill
@onready var portal_start = $TileMap2/PortalRoot/Portal 
@onready var portal_lv1 = $TileMap2/PortalRoot/Portal2 
@onready var portal_lv5 = $TileMap2/PortalRoot/Portal3 
@onready var portal_lv11 = $TileMap2/PortalRoot/Portal4 
@onready var portal_lv16 = $TileMap2/PortalRoot/Portal5
@onready var portal_lv21 = $TileMap2/PortalRoot/Portal6
@onready var portal_lv26 = $TileMap2/PortalRoot/Portal7

const gold = preload("res://game/items/Gold.tscn")
const weapon_choose = preload("res://ui/widgets/WeaponChoose.tscn")
const monster_pre = preload("res://game/monster/Monster 2/Monster2.tscn")
const death_borad = preload("res://ui/widgets/DeathBoard.tscn")

func _ready():
	LevelServer.monsterCreate.connect(self.monsterCreate)
	LevelServer.roundVictory.connect(self.roundVictory)
	LevelServer.onTimeTick.connect(self.onTimeTick)
	LevelServer.onRoundStart.connect(self.onRoundStart)
	LevelServer.onRoundEnd.connect(self.onRoundEnd)
	LevelServer.onNextLevel.connect(self.onNextLevel)
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
	LevelServer.isPause(true)
	var ins = death_borad.instantiate()
	ins.setOnClick(func callback(success):
		if success:
			LevelServer.isPause(false)
			PlayerData.resurrectPlayer(PlayerData.player_hp_max, 100)
		else:
			PlayerData.resurrectPlayer(1, 20)
			onRoundEnd()
		)
	$CanvasLayer.add_child(ins)

func _on_portal_2_move_out() -> void:
	LevelServer.roundStart()

func onTimeTick(timeout) -> void:
	if Utils.player.is_dead == false:
		$CanvasLayer/timeout.text =tr("REMAINING TIME") + str(timeout)

#回合开始
func onRoundStart():
	Utils.showToast("START_TIP",2)
	$CanvasLayer/timeout.visible = true
	$CanvasLayer/level.visible = true
	$CanvasLayer/level.text = tr("DIFFICULTY LEVEL") + " " + str(LevelServer.level)

#回合结束
func onRoundEnd():
	Utils.player.global_position = $PositionHome.global_position
	$CanvasLayer/timeout.text =tr("REMAINING TIME")
	for item in monster_root.get_children():
		item.queue_free()
	await get_tree().create_timer(1).timeout
	for item in $TileMap2/PortalRoot.get_children():
		item.reset()

#回合胜利
func roundVictory():
	Utils.showToast("VICTORY IN THE ROUND",1)
	$CanvasLayer.add_child(LevelServer.getScoreboard())

#获取坐标点
func getPoint():
	var random_point
	if [1,2,3,4,5].has(LevelServer.level):
		var node = pos_level_1.get_child(randi()%pos_level_1.get_child_count())
		random_point = node.global_position
	elif [6,7,8,9,10].has(LevelServer.level):
		random_point = pos_level_5.global_position
	elif [11,12,13,14,15].has(LevelServer.level):
		var node = pos_level_11.get_child(randi()%pos_level_11.get_child_count())
		random_point = node.global_position
	elif [16,17,18,19,20].has(LevelServer.level):
		var node = pos_level_16.get_child(randi()%pos_level_16.get_child_count())
		random_point = node.global_position
	elif [21,22,23,24,25].has(LevelServer.level):
		var node = pos_level_21.get_child(randi()%pos_level_21.get_child_count())
		random_point = node.global_position
	elif [26,27,28,29,30].has(LevelServer.level):
		var node = pos_level_26.get_child(randi()%pos_level_26.get_child_count())
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

#下一关通知
func onNextLevel(level):
	if [1,2,3,4,5].has(LevelServer.level):
		portal_start.next_area = portal_lv1
	elif [6,7,8,9,10].has(LevelServer.level):
		portal_start.next_area = portal_lv5
	elif [11,12,13,14,15].has(LevelServer.level):
		portal_start.next_area = portal_lv11
	elif [16,17,18,19,20].has(LevelServer.level):
		portal_start.next_area = portal_lv16
	elif [21,22,23,24,25].has(LevelServer.level):
		portal_start.next_area = portal_lv21
	elif [26,27,28,29,30].has(LevelServer.level):
		portal_start.next_area = portal_lv26

#怪物生成
func monsterCreate():
	var ins = monster_pre.instantiate()
	ins.global_position = getPoint()
	ins.setData(LevelServer.getLevelMonsterData())
	ins.setDeathCallBack(self.onMonsterDeath)
	monster_root.add_child(ins)

#怪物死亡
func onMonsterDeath(monster_ins):
	LevelServer.level_info.kill += 1
	if randi() % 3 <= 1:
		var ins = gold.instantiate()
		ins.global_position = monster_ins.global_position
		ins.setGiveCallBack(func onGive():
			LevelServer.level_info.gold += 1)
		monster_root.add_child(ins)
	kill_playr.play()
