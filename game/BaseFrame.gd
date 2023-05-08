extends Node2D
class_name BaseFrame

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Utils.freeze_frame:
		delta = 0.0

func _physics_process(delta):
	if Utils.freeze_frame:
		delta = 0.0
