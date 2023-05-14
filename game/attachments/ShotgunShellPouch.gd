extends "res://game/attachments/BaseAttachment.gd"
## 霰弹枪子弹袋
var speed = 0
	
func onStart():
	speed = gun.change_speed * 0.2
	gun.change_speed -= speed
	gun.bullets_max_count += 5

func onDestroy():
	gun.change_speed += speed
	gun.bullets_max_count -= 5
