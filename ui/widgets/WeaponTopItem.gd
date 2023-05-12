extends Button

@onready var image = $image
@onready var press_label = $Label

var local_id = 0
var pressed_name = ""

signal weapon_click(gun)

func _ready() -> void:
	PlayerData.onWeaponChanged.connect(self.onWeaponChanged)
	var pressed_index = get_index() + 1
	press_label.text = str(pressed_index)
	pressed_name = "pressed_%s" %pressed_index
	var gun : BaseGun = PlayerData.player_weapon_list[local_id]
	image.texture = gun.image

func onWeaponChanged():
	if Utils.player.gun && Utils.player.gun.weapon_id == local_id:
		self_modulate = Color("#83e0ff")
	else:
		self_modulate = Color.WHITE

func _on_pressed() -> void:
	emit_signal("weapon_click",local_id)
