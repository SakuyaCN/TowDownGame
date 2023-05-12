extends TextureRect

@onready var image = $image
@onready var press_label = $Label

var local_id = 0
var pressed_name = ""

func _ready() -> void:
	PlayerData.onWeaponChanged.connect(self.onWeaponChanged)
	var pressed_index = get_index() + 1
	press_label.text = str(pressed_index)
	pressed_name = "pressed_%s" %pressed_index
	var gun : BaseGun = PlayerData.player_weapon_list[local_id]
	image.texture = gun.image

func _input(event: InputEvent) -> void:
	if !pressed_name.is_empty() && event.is_action_pressed(pressed_name):
		PlayerData.changeWeapon(local_id)

func onWeaponChanged():
	if Utils.player.gun && Utils.player.gun.weapon_id == local_id:
		self_modulate = Color("#83e0ff")
	else:
		self_modulate = Color.WHITE

func _on_button_pressed() -> void:
	emit_signal("weapon_click",local_id)


func _on_image_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print(123123)
