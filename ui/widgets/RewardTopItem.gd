extends TextureRect

func setData(rw:BaseReward):
	texture = rw.reward_image
	$Label.text = str(rw.count)
