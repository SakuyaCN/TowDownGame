extends CharacterBody2D
class_name Player
@onready var anim = $body/AnimatedSprite2D
@onready var body = $body
@onready var gun_root = $body/GunRoot
@onready var light2d = $PointLight2D

var gun = null

const SPEED = 100.0
var is_run = false
var is_shoot = false #是否在射击
var is_knockback = false #后坐力
var knockback_speed = 0 #后坐力速度
var look_dir = null

func _ready():
	PlayerData.playerWeaponListChange.connect(self.playerWeaponListChange)
	Utils.player = self
	PlayerData.add_weapons(
		[
			Utils.weapon_list["7"].instantiate(),
			Utils.weapon_list["6"].instantiate(),
			Utils.weapon_list["5"].instantiate(),
			Utils.weapon_list["4"].instantiate(),
			Utils.weapon_list["3"].instantiate(),
			Utils.weapon_list["2"].instantiate(),
			#Utils.weapon_list["4"].instantiate()
		])

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

func _physics_process(delta):
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
	move_and_slide()
	changeAnim(direction)
	
	if gun && OS.get_name() != "Windows" && look_dir != null:
		gun.look_at(look_dir)
	else:
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
		

func cameraSnake(step):
	get_tree().call_group("camera","shootShake",step)
