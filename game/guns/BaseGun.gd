extends Node2D
class_name BaseGun

const particles_pre = preload("res://game/hero/gpu_particles_2d.tscn")

@export var weapon_id = 0
@export var image:Texture
@export var weapon_name:String = "Gun"
@export var bullet_scene : PackedScene
@export var damage = 1
@export var bullet_speed = 200
@export var fire_rate = 5.0
@export var recoil_duration = 0.2
@export var knockback_speed = 50
@export var knockback_time = 0.1
@export var time_scale = 0.1
@export var freeze_frame = 3
@export var recoil = 0
@export var shake_vector = Vector2.ZERO


@onready var gun_tip = $GunTip
@onready var audio = $AudioStreamPlayer2D
@onready var timer = $shoot_timer
@onready var gun_image = $Sprite2D

var tween:Tween
var direction:Vector2
var player:Player
var is_use = false
var can_shoot = true

func _ready() -> void:
	gun_image.texture = image
	set_use(false)
	timer.wait_time = 1.0 / fire_rate

func setOwner(player):
	self.player = player

func _process(delta):
	if Utils.freeze_frame:
		delta = 0.0
	var mouse_pos = get_global_mouse_position()
	direction = (mouse_pos - gun_tip.global_position).normalized()
	if OS.get_name() == "Windows" && Input.is_action_pressed("shoot") and can_shoot:
		_shoot()
	elif OS.get_name() != "Windows" && player.look_dir != null and can_shoot:
		_shoot()

func set_use(use:bool):
	is_use = use
	set_physics_process(is_use)
	set_process(is_use)
	visible = is_use
	if player && is_use:
		player.gun = self
	PlayerData.emit_signal("onWeaponChanged")

func fire(bullet:Bullet,is_bullet = true):
	bullet.speed = bullet_speed
	bullet.hurt = damage
	bullet.knockback_speed = knockback_speed
	bullet.knockback_time = knockback_time
	bullet.gun = self
	if is_bullet:
		bullet.fire()
	
	if recoil > 0 && is_bullet:
		player.set_knockback(recoil)

func _physics_process(delta):
	if Utils.freeze_frame:
		delta = 0.0
	if Utils.freeze_frame && Engine.get_physics_frames() % freeze_frame == 0:
		# 暂停一帧
		Utils.freeze_frame = false
		# 将时间比例设置为1
		Engine.time_scale = 1
		return

func _shoot() -> void:
	pass

func _shootAnim():
	player.cameraSnake(shake_vector * direction)
	var ins = particles_pre.instantiate()
	ins.position = gun_tip.position
	add_child(ins)
