extends CharacterBody2D
class_name Player
@onready var anim = $body/AnimatedSprite2D
@onready var body = $body
@onready var gun_root = $body/GunRoot
@onready var reward_root = $RewardRoot
@onready var dash_part = $body/DashParticles2D
const dash_obj = preload("res://game/hero/DashObj.tscn")
const level_up_effect = preload("res://game/hero/effect/LevelUpEffect.tscn")

var gun = null

var SPEED = 100.0
var is_run = false
var is_dead = false #是否死亡
var is_shoot = false #是否在射击
var is_hit = false
var is_knockback = false #后坐力
var knockback_speed = 0 #后坐力速度
var is_dash = false
var look_dir = null

func _init() -> void:
	PlayerData.onHpChange.connect(self.onHpChange)
	PlayerData.onPlayerResurrect.connect(self.onPlayerResurrect)
	Utils.onGameStart.connect(self.onGameStart)

func _ready():
	set_physics_process(false)
	set_process(false)
	PlayerData.onPlayerLevelChange.connect(self.onPlayerLevelChange)
	PlayerData.playerWeaponListChange.connect(self.playerWeaponListChange)
	Utils.player = self
	#PlayerData.add_attachment(preload("res://game/attachments/UniversalExtendedMagazines.tscn").instantiate())
	#PlayerData.add_attachment(preload("res://game/attachments/ExtendedRifleMagazine.tscn").instantiate())
	#PlayerData.add_attachment(preload("res://game/attachments/QuickExpansionMagazine.tscn").instantiate())
	#PlayerData.add_attachment(preload("res://game/attachments/ShotgunShellPouch.tscn").instantiate())
	#PlayerData.add_attachment(preload("res://game/attachments/SubmachineGunMagazine.tscn").instantiate())
	#PlayerData.add_attachment(preload("res://game/attachments/MachineGunMagazine.tscn").instantiate())

func updateHero():
	SPEED = 100 * PlayerData.player_speed

func onPlayerLevelChange(level):
	var ins = level_up_effect.instantiate()
	add_child(ins)

func onGameStart():
	set_physics_process(true)
	set_process(true)

func onPlayerResurrect():
	is_dead = false
	if anim:
		anim.play("idle")

func changeWeapon(weapon_id):
	for item in gun_root.get_children():
		item.set_use(item.name == str(weapon_id))

func playerWeaponListChange():
	for weapon_id in PlayerData.player_weapon_list:
		if !gun_root.has_node(str(weapon_id)):
			var local_gun = PlayerData.player_weapon_list[weapon_id] as BaseGun
			local_gun.name = str(weapon_id)
			gun_root.add_child(local_gun)
			local_gun.setOwner(self)
			if gun == null:
				gun = local_gun
				gun.set_use(true)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dash") && !is_dash:
		is_dash = true
		dash_part.emitting = true
		anim.play("dash")
		await get_tree().create_timer(0.06).timeout
		is_dash = false
		dash_part.emitting = false
		
func _physics_process(delta):
	if is_dead:
		return
	if Utils.freeze_frame:
		delta = 0.0
	var direction = Input.get_vector("left", "right", "up", "down")
	if is_knockback:
		if direction != Vector2.ZERO && SPEED < knockback_speed:
			velocity = (SPEED - knockback_speed) * global_position.direction_to(get_global_mouse_position())
		else:
			velocity = -knockback_speed * global_position.direction_to(get_global_mouse_position())
	else:
		velocity = direction * SPEED
	if is_dash:
		velocity = direction * 600
	move_and_slide()
	changeAnim(direction)
	$PointLight2D2.look_at(get_global_mouse_position())
	if gun:
		gun.look_at(get_global_mouse_position())
		setGunLookat(get_global_mouse_position())

func set_knockback(knockback_speed):
	self.knockback_speed = knockback_speed
	is_knockback = true
	await get_tree().create_timer(0.05).timeout.connect(func timeout():
		is_knockback = false;self.knockback_speed = 0)

func setGunLookat(dir):
	if dir != null:
		look_dir = gun.global_position + (dir * 1000)
		if dir.x > position.x && body.scale.x != 1:
			body.scale.x = 1
		elif dir.x < position.x && body.scale.x != -1:
			body.scale.x = -1
	else:
		look_dir = null

func changeAnim(direction):
	if is_dash:
		showDash()
		return
	if direction != Vector2.ZERO:
		is_run = true
		if (direction.x > 0 && body.scale.x != 1) || (direction.x < 0 && body.scale.x != -1):
			animPlay("run_back",-1.0,true)
		else:
			animPlay("run")
	else:
		is_run = false
		animPlay("idle")
	gunAnim()

func animPlay(anim_name,speed = 1.0,is_back = false):
	if anim.animation != anim_name:
		anim.play(anim_name,speed,is_back)

func gunAnim():
	if is_shoot:
		pass
	if is_run:
		$GPUParticles2D.emitting = true
		#gun_player.play("run")
	elif !is_run:
		#gun_player.stop()
		$GPUParticles2D.emitting = false

func onHit(hurt):
	var nodes = get_tree().get_nodes_in_group("reward")
	var temp_hurt = 0
	for node in nodes:
		if node.connect_beforePlayerHit:
			var num = node.call("beforePlayerHit",hurt)
			temp_hurt += num
	hurt += temp_hurt
	if hurt < 1:
		hurt = 1
	PlayerData.player_hp -= hurt
	Utils.showHitLabel(hurt,self)
	get_tree().call_group("control","hit")
	#Utils.freeze_frame = true
	Utils.freezeFrame(0.1)
	for node in nodes:
		if node.connect_afterPlayerHit:
			node.call("afterPlayerHit",hurt)

func onHpChange(hp,max_hp):
	if hp <= 0:
		is_dead = true
		anim.play("die")

func cameraSnake(step):
	get_tree().call_group("camera","shootShake",step)

func showDash():
	var dash = dash_obj.instantiate()
	dash.texture = anim.sprite_frames.get_frame_texture(anim.animation,anim.frame)
	dash.global_position = global_position
	dash.flip_h = body.scale.x != 1
	get_tree().root.call_deferred("add_child",dash)

func addEquip(equip):
	if $EquipRoot.get_child_count() > 0:
		var child = $EquipRoot.get_child(0)
		$EquipRoot.remove_child(child)
		EquipServer.addEquipOnFloor(child,global_position)
	$EquipRoot.add_child(equip)
