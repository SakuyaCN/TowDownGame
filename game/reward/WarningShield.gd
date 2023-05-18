extends BaseReward

func beforePlayerHit(hit_num):#玩家收到伤害前触发
	if randi()%100 < (15 * count):
		hit_num = 1 - 1/(0.15 * count + 1)
		return snappedf(-hit_num,0.01)
	else:
		return 0
