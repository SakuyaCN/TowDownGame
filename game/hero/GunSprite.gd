extends Node2D

const particles_pre = preload("res://game/hero/gpu_particles_2d.tscn")

@export var bullet_scene : PackedScene
@export var fire_rate = 5.0
@export var can_shoot = true
@export var recoil_duration = 0.2

@onready var audio = $AudioStreamPlayer2D
@onready var timer = $shoot_timer
var tween:Tween
var player:Player

func _ready():
	timer.wait_time = 1.0 / fire_rate

func setOwner(player):
	self.player = player

func _process(delta):
	if Input.is_action_pressed("shoot") and can_shoot:
		_shoot()

func _shoot():
	var b = bullet_scene.instantiate()
	b.setOnwer(player)
	get_tree().root.add_child(b)
	b.start(global_position,get_global_mouse_position())
	
	call_deferred("_shootAnim")
	can_shoot = false
	timer.start()

func _shootAnim():
	audio.play()
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "position", position, timer.wait_time).from(position + Vector2(-1, -1))
	tween.tween_property($Sprite2D, "scale", Vector2(1,1), timer.wait_time).from(Vector2(0.5, 1.1))
	add_child(particles_pre.instantiate())
	player.cameraSnake()

func _on_timer_timeout():
	can_shoot = true
