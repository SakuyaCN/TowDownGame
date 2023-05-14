extends "res://game/attachments/BaseAttachment.gd"
## 快速弹夹
var speed = 0
	
func onStart():
	speed = gun.change_speed * 0.2
	gun.change_speed -= speed

func onDestroy():
	gun.change_speed += speed
