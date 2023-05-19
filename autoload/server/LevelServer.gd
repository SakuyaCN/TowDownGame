extends Node
##======关卡等级全局管理=========

const score_board = preload("res://ui/widgets/Scoreboard.tscn")
#节点
var timer = Timer.new()

#属性
var level = 1 #当前关卡等级
var level_time = 0 #当前关卡持续时间
var wait_time = 1 #怪物生成间隔
var wait_time_temp = 0 #怪物生成间隔

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
	"16" = 50,
	"17" = 50,
	"18" = 50,
	"19" = 50,
	"20" = 50,
	"21" = 60,
	"22" = 60,
	"23" = 60,
	"24" = 60,
	"25" = 60,
	"26" = 90,
	"27" = 90,
	"28" = 90,
	"29" = 90,
	"30" = 90
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
	"15" = {'speed' = 100,'hp' = 9,'hurt' = 4},
	"16" = {'speed' = 80,'hp' = 10,'hurt' = 5},
	"17" = {'speed' = 80,'hp' = 10,'hurt' = 5},
	"18" = {'speed' = 80,'hp' = 11,'hurt' = 5},
	"19" = {'speed' = 80,'hp' = 11,'hurt' = 6},
	"20" = {'speed' = 80,'hp' = 12,'hurt' = 6},
	"21" = {'speed' = 150,'hp' = 12,'hurt' = 6},
	"22" = {'speed' = 150,'hp' = 13,'hurt' = 7},
	"23" = {'speed' = 150,'hp' = 13,'hurt' = 7},
	"24" = {'speed' = 150,'hp' = 14,'hurt' = 7},
	"25" = {'speed' = 150,'hp' = 14,'hurt' = 8},
	"26" = {'speed' = 100,'hp' = 15,'hurt' = 8},
	"27" = {'speed' = 100,'hp' = 15,'hurt' = 8},
	"28" = {'speed' = 100,'hp' = 15,'hurt' = 9},
	"29" = {'speed' = 100,'hp' = 16,'hurt' = 9},
	"30" = {'speed' = 100,'hp' = 16,'hurt' = 9}
}

var level_info = {
	time = 0,
	kill = 0,
	gold = 0
}

signal onTimeTick() #时间流逝
signal onRoundStart() #回合开始
signal onRoundEnd() #回合结束
signal roundVictory() #回合胜利
signal monsterCreate() #怪物生成
signal onNextLevel(level) #下一关

func _ready() -> void:
	timer.wait_time = 0.1
	timer.timeout.connect(self._timeout)
	add_child(timer)

func roundStart():
	if level > 30:
		Utils.showToast("GAME_SUCCESS")
		return
	resetLevelInfo()
	level_time = time_dict[str(level)]
	timerStart()
	emit_signal("onRoundStart")

func resetLevelInfo(): #重置关卡累计信息
	level_info = {
		time = 0,
		kill = 0,
		gold = 0
	}

func getLevelMonsterData(): #读取当前关卡怪物信息
	return monster_attr[str(level)]

func timerStart(): #开始计时
	isPause(false)
	timer.start()

func timerStop(): #结束计时
	timer.stop()

func isPause(is_pause): #暂停
	timer.paused = is_pause

func _timeout():
	level_time -= 0.1
	level_info.time += 0.1
	if level_time <= 0:
		timerStop()
		victory()
		emit_signal("onRoundEnd")
	else:
		onMonsterCreate()
		emit_signal("onTimeTick",int(level_time))

func onMonsterCreate():
	wait_time_temp += 0.1
	if wait_time_temp >= wait_time:
		wait_time_temp = 0
		emit_signal("monsterCreate")

func victory():
	if level == 30:
		Utils.showToast("GAME_SUCCESS")
	emit_signal("roundVictory")
	level += 5
	PlayerData.reward_point += 1
	_onNextLevel()
	#emit_signal("roundVictory")

func _onNextLevel():
	emit_signal("onNextLevel",level)
	if [1,2,3,4,5].has(level):
		LevelServer.wait_time = 0.7
	elif [6,7,8,9,10].has(level):
		LevelServer.wait_time = 0.4
	elif [11,12,13,14,15].has(level):
		LevelServer.wait_time = 0.6
	elif [16,17,18,19,20].has(level):
		LevelServer.wait_time = 0.5
	elif [21,22,23,24,25].has(level):
		LevelServer.wait_time = 0.4
	elif [26,27,28,29,30].has(level):
		LevelServer.wait_time = 0.5

func getScoreboard():
	var score_board_ins = score_board.instantiate()
	score_board_ins.setData(level_info)
	return score_board_ins
