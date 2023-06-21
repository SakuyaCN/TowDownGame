extends Panel

signal onSelected()

var reward:BaseReward

var is_select = false

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



func _on_button_pressed() -> void:
	is_select = true
	RewardServer.addReward(reward)
	emit_signal("onSelected")

func _exit_tree() -> void:
	if reward && !is_select:
		reward.queue_free()
		print("free")
