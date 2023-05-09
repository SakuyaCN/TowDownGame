extends Control

const weapon_item_pre = preload("res://ui/widgets/WeaponListItem.tscn")

@onready var weapon_lsit_node = $HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerData.playerWeaponListChange.connect(self.playerWeaponListChange)


func playerWeaponListChange():
	for item in PlayerData.player_weapon_list:
		if !weapon_lsit_node.has_node(str(item)):
			var ins = weapon_item_pre.instantiate()
			ins.name = str(item)
			ins.local_id = item
			weapon_lsit_node.add_child(ins)
