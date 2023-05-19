extends CharacterBody2D

const GRAVITY = 222
@onready var screen_size = get_viewport_rect().size
var array = []
var target_position

var hurt = 1

func _ready():
	set_physics_process(false)

func _process(delta):
	velocity.y += GRAVITY * delta
	var collision = move_and_collide(velocity * delta * 1.2)
	if collision:
		var target = collision.get_collider()
		set_process(false)
		$AudioStreamPlayer2D.play()
		$AnimatedSprite2D.visible = true
		$AnimatedSprite2D.play("default")
		for item in array:
			item.onHit(hurt)
		await $AnimatedSprite2D.animation_finished
		queue_free()


func calculate_arc_velocity(source_position, target_position, arc_height, gravity):
	var velocity = Vector2()
	var displacement = target_position - source_position
	
	if displacement.y > arc_height:
		var time_up = sqrt(-2 * arc_height / float(gravity))
		var time_down = sqrt(2 * (displacement.y - arc_height) / float(gravity))
		
		velocity.y = -sqrt(-2 * gravity * arc_height)
		velocity.x = displacement.x / float(time_up + time_down) 
	
	return velocity
	
func launch(target_position):
	self.target_position = target_position
	var distance = abs(target_position.x - global_position.x)
	var max_height = (distance / screen_size.x) * screen_size.y * randf_range(0.06,0.12)
	var arc_height = target_position.y - global_position.y - max_height / 1.5
	arc_height = min(arc_height, -max_height)
	velocity = calculate_arc_velocity(global_position, target_position, arc_height, GRAVITY)
	set_physics_process(true)
#	ConstValue.shake()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is BaseMonster:
		array.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is BaseMonster:
		array.erase(body)
