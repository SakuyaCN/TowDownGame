extends Control

var click:Callable

func _enter_tree() -> void:
	get_tree().paused = true

func setOnClick(callback:Callable):
	click = callback

func _on_button_pressed() -> void:
	get_tree().paused = false
	if PlayerData.gold >= 50:
		PlayerData.gold -= 50
		click.call(true)
	else:
		click.call(false)
		Utils.showToast("BUY_ERROR")
	queue_free()


func _on_button_2_pressed() -> void:
	get_tree().paused = false
	click.call(false)
	queue_free()
