extends Node2D

@export var next_area:Node2D
@export var one_shot = false

signal moveIn()
signal moveOut()

var is_open = true

func _ready():
	add_to_group("Portal")
	$Area2D.body_entered.connect(self._on_area_2d_body_entered)
	$Area2D.body_exited.connect(self._on_area_2d_body_exited)

func _on_area_2d_body_entered(body):
	if body is Player && next_area && next_area.is_open && is_open:
		next_area.is_open = false
		body.global_position = next_area.global_position
		emit_signal("moveIn")

func _on_area_2d_body_exited(body):
	if body is Player:
		if one_shot:
			is_open = false
			close()
		else:
			is_open = true
		emit_signal("moveOut")

func reset():
	is_open = true
	$Area2D.body_entered.connect(self._on_area_2d_body_entered)
	$Area2D.body_exited.connect(self._on_area_2d_body_exited)

func close():
	$Area2D.body_entered.disconnect(self._on_area_2d_body_entered)
	$Area2D.body_exited.disconnect(self._on_area_2d_body_exited)
