extends CharacterBody2D
class_name BaseMonster

@export var is_boss = false
@export var SPEED = 50.0
@export var hurt = 1
@export var HP = 5
@export var knockback_def = 5 #击退抵抗
var movement_delta: float
var navigationAgent2D := NavigationAgent2D.new()
var audio_hit = AudioStreamPlayer2D.new()
@onready var sprite_body = get_node("body")
@onready var anim :AnimatedSprite2D = get_node("body/AnimatedSprite2D")

var target_player:Player = Utils.player
var state_array = []
var hit = false
var is_die = false
var is_flip
var is_atk = false

var death_callback :Callable

func _ready():
	var node = Node2D.new()
	node.name = "EffectRoot"
	add_child(node)
	name = str(Time.get_ticks_usec())
	audio_hit.stream = load("res://audio/body_hit_finisher_52.wav")
	add_child(audio_hit)

func setData(data):
	SPEED = data['speed']
	hurt = data['hurt']
	HP = data['hp']
	knockback_def = 5

func _physics_process(delta):
	if idle_frame_num > 0:
		Utils.showHitLabel(idle_frame_num,self)
		idle_frame_num = 0
	#if Engine.get_physics_frames() % 60 :
	if is_atk || is_die:
		return
	if hit:
		move_and_slide()
	elif target_player != null:
		var next_path_position = target_player.global_position
		#var next_path_position = navigationAgent2D.get_next_path_position()
		var current_agent_position: Vector2 = global_position
		var new_velocity: Vector2 = current_agent_position.direction_to(next_path_position) * SPEED
		_on_velocity_computed(new_velocity)

	if velocity != Vector2.ZERO:
		anim.play("run")
		if velocity.x > 0:
			flip_h(false)
		elif velocity.x < 0 && scale.x == 1:
			flip_h(true)
	else:
		anim.play("idle")

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	if state_array.has(Utils.STATE_TYPE.STUN):
		anim.play("idle")
		return
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
	var speed = bullet.knockback_speed - knockback_def
	if speed > 0:
		velocity = -(global_position.direction_to(Utils.player.global_position)) * speed
		hit = true
	#var materialFlash = ShaderMaterial.new()
	#materialFlash.shader = load("res://shader/Monster1.gdshader")
	#sprite_body.get_node("AnimatedSprite2D").material = materialFlash
	await get_tree().create_timer(bullet.knockback_time).timeout.connect(func timeout():
		sprite_body.get_node("AnimatedSprite2D").material = null; hit = false )

var idle_frame_num = 0
func onHit(hit_num,is_show_label = true,is_death_effect = true):
	if PlayerData.base_aim_enh > 0 && PlayerData.base_aim_enh > randi()%100:
		hit_num *= 1.5
	var nodes = get_tree().get_nodes_in_group("reward")
	var temp_hurt = 0
	for node in nodes:
		if node.connect_beforeAtk:
			var num = node.call("beforeAtk",self,hit_num)
			temp_hurt += num
	hit_num += temp_hurt
	hit_num = snapped(hit_num,0.01)
	if is_show_label:
		idle_frame_num += hit_num
	if HP:
		HP -= hit_num
		if HP <= 0:
			onDie(is_death_effect)
	for node in nodes:
		if node.connect_afterAtk:
			node.call("afterAtk",self,hit_num)

func onDie(is_death_effect = true):
	is_die = true
	PlayerData.player_exp += 1
	if death_callback:
		death_callback.call(self)
	var nodes = get_tree().get_nodes_in_group("reward")
	var temp_hurt = 0
	if is_death_effect:
		for node in nodes:
			if node.connect_kill:
				node.call("onKill",self)
	set_physics_process(false)
	for item in get_node("EffectRoot").get_children():
		item.queue_free()
	get_node("CollisionShape2D").call_deferred("set_disabled",true)
	anim.play("die")
	get_tree().create_tween().tween_property(get_node("UndeadShadow"),"scale",Vector2.ZERO,0.3)
	await anim.animation_finished
	queue_free()
	
func setDeathCallBack(death_callback:Callable):
	self.death_callback = death_callback

func addEffect(node):
	get_node("EffectRoot").add_child(node)
