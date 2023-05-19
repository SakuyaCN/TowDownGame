extends "res://game/attachments/BaseAttachment.gd"

## 步枪扩容弹夹
func onStart():
	gun.bullets_max_count += 20

func onDestroy():
	gun.bullets_max_count -= 20
