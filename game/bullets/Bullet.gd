extends CharacterBody2D
class_name Bullet

@export var bullet_impact:PackedScene
@export var bullet_smoke:PackedScene

@export var hurt = 1
@export var speed = 200

var player:Player

var timer = Timer.new()

func _ready():
	add_child(timer)
	timer.timeout.connect(self._on_timer_timeout)
	timer.one_shot = true
	timer.start(0.05)
	z_index = 0

func setOnwer(player):
	self.player = player

func start(local:Vector2,pos:Vector2):
	global_position = local
	velocity = local.direction_to(pos)

func _process(delta):
	var collisionResult = move_and_collide(velocity * speed * delta)
	if collisionResult:
		var coller = collisionResult.get_collider()
		if coller is BaseMonsyer:
			coller.hitFlash()
			coller.position += collisionResult.get_remainder()
			player.cameraSnake()
		else:
			bulletSmoke(collisionResult)
		queue_free()

func _on_timer_timeout():
	z_index = 1

func bulletSmoke(collisionResult):
	var ins = bullet_smoke.instantiate()
	get_parent().add_child(ins)
	ins.global_position = collisionResult.get_position()
	ins.rotation = collisionResult.get_normal().angle()
	
	var imapct = bullet_impact.instantiate()
	get_parent().add_child(imapct)
	imapct.global_position = collisionResult.get_position()
	imapct.rotation = collisionResult.get_normal().angle()
