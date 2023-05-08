extends Node2D
class_name BaseGun

const particles_pre = preload("res://game/hero/gpu_particles_2d.tscn")

@export var bullet_scene : PackedScene
@export var fire_rate = 5.0
@export var can_shoot = true
@export var recoil_duration = 0.2
@export var knockback_speed = 50
@export var knockback_time = 0.1
@export var time_scale = 0.1
@export var freeze_frame = 3
@export var shake_vector = Vector2.ZERO

@onready var gun_tip = $GunTip
@onready var audio = $AudioStreamPlayer2D
@onready var timer = $shoot_timer

var tween:Tween
var direction:Vector2
var player:Player

func fire(bullet):
	bullet.knockback_speed = knockback_speed
	bullet.knockback_time = knockback_time
	bullet.gun = self
	bullet.fire()

func _physics_process(delta):
	if Utils.freeze_frame:
		delta = 0.0
	if Utils.freeze_frame && Engine.get_physics_frames() % freeze_frame == 0:
		# 暂停一帧
		Utils.freeze_frame = false
		# 将时间比例设置为1
		Engine.time_scale = 1
		return

func _shootAnim():
	player.cameraSnake(shake_vector * direction)

func _process(delta):
	if Utils.freeze_frame:
		delta = 0.0
	var mouse_pos = get_global_mouse_position()
	direction = (mouse_pos - gun_tip.global_position).normalized()
