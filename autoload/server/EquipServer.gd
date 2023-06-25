extends Node

const equip_touch_pre = preload("res://game/equip/EquipOnFloor.tscn")

signal onEquipAdd(ins)
signal onEquipRemove(ins)

func addEquipOnFloor(equip:BaseEquip,position:Vector2):
	var ins = equip_touch_pre.instantiate()
	ins.global_position = position
	ins.equip = equip
	get_tree().call_group("world","addEquip",ins)

func addEquipToPlayer(equip:BaseEquip):
	Utils.player.addEquip(equip)

func addUI(ins):
	emit_signal("onEquipAdd",ins)

func removeUI(ins):
	emit_signal("onEquipRemove",ins)
