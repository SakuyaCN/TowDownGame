extends Control

@onready var image = $TextureRect
@onready var rw_name = $Label
var id
var ins:BaseReward

signal onMouseIn(info)
signal onClick(id)

func _ready() -> void:
	create_tween().tween_property(self,"scale",Vector2(1,1),0.2).from(Vector2(0,0))

func setData(id):
	self.id = id
	ins = RewardServer.reward_list[id].instantiate()
	image.texture = ins.reward_image
	rw_name.text = ins.reward_name

func _exit_tree() -> void:
	if ins:
		ins.queue_free()

func _on_button_pressed() -> void:
	emit_signal("onClick",id)

func _on_button_mouse_entered() -> void:
	if ins:
		emit_signal("onMouseIn",ins.reward_info)
