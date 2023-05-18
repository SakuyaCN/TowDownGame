extends BaseReward

var mark_dict = { #怪物标记
}

func afterAtk(monster:BaseMonster,hit_num):#怪物收到伤害后触发
	if mark_dict.has(monster.name):
		mark_dict[monster.name] += 1
	else:
		mark_dict[monster.name] = 1
	if mark_dict[monster.name] == 3:
		mark_dict[monster.name] = 0
		doBoom(monster)

func onKill(monster:BaseMonster): #击杀后触发
	if mark_dict.has(monster.name):
		mark_dict.erase(monster.name)

func doBoom(monster:BaseMonster):
	var hurt = count * 5
	monster.onHit(hurt,false)
	Utils.showHitLabelMore(hurt,monster,Vector2(0,-5),Color.TOMATO)
