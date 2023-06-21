extends Node
##======奖励全局管理=========
signal onRewardAdd(rw:BaseReward) #获得一个奖励
signal onRewardRemove(rw:BaseReward) #移除一个奖励

var reward_list = {
	"0" = preload("res://game/reward/GoldReward.tscn"),
	"1" = preload("res://game/reward/HpReward.tscn"),
	"2" = preload("res://game/reward/AlienHelmentReward.tscn"),
	"3" = preload("res://game/reward/WarningShield.tscn"),
	"4" = preload("res://game/reward/BlueAxe.tscn"),
	"5" = preload("res://game/reward/BlueBoots.tscn"),
	"6" = preload("res://game/reward/AmberStar.tscn"),
	"7" = preload("res://game/reward/HeathPack.tscn"),
	"8" = preload("res://game/reward/AmberSickle.tscn"),
	"9" = preload("res://game/reward/Battery.tscn"),
	"10" = preload("res://game/reward/BlueBacteria.tscn"),
	"11" = preload("res://game/reward/BlueCircuit.tscn")
}

var reward_shop_list = []
var reward_max = 3

func getShopList(is_reload = false):
	if reward_shop_list.is_empty() || is_reload:
		reward_shop_list.clear()
		var keys = reward_list.keys()
		keys.shuffle()
		for i in reward_max:
			reward_shop_list.append(keys.pop_back())
	return reward_shop_list

func addReward(rw:BaseReward):
	if Utils.player:
		if Utils.player.reward_root.has_node(rw.reward_name):
			var node = Utils.player.reward_root.get_node(str(rw.reward_name))
			if node.count < node.max_count:
				node.count += 1
			emit_signal("onRewardAdd",node)
		else:
			rw.name = rw.reward_name
			Utils.player.reward_root.add_child(rw)
			emit_signal("onRewardAdd",rw)

func removeReward(rw:BaseReward):
	if Utils.player:
		Utils.player.reward_root.remove_child(rw)
		emit_signal("onRewardRemove",rw)
		rw.queue_free()
