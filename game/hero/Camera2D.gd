extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shootShake(_step):
	get_tree().create_tween().tween_property(self,"offset",Vector2.ZERO,0.1).from(_step)