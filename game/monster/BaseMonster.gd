extends CharacterBody2D
class_name BaseMonsyer

@export var SPEED = 50.0
@export var hurt = 1
var movement_delta: float
var navigationAgent2D := NavigationAgent2D.new()

@onready var sprite_body = get_node("body")

var is_flip

func _ready():
	add_child(navigationAgent2D)
	#navigationAgent2D.navigation_finished.connect(self._navigation_finished)
	#navigationAgent2D.target_reached.connect(self._target_reached)
	navigationAgent2D.velocity_computed.connect(self._on_velocity_computed)
	navigationAgent2D.avoidance_enabled = true

func _physics_process(delta):
	if Engine.get_physics_frames() % 60 :
		navigationAgent2D.set_target_position(Utils.player.global_position)
	if navigationAgent2D.is_inside_tree() && !navigationAgent2D.is_navigation_finished():
		var next_path_position = navigationAgent2D.get_next_path_position()
		var current_agent_position: Vector2 = global_position
		var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * SPEED
		if navigationAgent2D.avoidance_enabled:
			navigationAgent2D.set_velocity(new_velocity)
		else:
			_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func flip_h(flip:bool):
	if is_flip == flip:
		return
	is_flip = flip
	var x_axis = sprite_body.global_transform.x
	sprite_body.global_transform.x.x = (-1 if flip else 1) * abs(x_axis.x)

func hitFlash():
	var materialFlash = ShaderMaterial.new()
	materialFlash.shader = load("res://shader/Monster1.gdshader")
	sprite_body.get_node("AnimatedSprite2D").material = materialFlash
	await get_tree().create_timer(0.1).timeout.connect(func timeout():
		sprite_body.get_node("AnimatedSprite2D").material = null )
