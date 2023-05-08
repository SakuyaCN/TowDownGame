extends Node

const hitlabel = preload("res://ui/widgets/HitLabel.tscn")

var player:Player

func showHitLabel(num,traget:Node2D):
	var ins = hitlabel.instantiate()
	ins.setNumber(num)
	traget.add_child(ins)
