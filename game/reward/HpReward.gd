extends BaseReward

func onRewardStart():
	PlayerData.resurrectPlayer(PlayerData.player_hp_max, 100)
