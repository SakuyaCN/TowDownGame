extends Control

const pre = preload("res://ui/widgets/RewardShopItem.tscn")

@onready var list = $NinePatchRect/HBoxContainer
@onready var info_label = $NinePatchRect/Label3

func _ready() -> void:
	PlayerData.onRewardChange.connect(self.onRewardChange)
	loadList(false)
	onRewardChange(PlayerData.reward_point)

func onRewardChange(reward):
	$NinePatchRect/Label.text = tr("REMAINING REWARD POINTS") + str(reward)

func loadList(reload):
	for item in list.get_children():
		item.queue_free()
	for item in RewardServer.getShopList(reload):
		var ins = pre.instantiate()
		list.add_child(ins)
		ins.setData(item)
		ins.onClick.connect(self.onClick)
		ins.onMouseIn.connect(self.onMouseIn)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()

func onClick(id):
	if PlayerData.reward_point > 0:
		loadList(true)
		PlayerData.reward_point -= 1
		$AudioStreamPlayer2.play()
		RewardServer.addReward(RewardServer.reward_list[id].instantiate())
	else:
		Utils.showToast("NO POINTS")

func onMouseIn(info):
	info_label.text = tr(info)


func _on_button_2_pressed() -> void:
	if PlayerData.gold >= 10:
		$AudioStreamPlayer.play()
		PlayerData.gold -= 10
		loadList(true)
		

func _on_button_pressed() -> void:
	queue_free()
