extends "res://game/attachments/BaseAttachment.gd"
## 快速扩容弹夹
var speed = 0
	
func onStart():
	speed = gun.change_speed * 0.2
	gun.change_speed -= speed
	gun.bullets_max_count += 10

func onDestroy():
	gun.change_speed += speed
	gun.bullets_max_count -= 10
