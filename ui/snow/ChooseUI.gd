extends Panel

signal onSelected()

var reward:BaseReward

@onready var title = $Label
@onready var texture = $TextureRect
@onready var info = $Label2

func _ready() -> void:
	pass # Replace with function body.

func setData(pre):
	reward = pre.instantiate()
	title.text = tr(reward.reward_name)
	texture.texture = reward.reward_image
	info.text = tr(reward.reward_info)
