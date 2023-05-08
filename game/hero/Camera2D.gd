extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shootShake(_step):
	get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).tween_property(self,"offset",Vector2.ZERO,0.2).from(_step)
