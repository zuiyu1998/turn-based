extends Node2D
class_name GameMap

@onready var grass: TileMapLayer = $Grass
@onready var highlighted_line: HighlightedLine = $HighlightedLine
@onready var mobile_range_layer: MobileRangeLayer = $MobileRangeLayer

func show_movable_areas(cells: Array[Vector2i]):
	mobile_range_layer.show_cell(cells)


func get_movable_cells(start_positon: Vector2i, max_action: int) -> Array[Vector2i]:
	return [start_positon]


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

func get_map_coordinate(p_global_position: Vector2) -> Vector2i:
	var local = to_local(p_global_position)
	return grass.local_to_map(local)


func get_local_position(position: Vector2i) -> Vector2:
	var local = grass.map_to_local(position)
	return local
