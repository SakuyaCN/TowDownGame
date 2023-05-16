extends Control

@onready var time = $Panel/TextureRect2/Label
@onready var kill = $Panel/TextureRect3/Label
@onready var gold = $Panel/TextureRect4/Label

var callback:Callable

func _enter_tree() -> void:
	Utils.crosshairChange(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _exit_tree() -> void:
	Utils.crosshairChange(true)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func setData(data):
	time.text += " %s" %data["time"]
	kill.text += " %s" %data["kill"]
	gold.text += " %s" %data["gold"]

func setCallBack(callback:Callable):
	self.callback = callback

func _on_button_pressed() -> void:
	callback.call()
	queue_free()



