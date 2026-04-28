extends Node2D
class_name MobileRangeLayer

const HIGHLIGHTED_AREA = preload("res://src/components/highlighted_area.tscn")

@export
var game_map: GameMap

# 对象池
var _pool: Array[Node2D] = []
# 记录当前组的所有高度节点
var _highlighted_areas: Dictionary = {}

func show_cell(cells: Array[Vector2i], group_name: String = "default"):
	if !game_map:
		push_error("Game area not found.")
		return
	
	var group = []
	for cell in cells:
		var area = _get_from_pool()
		area.position = game_map.get_local_position(cell)
		group.push_back(area)
		
	_highlighted_areas[group_name] = group


func clear_all():
	for group in _highlighted_areas.values():
		for area in group:
			area.hide()
			_pool.push_back(area)


func _get_from_pool() -> HighlightedArea:
	var highlighted_area: HighlightedArea
	if _pool.size() > 0:
		highlighted_area = _pool.pop_back()
	else:
		highlighted_area = HIGHLIGHTED_AREA.instantiate()
	add_child(highlighted_area)
	
	return highlighted_area
