extends Panel
class_name WeaponAmItem

const tool_pre = preload("res://ui/widgets/Tooltip.tscn")

@export_enum("WEAPON_OPTICS","WEAPON_MUZZLE","WEAPON_BARREL","WEAPON_UNDERBARREL","WEAPON_AMMUNITION","WEAPON_STOCK","WEAPON_TACTICAL","WEAPON_PERKS") var am_type = "WEAPON_OPTICS" #配件类型

@onready var item_name = $Label
@onready var item_image = $TextureRect

signal mouseEvent(is_show)
signal checkTouchDown(am)
var state = true

var am = null

func _ready() -> void:
	item_name.text = tr(am_type)

func setData(am:BaseAttachment):
	self.am = am
	if am != null:
		$Button.visible = true
		item_image.texture = am.am_image
	else:
		$Button.visible = false
		item_image.texture = null

func setState(state):
	self.state = state
	if !state:
		modulate = Color("#474747")
	else:
		modulate = Color.WHITE

func _on_mouse_entered():
	emit_signal("mouseEvent",true,am)


func _on_mouse_exited():
	emit_signal("mouseEvent",false,null)

func _on_button_pressed():
	emit_signal("checkTouchDown",am)
