extends RigidBody2D

var spin_speed = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spin_speed = randi_range(-15,15)

func start(start):
	apply_impulse(-(start + Vector2(0,200)) )

func _physics_process(delta: float) -> void:
	rotation += spin_speed * delta

func _on_timer_timeout() -> void:
	queue_free()
