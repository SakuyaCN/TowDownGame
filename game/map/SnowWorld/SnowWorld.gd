extends Node2D

const monster = preload("res://game/monster/Ghoul/Ghoul.tscn")

func _init() -> void:
	Utils.onGameStart.connect(self.onGameStart)

func _ready() -> void:
	PlayerServer.addPlayerToScene($PlayerRoot)
	PlayerServer.setPlayerPosition($CreatePosition.global_position)
	Utils.gameStart()

func onGameStart():
	PlayerData.player_ammo = 9999999
	var gun = Utils.weapon_list['1']
	PlayerData.add_weapon(gun.instantiate())
	await get_tree().create_timer(0.7).timeout
	create_tween().tween_property($PlayerRoot/Anchor/Camera2D/PointLight2D,"texture_scale",0.8,1)
	
func _on_timer_timeout() -> void:
	var ins = monster.instantiate()
	$MonsterRoot.add_child(ins)
