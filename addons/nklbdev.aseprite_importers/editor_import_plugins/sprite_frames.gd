extends "_animation_importer_base.gd"

func _init(parent_plugin: EditorPlugin) -> void:
	super(parent_plugin)
	_import_order = 0
	_importer_name = "Aseprite SpriteFrames Import"
	_priority = 1
	_recognized_extensions = ["ase", "aseprite"]
	_resource_type = "SpriteFrames"
	_save_extension = "res"
	_visible_name = "SpriteFrames"

	set_preset("Animation", [])

func _import(source_file: String, save_path: String, options: Dictionary,
	platform_variants: Array[String], gen_files: Array[String]) -> Error:
	var status: Error = OK
	var parsed_options = Common.ParsedAnimationOptions.new(options)
	var export_result: ExportResult = _export_texture(source_file, parsed_options, options, gen_files)

	var sprite_frames: SpriteFrames
	if ResourceLoader.exists(source_file):
		# This is a working way to reuse a previously imported resource. Don't change it!
		sprite_frames = ResourceLoader.load(source_file, "SpriteFrames", ResourceLoader.CACHE_MODE_REPLACE) as SpriteFrames
	if not sprite_frames:
		sprite_frames = SpriteFrames.new()

	status = update_sprite_frames(export_result, sprite_frames)
	if status:
		push_error("Cannot update SpriteFrames", status)
		return status

	status = ResourceSaver.save(
		sprite_frames,
		save_path + "." + _get_save_extension(),
		ResourceSaver.FLAG_COMPRESS)
	if status:
		push_error("Can't save imported resource.", status)
	return status

static func update_sprite_frames(export_result: ExportResult, sprite_frames: SpriteFrames, animation_autoplay_name: String = "") -> Error:
	var spritesheet_metadata: SpritesheetMetadata = export_result.spritesheet_metadata
	var exported_animation_names: Array = export_result.spritesheet_metadata.animation_tags.map(
		func (at: AnimationTag) -> String: return at.name)
	var actual_animation_names: PackedStringArray = sprite_frames.get_animation_names()
	for name in actual_animation_names:
		if exported_animation_names.has(name):
			sprite_frames.clear(name)
		else:
			sprite_frames.remove_animation(name)
	var atlas_textures: Dictionary = {}
	for animation_tag in spritesheet_metadata.animation_tags:
		if not sprite_frames.has_animation(animation_tag.name):
			sprite_frames.add_animation(animation_tag.name)
		sprite_frames.set_animation_loop(animation_tag.name, animation_tag.looped)
		sprite_frames.set_animation_speed(animation_tag.name, 1)
		for frame_data in animation_tag.frames:
			var atlas_texture = atlas_textures.get(frame_data.region_rect)
			if atlas_texture == null:
				atlas_texture = AtlasTexture.new()
				atlas_texture.atlas = export_result.texture
				atlas_texture.region = frame_data.region_rect
				atlas_texture.margin = Rect2(frame_data.region_rect_offset, spritesheet_metadata.source_size - frame_data.region_rect.size)
				atlas_textures[frame_data.region_rect] = atlas_texture

			sprite_frames.add_frame(animation_tag.name, atlas_texture, frame_data.duration_ms * 0.001)
	return OK
