extends Panel

@onready var equip_image = $TextureRect
@onready var equip_key = $Key
@onready var equip_pressed = $Label

var equip :BaseEquip

func _ready():
	if equip:
		equip_image.texture = equip.equip_image
		match equip.equip_quick_key:
			"q":equip_key.texture = load("res://Sprites/ui/key/tile_0085.png")
			"mouse_right":equip_key.texture = load("res://Sprites/ui/key/tile_0112.png")
			"space":equip_key.texture = load("res://Sprites/ui/key/tile_0235.png")

func setEquip(equip):
	self.equip = equip
