extends NavigationRegion2D

const pre = preload("res://game/monster/Monster 2/Monster2.tscn")
@onready var map = $TileMap2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func getPoint():
	var rect = Rect2(navigation_polygon.get_vertices()[3],navigation_polygon.get_vertices()[1])
	var random_point = Vector2(randi_range(rect.position.x, rect.position.x + rect.size.x), randi_range(rect.position.y, rect.position.y + rect.size.y))
	return random_point

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var ins = pre.instantiate()
	map.add_child(ins)
	ins.global_position = getPoint()
