extends CharacterBody2D
class_name Player
@onready var anim = $body/AnimatedSprite2D
@onready var body = $body
@onready var gun = $body/GunSprite
@onready var gun_player = $body/GunSprite/AnimationPlayer
@onready var camera = $Camera2D

const SPEED = 100.0
var is_run = false
var is_shoot = false #是否在射击

func _ready():
	Utils.player = self
	gun.setOwner(self)

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	gun.look_at(get_global_mouse_position())
	move_and_slide()
	changeAnim()

func changeAnim():
	if velocity != Vector2.ZERO:
		is_run = true
		if velocity.y != 0:
			if velocity.y < 0:
				#gun.z_index = -1
				anim.play("run_top")
			if velocity.y > 0:
				anim.play("run_down")
		else:
			if (velocity.x > 0 && body.scale.x != 1) || (velocity.x < 0 && body.scale.x != -1):
				anim.play_backwards("run")
			else:
				anim.play("run")
	else:
		is_run = false
		anim.play("idle")
	if get_global_mouse_position().x > position.x && body.scale.x != 1:
		body.scale.x = 1
	elif get_global_mouse_position().x < position.x && body.scale.x != -1:
		body.scale.x = -1
	gunAnim()

func gunAnim():
	if is_shoot:
		pass
	if is_run && !gun_player.is_playing():
		gun_player.play("run")
	elif !is_run && gun_player.is_playing():
		gun_player.stop()

func cameraSnake():
	camera.shootShake(Vector2(1,1))
