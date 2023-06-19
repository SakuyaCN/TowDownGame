extends Node2D

const monster = preload("res://game/monster/Ghoul/Ghoul.tscn")

func _init() -> void:
	Utils.onGameStart.connect(self.onGameStart)

func _ready() -> void:
	PlayerServer.addPlayerToScene($TileMap/PlayerRoot)
	PlayerServer.setPlayerPosition($CreatePosition.global_position)
	Utils.gameStart()

func onGameStart():
	PlayerData.player_ammo = 9999999
	var gun = Utils.weapon_list['1']
	PlayerData.add_weapon(gun.instantiate())
	await get_tree().create_timer(1).timeout
	create_tween().tween_property($TileMap/PlayerRoot/Anchor/Camera2D,"zoom",Vector2(0.8,0.8),0.5)

func _on_timer_timeout() -> void:
	var ins = monster.instantiate()
	$TileMap/MonsterRoot.add_child(ins)
