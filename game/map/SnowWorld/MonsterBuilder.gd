extends Node2D

const monster_pre = preload("res://game/monster/Ghoul/Ghoul.tscn")

var land_array :Array[Vector2i]
var global_array : Array[Vector2]
var rect:Rect2i
var monsterRoot:Node2D
var land:TileMap:
	set(value):
		land = value
		land_array = land.get_used_cells(0)
		for vect in land_array:
			global_array.append(land.map_to_local(vect))
var distanceThreshold: float = 200#安全距离
var time = 0 #生存时间
var create_count = 1 #单次创建数量
var level = 0 :#怪物实力等级
	set(value):
		level = value
		Utils.showToast(tr("MONSTER_LEVEL_UP"))
		if level == 1:
			create_count += 1
		if level == 3:
			create_count += 1

var level_data = [
	{"hp":2,"speed":45,"hurt":1},
	{"hp":3,"speed":45,"hurt":2},
	{"hp":5,"speed":45,"hurt":3},
	{"hp":7,"speed":45,"hurt":4},
	{"hp":9,"speed":45,"hurt":4},
	{"hp":12,"speed":45,"hurt":4},
	{"hp":15,"speed":45,"hurt":4},
	{"hp":18,"speed":45,"hurt":4}
]

signal onTimeTick(time)

func start() -> void:
	$Timer.start()

#创建一个怪物
func createMonster(monster):
	var ins = monster.instantiate()
	ins.setData(level_data[level])
	var pos = getPosition()
	if pos:
		ins.global_position = pos
		monsterRoot.add_child(ins)
	else:
		ins.queue_free()

func getPosition():
	var next_point = global_array[randi()%global_array.size()] * 0.3
	if Utils.player.global_position.distance_to(next_point) < distanceThreshold:
		getPosition()
	elif next_point:
		return next_point

func _on_timer_timeout() -> void:
	time += 5
	if time % 60 == 0 && level < 10:
		level += 1
	emit_signal("onTimeTick",time)
	call_deferred("spawnMonster")

func spawnMonster():
	for i in create_count:
		createMonster(monster_pre)
		await get_tree().create_timer(1 / create_count).timeout
