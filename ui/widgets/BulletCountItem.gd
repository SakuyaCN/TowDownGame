extends TextureRect

func destory():
	#var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	#tween.tween_property(self,"global_position:y",global_position.y-10,0.2)
	#tween.tween_callback(self.queue_free).set_delay(0.2)
	queue_free()
