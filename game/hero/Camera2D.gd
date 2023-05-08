extends Camera2D

var is_shake = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shootShake(_step):
	if is_shake:
		return
	is_shake = true
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self,"offset",_step,0.1)
	tween.tween_property(self,"offset",Vector2.ZERO,0.1)
	tween.tween_callback(func end():
		is_shake = false)
