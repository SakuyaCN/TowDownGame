extends BaseReward

func beforeAtk(monster:BaseMonster,hit_num):#怪物收到伤害前触发
		if randi()%100 < (10 * count):
			return hit_num
		return 0
