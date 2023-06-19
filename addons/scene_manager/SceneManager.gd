extends Node2D

signal fade_complete
signal scene_unloaded
signal scene_loaded
signal transition_finished

var is_transitioning := false
@onready var _tree := get_tree()
@onready var _root := _tree.get_root()
@onready var _current_scene := _tree.current_scene
@onready var _animation_player : AnimationPlayer = $AnimationPlayer
@onready var _shader_blend_rect : ColorRect = $CanvasLayer/ColorRect

var default_options := {
	"speed": 2,
	"color": Color("#000000"),
	"pattern": "fade",
	"wait_time": 0.5,
	"invert": false,
	"invert_on_leave": true,
	"ease": 1.0,
	"skip_scene_change": false,
	"skip_fade_out": false,
	"skip_fade_in": false,
	"on_tree_enter": func(scene): null,
	"on_ready": func(scene): null,
	"on_fade_out": func(): null,
	"on_fade_in": func(): null,
}
# extra_options = {
#   "pattern_enter": DEFAULT_IMAGE,
#   "pattern_leave": DEFAULT_IMAGE,
#   "ease_enter": 1.0,
#   "ease_leave": 1.0,
# }

var singleton_entities := {}
var _previous_scene = null

func _ready() -> void:
	_set_singleton_entities()
	scene_loaded.emit()

func _set_singleton_entities() -> void:
	singleton_entities = {}
	var entities = _current_scene.get_tree().get_nodes_in_group(
		SceneManagerConstants.SINGLETON_GROUP_NAME
	)
	for entity in entities:
		var has_entity_name : bool = entity.has_meta(SceneManagerConstants.SINGLETON_META_NAME)
		assert(has_entity_name,"The node was set as a singleton entity, but no entity name was provided.")
		var entity_name = entity.get_meta(SceneManagerConstants.SINGLETON_META_NAME)
		assert(not singleton_entities.has(entity_name),"The entity name %s is already being used more than once! Please check that your entity name is unique within the scene.")
		singleton_entities[entity_name] = entity

func get_entity(entity_name: String) -> Node:
	assert(singleton_entities.has(entity_name),"Entity is not set as a singleton entity. Please define it in the editor.")
	return singleton_entities[entity_name]

func _load_pattern(pattern) -> Texture:
	assert(pattern is Texture or pattern is String, "Pattern is not a valid Texture, absolute path, or built-in texture.")
	if pattern is String:
		if pattern.is_absolute_path():
			return load(pattern)
		elif pattern == 'fade':
			return null
		return load("res://addons/scene_manager/shader_patterns/%s.png" % pattern)
	return pattern

func _get_final_options(initial_options: Dictionary) -> Dictionary:
	var options = initial_options.duplicate()

	for key in default_options.keys():
		if not options.has(key):
			options[key] = default_options[key]

	for pattern_key in ["pattern_enter", "pattern_leave"]:
		options[pattern_key] = (
			_load_pattern(options[pattern_key])
			if pattern_key in options
			else _load_pattern(options["pattern"])
		)

	for ease_key in ["ease_enter", "ease_leave"]:
		if not ease_key in options:
			options[ease_key] = options["ease"]

	return options

func _process(_delta: float) -> void:
	if not is_instance_valid(_previous_scene) and _tree.current_scene:
		_previous_scene = _tree.current_scene
		_current_scene = _tree.current_scene
		_set_singleton_entities()
		scene_loaded.emit()
	if _tree.current_scene != _previous_scene:
		_previous_scene = _tree.current_scene

func change_scene(path: Variant, setted_options: Dictionary = {}) -> void:
	assert(path == null or path is String, 'Path must be a string')
	var options = _get_final_options(setted_options)
	if not options["skip_fade_out"]:
		await fade_out(setted_options)
	if not options["skip_scene_change"]:
		if path == null:
			_reload_scene()
		else:
			_replace_scene(path, options)
	await _tree.create_timer(options["wait_time"]).timeout
	if not options["skip_fade_in"]:
		await fade_in(setted_options)

func reload_scene(setted_options: Dictionary = {}) -> void:
	await change_scene(null, setted_options)

func _reload_scene() -> void:
	_tree.reload_current_scene()
	await _tree.create_timer(0.0).timeout
	_current_scene = _tree.current_scene

func fade_in_place(setted_options: Dictionary = {}) -> void:
	setted_options["no_scene_change"] = true
	await change_scene(null, setted_options)

func _replace_scene(path: String, options: Dictionary) -> void:
	_current_scene.queue_free()
	scene_unloaded.emit()
	var following_scene: PackedScene = ResourceLoader.load(path, "PackedScene", 0)
	_current_scene = following_scene.instantiate()
	_current_scene.tree_entered.connect(options["on_tree_enter"].bind(_current_scene))
	_current_scene.ready.connect(options["on_ready"].bind(_current_scene))
	await _tree.create_timer(0.0).timeout
	_root.add_child(_current_scene)
	_tree.set_current_scene(_current_scene)

func fade_out(setted_options: Dictionary= {}) -> void:
	var options = _get_final_options(setted_options)
	is_transitioning = true
	_animation_player.speed_scale = options["speed"]

	_shader_blend_rect.material.set_shader_parameter(
		"dissolve_texture", options["pattern_enter"]
	)
	_shader_blend_rect.material.set_shader_parameter("fade", !options["pattern_enter"])
	_shader_blend_rect.material.set_shader_parameter("fade_color", options["color"])
	_shader_blend_rect.material.set_shader_parameter("inverted", false)
	var animation = _animation_player.get_animation("ShaderFade")
	animation.track_set_key_transition(0, 0, options["ease_enter"])
	_animation_player.play("ShaderFade")

	await _animation_player.animation_finished
	fade_complete.emit()
	options["on_fade_out"].call()

func fade_in(setted_options: Dictionary = {}) -> void:
	var options = _get_final_options(setted_options)
	_animation_player.speed_scale = options["speed"]
	_shader_blend_rect.material.set_shader_parameter(
		"dissolve_texture", options["pattern_leave"]
	)
	_shader_blend_rect.material.set_shader_parameter("fade", !options["pattern_leave"])
	_shader_blend_rect.material.set_shader_parameter("fade_color", options["color"])
	_shader_blend_rect.material.set_shader_parameter("inverted", options["invert_on_leave"])
	var animation = _animation_player.get_animation("ShaderFade")
	animation.track_set_key_transition(0, 0, options["ease_leave"])
	_animation_player.play_backwards("ShaderFade")

	await _animation_player.animation_finished
	is_transitioning = false
	transition_finished.emit()
	options["on_fade_in"].call()
