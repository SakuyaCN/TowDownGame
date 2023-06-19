extends Node2D

var land_array :Array[Vector2i]
var land:TileMap:
	set(value):
		land = value
		land_array = land.get_used_cells(0)

