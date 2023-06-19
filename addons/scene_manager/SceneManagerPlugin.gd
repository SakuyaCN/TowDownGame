@tool
extends EditorPlugin
var _inspector_plugin

func _enter_tree():
	add_autoload_singleton("SceneManager", "res://addons/scene_manager/SceneManager.tscn")
	_inspector_plugin = load("res://addons/scene_manager/NodeFlagsInspectorPlugin.gd").new()
	add_inspector_plugin(_inspector_plugin)


func _exit_tree():
	remove_autoload_singleton("SceneManager")
	remove_inspector_plugin(_inspector_plugin)
