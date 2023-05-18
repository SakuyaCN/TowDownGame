extends BaseReward

const hp_pack = preload("res://game/items/HpPack.tscn")

func onKill(monster:BaseMonster):
	if randi()% 100 < 20:
		var ins = hp_pack.instantiate()
		ins.hp = count
		ins.global_position = monster.global_position
		monster.get_parent().add_child(ins)
