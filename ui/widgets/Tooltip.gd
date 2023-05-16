extends Panel

@onready var type = $Label2
@onready var info = $Label
@onready var use = $Label/Label3

var am :BaseAttachment= null

func setData(am:BaseAttachment):
	self.am = am
	if am != null:
		am._checkTypeList()
		type.text = tr("TOOLTIP_TYPE") + tr(am.am_type)
		info.text = tr(am.am_info)
		use.text = tr("TOOLTIP_RANGE")
		for gun_type in am.use_type:
			use.text += tr(gun_type) + " · "
	else:
		use.text = tr("TOOLTIP_RANGE")
		type.text = tr("TOOLTIP_TYPE")
		info.text = tr("TOOLTIP_INFO")
