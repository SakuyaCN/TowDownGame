extends Node2D

@export var next_area:Node2D
@export var one_shot = false

signal moveIn(next_area)
signal moveOut()

var is_open = true

func _ready():
	add_to_group("Portal")
	$Area2D.body_entered.connect(self._on_area_2d_body_entered)
	$Area2D.body_exited.connect(self._on_area_2d_body_exited)

func _on_area_2d_body_entered(body):
	if body is Player && next_area && next_area.is_open && is_open:
		next_area.is_open = false
		emit_signal("moveIn",next_area)

func _on_area_2d_body_exited(body):
	if body is Player:
		if one_shot:
			is_open = false
			close()
		else:
			next_area.is_open = true
			is_open = true
		emit_signal("moveOut")

func reset():
	is_open = true
	next_area.is_open = true
	if $Area2D.body_entered.is_connected(self._on_area_2d_body_entered):
		$Area2D.body_entered.disconnect(self._on_area_2d_body_entered)
	if $Area2D.body_exited.is_connected(self._on_area_2d_body_exited):
		$Area2D.body_exited.disconnect(self._on_area_2d_body_exited)
	$Area2D.body_entered.connect(self._on_area_2d_body_entered)
	$Area2D.body_exited.connect(self._on_area_2d_body_exited)

func close():
	if $Area2D.body_entered.is_connected(self._on_area_2d_body_entered):
		$Area2D.body_entered.disconnect(self._on_area_2d_body_entered)
	if $Area2D.body_exited.is_connected(self._on_area_2d_body_exited):
		$Area2D.body_exited.disconnect(self._on_area_2d_body_exited)
