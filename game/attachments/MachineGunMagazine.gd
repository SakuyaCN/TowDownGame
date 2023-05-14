extends "res://game/attachments/BaseAttachment.gd"
## 机枪容弹夹
func onStart():
	gun.bullets_max_count += 50

func onDestroy():
	gun.bullets_max_count -= 50
