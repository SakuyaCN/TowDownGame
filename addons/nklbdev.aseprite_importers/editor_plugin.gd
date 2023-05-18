@tool
extends EditorPlugin

const PLUGIN_SCRIPTS: Array[GDScript] = [
	preload("editor_import_plugins/animated_sprite_2d.gd"),
	preload("editor_import_plugins/animated_sprite_3d.gd"),
	preload("editor_import_plugins/sprite_2d.gd"),
	preload("editor_import_plugins/sprite_3d.gd"),
	preload("editor_import_plugins/sprite_frames.gd"),
	preload("editor_import_plugins/texture_rect.gd"),
]

const Common = preload("common.gd")
const SettingsRegistry = preload("settings_registry.gd")
const ImportPlugin = preload("editor_import_plugins/_animation_importer_base.gd")

var __import_plugins: Array[ImportPlugin]

var settings_registry: SettingsRegistry = SettingsRegistry.new()
var common_options: Array[Dictionary] = Common.create_common_animation_options()
var texture_2d_options: Array[Dictionary] = Common.create_texture_2d_options()

func _enter_tree() -> void:
	settings_registry.register_project_setting(
		Common.ASEPRITE_EXECUTABLE_PATH_SETTING_NAME, "",
		TYPE_STRING, PROPERTY_HINT_GLOBAL_FILE, "*.exe")
	for plugin_script in PLUGIN_SCRIPTS:
		add_import_plugin(plugin_script.new(self))

func _exit_tree() -> void:
	for import_plugin in __import_plugins:
		remove_import_plugin(import_plugin)
	__import_plugins.clear()
