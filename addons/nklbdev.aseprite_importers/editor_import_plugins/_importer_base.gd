@tool
extends EditorImportPlugin

# Base class for all nested import plugins

const Common = preload("../common.gd")

var _parent_plugin: EditorPlugin

var _import_order: int = 0
var _importer_name: String = ""
var _priority: float = 1
var _recognized_extensions: PackedStringArray
var _resource_type: StringName
var _save_extension: String
var _visible_name: String
var _presets: Dictionary
var __option_visibility_checkers: Dictionary

func _init(parent_plugin: EditorPlugin) -> void:
	_parent_plugin = parent_plugin

func _get_import_options(path: String, preset_index: int) -> Array[Dictionary]:
	return _presets.values()[preset_index] as Array[Dictionary]

func _get_option_visibility(path: String, option_name: StringName, options: Dictionary) -> bool:
	var option_visibility_checker: Callable = __option_visibility_checkers.get(option_name, Common.EMPTY_CALLABLE)
	if option_visibility_checker:
		if option_visibility_checker == Common.EMPTY_CALLABLE:
			return true
		else:
			return option_visibility_checker.call(options)
	else:
		return true

func _get_import_order() -> int:
	return _import_order

func _get_importer_name() -> String:
	return _importer_name

func _get_preset_count() -> int:
	return _presets.size()

func _get_preset_name(preset_index: int) -> String:
	return _presets.keys()[preset_index]

func _get_priority() -> float:
	return _priority

func _get_recognized_extensions() -> PackedStringArray:
	return _recognized_extensions

func _get_resource_type() -> String:
	return _resource_type

func _get_save_extension() -> String:
	return _save_extension

func _get_visible_name() -> String:
	return _visible_name

func _import(source_file: String, save_path: String, options: Dictionary,
	platform_variants: Array[String], gen_files: Array[String]) -> Error:
	return ERR_UNCONFIGURED
