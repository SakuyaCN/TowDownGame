extends "res://game/attachments/BaseAttachment.gd"
## 通用扩容弹夹
func onStart():
	gun.bullets_max_count += 10

func onDestroy():
	gun.bullets_max_count -= 10
