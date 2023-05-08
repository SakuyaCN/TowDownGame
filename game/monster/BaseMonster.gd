extends CharacterBody2D
class_name BaseMonster

@export var SPEED = 50.0
@export var hurt = 1
@export var HP = 5
@export var knockback_def = 5 #击退抵抗
var movement_delta: float
var navigationAgent2D := NavigationAgent2D.new()
var audio_hit = AudioStreamPlayer2D.new()
@onready var sprite_body = get_node("body")
@onready var anim :AnimatedSprite2D = get_node("body/AnimatedSprite2D")

var hit = false
var is_die = false
var is_flip

func _ready():
	print(SPEED)
	audio_hit.stream = load("res://audio/body_hit_finisher_52.wav")
	add_child(audio_hit)
	add_child(navigationAgent2D)
	#navigationAgent2D.navigation_finished.connect(self._navigation_finished)
	#navigationAgent2D.target_reached.connect(self._target_reached)
	navigationAgent2D.velocity_computed.connect(self._on_velocity_computed)
	navigationAgent2D.avoidance_enabled = true

func _physics_process(delta):
	if Engine.get_physics_frames() % 60 :
		navigationAgent2D.set_target_position(Utils.player.global_position)
	if hit:
		move_and_slide()
	elif navigationAgent2D.is_inside_tree() && !navigationAgent2D.is_navigation_finished():
		var next_path_position = navigationAgent2D.get_next_path_position()
		var current_agent_position: Vector2 = global_position
		var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * SPEED
		if navigationAgent2D.avoidance_enabled:
			navigationAgent2D.set_velocity(new_velocity)
		else:
			_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func flip_h(flip:bool):
	if is_flip == flip:
		return
	is_flip = flip
	var x_axis = sprite_body.global_transform.x
	sprite_body.global_transform.x.x = (-1 if flip else 1) * abs(x_axis.x)

func hitFlash(collisionResult,bullet:Bullet):
	if is_die:
		return
	Utils.freezeFrame(bullet.gun.time_scale)
	onHit(bullet.hurt)
	audio_hit.play(0.17)
	Utils.showHitLabel(bullet.hurt,self)
	var speed = bullet.knockback_speed - knockback_def
	if speed > 0:
		velocity = -(global_position.direction_to(Utils.player.global_position)) * speed
		hit = true
	#var materialFlash = ShaderMaterial.new()
	#materialFlash.shader = load("res://shader/Monster1.gdshader")
	#sprite_body.get_node("AnimatedSprite2D").material = materialFlash
	await get_tree().create_timer(bullet.knockback_time).timeout.connect(func timeout():
		sprite_body.get_node("AnimatedSprite2D").material = null; hit = false )

func onHit(hit_num):
	HP -= hit_num
	if HP <= 0:
		onDie()

func onDie():
	is_die = true
	set_physics_process(false)
	get_node("CollisionShape2D").call_deferred("set_disabled",true)
	anim.play("die")
	get_tree().create_tween().tween_property(get_node("UndeadShadow"),"scale",Vector2.ZERO,0.3)
	await anim.animation_finished
	queue_free()
	
