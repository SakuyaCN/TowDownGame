extends BaseReward

func onRewardStart():
	PlayerData.player_hp_max += 3

func onRewardRemove():
	PlayerData.player_hp_max -= 3
