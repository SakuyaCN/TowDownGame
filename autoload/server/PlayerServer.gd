extends Node

const player_node = preload("res://game/hero/Hero.tscn")

var player_scene : Player = null

func addPlayerToScene(sence:Node2D):
	if player_scene == null:
		player_scene = player_node.instantiate()
	if  player_scene.is_inside_tree():
		player_scene.get_parent().remove_child(player_scene)
	sence.add_child(player_scene)

func setPlayerPosition(position):
	if player_scene:
		player_scene.global_position = position
