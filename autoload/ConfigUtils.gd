extends Node

const config_path = "user://config.cfg"
var config = ConfigFile.new()
var config_data = {}

func _ready() -> void:
	# 从文件加载数据。
	var err = config.load(config_path)

	# 如果文件没有加载，忽略它。
	if err != OK:
		createConfig()

func createConfig():
	config.set_value("setting","language",0)
	config.set_value("setting","shake",50)
	config.set_value("setting","volume",50)
	config.save(config_path)

func setConfig(s,n,k):
	config.set_value(s,n,k)
	config.save(config_path)

func getConfig(s,n):
	if config && config.has_section_key(s,n):
		return config.get_value(s,n)
	return null
