extends Node2D

var hp = 0

func _ready() -> void:
	global_position += Vector2(randf_range(-5,5),randf_range(-5,5))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		PlayerData.addPlayerHp(hp)
		Utils.showHitLabelMore("+%s"%hp,body,Vector2(0,2),Color.SPRING_GREEN)
		queue_free()
