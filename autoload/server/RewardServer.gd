extends Node
##======奖励全局管理=========

signal onRewardAdd(rw:BaseReward) #获得一个奖励
signal onRewardRemove(rw:BaseReward) #移除一个奖励

func addReward(rw:BaseReward):
	if Utils.player:
		Utils.player.reward_root.add_child(rw)
		emit_signal("onRewardAdd",rw)

func removeReward(rw:BaseReward):
	if Utils.player:
		Utils.player.reward_root.remove_child(rw)
		emit_signal("onRewardRemove",rw)
		rw.queue_free()
