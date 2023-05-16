extends "res://game/attachments/BaseAttachment.gd"
## 冲锋枪弹夹
	
func onStart():
	gun.bullets_max_count += 19

func onDestroy():
	gun.bullets_max_count -= 19
