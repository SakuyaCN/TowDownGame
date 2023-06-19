extends EditorProperty

var line_edit = LineEdit.new()
var edited_control = null
var meta_name = SceneManagerConstants.SINGLETON_META_NAME
var group_name = SceneManagerConstants.SINGLETON_GROUP_NAME

func _ready():
	label = "Entity name"

	line_edit.connect("text_changed", Callable(self, "_on_text_changed"))
	add_child(line_edit)


func _physics_process(_delta):
	if not edited_control and get_edited_object():
		edited_control = get_edited_object()
		if edited_control.has_meta(meta_name):
			line_edit.text = edited_control.get_meta(meta_name)
	if edited_control:
		pass
#		XXX
#		draw_red = (
#			not edited_control.has_meta(meta_name)
#			and edited_control.is_in_group(group_name)
#		)


func _on_text_changed(new_text: String):
	if new_text == "":
		edited_control.set_meta(meta_name, null)
	else:
		edited_control.set_meta(meta_name, new_text)
	emit_changed("meta", new_text, meta_name)
