extends Node2D

@export var next_area:Node2D
@export var one_shot = false

var is_open = true

func _ready():
	pass # Replace with function body.

func _on_area_2d_body_entered(body):
	if body is Player && next_area && next_area.is_open && is_open:
		next_area.is_open = false
		body.global_position = next_area.global_position


func _on_area_2d_body_exited(body):
	if body is Player:
		if one_shot:
			is_open = false
		else:
			is_open = true
		
