extends TextureRect

var velocity = Vector2.ZERO
var GRAVITY = 100
var speed = 5

func _ready() -> void:
	set_process(false)

func destory():
	reparent(get_parent().get_parent().get_parent())
	set_process(true)
	velocity = Vector2(-55,-100)
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"scale",Vector2(0.3,0.3),1)
	tween.tween_callback(self.queue_free)

func _process(delta: float) -> void:
	velocity.y += GRAVITY * delta * speed
	rotation += speed * delta
	position += velocity * delta
