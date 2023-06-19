extends BaseMonster

func _ready():
	super._ready()
	target_player = PlayerServer.player_scene
	anim.play("idle")

func _physics_process(delta):
	super._physics_process(delta)
	if velocity != Vector2.ZERO:
		anim.play("run")
		if velocity.x > 0:
			flip_h(false)
		elif velocity.x < 0 && scale.x == 1:
			flip_h(true)
	else:
		anim.play("idle")
