extends Node2D

@onready var builder = $MonsterBuilder
@onready var land = $Land

func _init() -> void:
	Utils.onGameStart.connect(self.onGameStart)

func _ready() -> void:
	$MonsterBuilder.land = land
	$MonsterBuilder.monsterRoot = $MonsterRoot
	$CanvasLayer.onMonsterJoin.connect(self.onMonsterJoin)
	PlayerServer.addPlayerToScene($PlayerRoot)
	PlayerServer.setPlayerPosition($CreatePosition.global_position)
	Utils.gameStart()
	Utils.crosshairChange(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func onGameStart():
	$ControlUI.visible = true
	$CanvasLayer/Panel.visible = true
	PlayerData.player_ammo = 9999999
	var gun = Utils.weapon_list['0']
	PlayerData.add_weapon(gun.instantiate())
	await get_tree().create_timer(0.7).timeout
	create_tween().tween_property($PlayerRoot/Anchor/Camera2D/PointLight2D,"texture_scale",0.8,1)
	
func onMonsterJoin():
	Utils.crosshairChange(true)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	builder.start()
	
	EquipServer.addEquipOnFloor(preload("res://game/equip/High-Energy Particle Cannon.tscn").instantiate(),Utils.player.global_position)
	EquipServer.addEquipOnFloor(preload("res://game/equip/Flamethrower.tscn").instantiate(),Utils.player.global_position+ Vector2(20,20))

func addEffectNode(node):
	$EffectRoot.add_child(node)

func addEquip(ins):
	$EquipRoot.add_child(ins)
