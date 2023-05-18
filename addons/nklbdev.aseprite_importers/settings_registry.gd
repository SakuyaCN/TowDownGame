extends Object

var __registered_project_setting_names: Array[StringName] = []

func register_project_setting(name: StringName, initial_value, type: int, hint: int, hint_string: String = "") -> void:
	if not ProjectSettings.has_setting(name):
		ProjectSettings.set_setting(name, initial_value)
		ProjectSettings.set_initial_value(name, initial_value)
		var property_info: Dictionary = { name = name, type = type, hint = hint }
		if hint_string: property_info.hint_string = hint_string
		ProjectSettings.add_property_info(property_info)
	__registered_project_setting_names.append(name)

func clear_registered_project_settings() -> void:
	for name in __registered_project_setting_names:
		ProjectSettings.set_setting(name, null)
	__registered_project_setting_names.clear()
