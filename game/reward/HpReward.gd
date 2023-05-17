extends BaseReward

func onRewardStart():
	PlayerData.resurrectPlayer(PlayerData.player_hp_max)

func beforePlayerHit(hit_num):
	hit_num *= 0.2
	return -hit_num
