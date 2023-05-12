extends Panel
class_name WeaponAmItem

@export_enum("WEAPON_OPTICS","WEAPON_MUZZLE","WEAPON_BARREL","WEAPON_UNDERBARREL","WEAPON_AMMUNITION","WEAPON_STOCK","WEAPON_TACTICAL","WEAPON_PERKS") var am_type = "WEAPON_OPTICS" #配件类型

@onready var item_name = $Label
@onready var item_image = $TextureRect

var state = true

func _ready() -> void:
	item_name.text = tr(am_type)

func setState(state):
	self.state = state
	if !state:
		modulate = Color("#474747")
	else:
		modulate = Color.WHITE

