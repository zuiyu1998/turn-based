extends Node2D
class_name GameArea

@onready var grass: TileMapLayer = $Grass
@onready var highlighted_line: HighlightedLine = $HighlightedLine


func compute_highlighted():
	var mouse = get_local_mouse_position()
	var position = grass.local_to_map(mouse)
	set_highlighted(position)

func _process(delta: float) -> void:
	compute_highlighted()


# 设置高亮
func set_highlighted(position: Vector2i):
	var local = grass.map_to_local(position)
	highlighted_line.position = local


func get_local_position(position: Vector2i) -> Vector2:
	var local = grass.map_to_local(position)
	return local
