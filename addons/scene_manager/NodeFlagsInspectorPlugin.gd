extends EditorInspectorPlugin

var SingletonCheckProperty = load('res://addons/scene_manager/SingletonCheckProperty.gd')
var SingletonNameProperty = load('res://addons/scene_manager/SingletonNameProperty.gd')


func _can_handle(object: Variant):
	return object is Node


func _parse_begin(object: Object):
	add_property_editor("singleton_check", SingletonCheckProperty.new())
	add_property_editor("singleton_name", SingletonNameProperty.new())
