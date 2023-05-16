extends "res://game/items/BaseItem.gd"
#金币
func _ready():
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self,"scale",Vector2(1,1),0.3).from(Vector2.ZERO)

func _on_area_2d_body_entered(body):
	if body is Player:
		if giveCallBack:
			giveCallBack.call()
		PlayerData.gold += 1
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel(true)
		tween.tween_property(self,"position:y",position.y - 20,0.3)
		tween.tween_property(self,"modulate:a",0.0,0.3)
		tween.tween_callback(self.queue_free).set_delay(0.3)
		Utils.showHitLabel("+1",body)
