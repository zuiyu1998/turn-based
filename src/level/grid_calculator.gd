extends Node
class_name PathLayer

var _astar: AStar2D = AStar2D.new()
# 坐标和id的映射
var _coord_to_id: Dictionary = {}
var _directions: Array[Vector2i] = [
	Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT
]
# 地图数据
var _map_grid: MapGrid = MapGrid.new()
var _game_map: GameMap = GameMap.new()

var _pool: Array[Line2D] = []
var _path_groups: Dictionary = {}

func show_path(cells: Array[Vector2i], group: String = "default",color: Color = Color(1.0, 1.0, 1.0, 0.8),width: int = 1,):
	clear_path(group)
	if cells.size() < 2:
		return
	
	var paths: Array[Line2D] = []
	_path_groups[group] = paths
	
	var line = _get_from_pool()
	line.width = width
	line.default_color = color
	
	var local_points = PackedVector2Array()
	
	for cell_pos in cells:
		local_points.append(_game_map.get_global_from_file(cell_pos))
	
	line.points = local_points
	line.show()
	paths.append(line)

func clear_path(group: String) -> void:
	if _path_groups.has(group):
		var paths = _path_groups[group]
		
		for path in paths:
			path.hide()
			_pool.append(path)
		_path_groups.erase(group)

func _get_from_pool() -> Line2D:
	var line: Line2D
	if _pool.size() > 0:
		line = _pool.pop_back()
	else:
		line = Line2D.new()
		line.z_index = 0
		add_child(line)
	return line

func show_move_path(unit: Unit, target: Vector2i):
	var res = get_move_path(unit, target)
	var reachable = res.get("reachable", [])
	var unreachable = res.get("unreachable", [])
	
	if not reachable.is_empty():
		show_path(reachable, "reachable", Color(1, 1, 1, 0.9))
	else:
		clear_path("reachable")

	if not unreachable.is_empty():
		if not reachable.is_empty():
			unreachable.insert(0, reachable[-1])
			show_path(unreachable, "unreachable", Color(0.5, 0.5, 0.5, 0.9))
		else:
			clear_path("unreachable")


func get_move_path(unit: Unit, target: Vector2i) -> Dictionary:
	var start_pos = unit.get_start_pos()
	
	if not _coord_to_id.has(start_pos):
		return { "reachable": [], "unreachable": [] }
	
	var target_id = _astar.get_closest_point(Vector2(target))
	if target_id == 1:
		return { "reachable": [], "unreachable": [] }
	var path = _astar.get_id_path(_coord_to_id[start_pos], target_id)	
	if path.is_empty():
		return { "reachable": [], "unreachable": [] }
	
	var reachable: Array[Vector2i] = [start_pos]
	var unreachable: Array[Vector2i] = []
	
	var is_reachable = true
	var move_cost_map = unit.get_move_cost_map()
	var move_action = unit.get_max_move_action()

	
	for i in range(1, path.size()):
		var p_pos = Vector2i(_astar.get_point_position(path[i]))
		
		if is_reachable:
			var cost = _get_move_cost(move_cost_map, p_pos)
			if cost != -1 and move_action >= cost:
				move_action -= cost
				reachable.append(p_pos)
			else:
				is_reachable = false
				unreachable.append(p_pos)
		else:
			unreachable.append(p_pos)
	
	return {
		"reachable": reachable,
		"unreachable": unreachable,
	}

func do_initialize(game_map: GameMap, unit: Unit):
	_astar.clear()
	_coord_to_id.clear()
	_map_grid = game_map.get_map_grid()
	_astar.clear()
	_game_map = game_map
	
	var move_cost_map = unit.get_move_cost_map()
	
	var id_counter = 0
	
	for cell_pos in _map_grid.get_data():
		var cost = _get_move_cost(move_cost_map, cell_pos)
		if cost != -1:
			_astar.add_point(id_counter, Vector2(cell_pos.x, cell_pos.y), float(cost))
			_coord_to_id[cell_pos] = id_counter
			id_counter += 1
	
	for cell_pos in _coord_to_id:
		var current_id = _coord_to_id[cell_pos]
		for dir in _directions:
			var neighbor_pos = cell_pos + dir
			if _coord_to_id.has(neighbor_pos):
				_astar.connect_points(current_id, _coord_to_id[neighbor_pos])
	
func _get_move_cost(move_cost_map: Dictionary, cell_pos: Vector2i) -> int:
	var item = _map_grid.get_item(cell_pos)
	
	if !item:
		return -1
	
	if item.unit != null:
		return -1
	
	var terrain_class = item.terrain_class
	var cost = move_cost_map.get(terrain_class, -1)
	
	if cost >= 0:
		return cost
	else :
		return -1	
