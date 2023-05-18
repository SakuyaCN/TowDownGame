extends "_animation_importer_base.gd"

const SpriteFramesImporter = preload("sprite_frames.gd")

func _init(parent_plugin: EditorPlugin) -> void:
	super(parent_plugin)
	_import_order = 0
	_importer_name = "Aseprite AnimatedSprite3D Import"
	_priority = 1
	_recognized_extensions = ["ase", "aseprite"]
	_resource_type = "PackedScene"
	_save_extension = "scn"
	_visible_name = "AnimatedSprite3D"

	set_preset("Animation", [])


func _import(source_file: String, save_path: String, options: Dictionary,
	platform_variants: Array[String], gen_files: Array[String]) -> Error:
	var status: Error = OK
	var parsed_options = Common.ParsedAnimationOptions.new(options)
	var export_result: ExportResult = _export_texture(source_file, parsed_options, options, gen_files)

	var packed_scene: PackedScene
	var animated_sprite: AnimatedSprite3D
	var sprite_frames: SpriteFrames

	if ResourceLoader.exists(source_file):
		# This is a working way to reuse a previously imported resource. Don't change it!
		packed_scene = ResourceLoader.load(source_file, "PackedScene", ResourceLoader.CACHE_MODE_REPLACE) as PackedScene

	if packed_scene and packed_scene.can_instantiate():
		animated_sprite = packed_scene.instantiate() as AnimatedSprite3D

	if animated_sprite:
		sprite_frames = animated_sprite.sprite_frames

	if not sprite_frames:
		sprite_frames = SpriteFrames.new()

	if not animated_sprite:
		animated_sprite = AnimatedSprite3D.new()
		animated_sprite.name = source_file.get_file().get_basename()

	animated_sprite.sprite_frames = sprite_frames

	if not packed_scene:
		packed_scene = PackedScene.new()


	status = SpriteFramesImporter.update_sprite_frames(export_result, sprite_frames)
	if status: push_error("Cannot update SpriteFrames", status); return status

	if not parsed_options.animation_autoplay_name.is_empty():
		if sprite_frames.has_animation(parsed_options.animation_autoplay_name):
			animated_sprite.autoplay = parsed_options.animation_autoplay_name
		else:
			push_warning("Not found animation to set autoplay with name \"%s\"" %
				parsed_options.animation_autoplay_name)

	packed_scene.pack(animated_sprite)

	status = ResourceSaver.save(packed_scene, save_path + "." + _get_save_extension(), ResourceSaver.FLAG_COMPRESS)
	if status: push_error("Can't save imported resource.", status); return status

	return status
