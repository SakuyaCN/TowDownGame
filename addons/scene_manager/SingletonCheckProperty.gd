extends EditorProperty

var checkbox := CheckBox.new()
var edited_control = null
var group_name = SceneManagerConstants.SINGLETON_GROUP_NAME

func _ready():
	edited_control = get_edited_object()

	label = "Singleton entity"

	checkbox.connect("toggled", Callable(self, "_on_checkbox_checked"))
	add_child(checkbox)


func _physics_process(_delta):
	if not edited_control and get_edited_object():
		edited_control = get_edited_object()
		checkbox.set_pressed_no_signal(edited_control.is_in_group(group_name))
	checkbox.text = "Yes" if checkbox.pressed else "No"


func _on_checkbox_checked(is_checked):
	var new_groups = edited_control.get_groups()
	if is_checked:
		new_groups.append(group_name)
		edited_control.add_to_group(group_name, true)
	else:
		var index = new_groups.find(group_name)
		new_groups.remove(index)
		edited_control.remove_from_group(group_name)
	emit_changed('groups', new_groups)
