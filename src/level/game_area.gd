extends Node2D
class_name GameArea

@onready var grass: TileMapLayer = $Grass

func get_local_position(position: Vector2i) -> Vector2:
	var local = grass.map_to_local(position)
	return local
