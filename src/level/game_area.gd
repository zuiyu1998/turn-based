extends Node2D
class_name GameMap

@onready var grass: TileMapLayer = $Grass
@onready var highlighted_line: HighlightedLine = $HighlightedLine
@onready var mobile_range_layer: MobileRangeLayer = $MobileRangeLayer
@onready var path_layer: PathLayer = $PathLayer

# 定义四个移动方向（上，下，左，右）
const DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT
]

var _map_grid: MapGrid = MapGrid.new()

func get_global_from_file(cell_pos: Vector2i) -> Vector2:
	var local_pos = grass.map_to_local(cell_pos)
	return to_global(local_pos)

func show_move_path(unit: Unit, target: Vector2i):
	path_layer.do_initialize(self, unit)
	path_layer.show_move_path(unit, target)


func _initialize_map_grid():
	for cell_position in grass.get_used_cells():
		var item = MapGrid.MapGridItem.new()
		var tile_data = grass.get_cell_tile_data(cell_position)
		var terrain_class = MapEnums.TerrainClass.Grass
		var move_cost = 1
		
		if tile_data:
			var custom_terrain_class = tile_data.get_custom_data("terrain_class")
			terrain_class =custom_terrain_class
			var custom_move_cost = tile_data.get_custom_data("move_cost")
			move_cost = custom_move_cost
		
		item.terrain_class = terrain_class
		item.move_cost = move_cost
		_map_grid.set_item(cell_position, item)

func _ready() -> void:
	_initialize_map_grid()
	

func get_map_grid() -> MapGrid:
	return _map_grid

func show_movable_areas(cells: Array[Vector2i]):
	mobile_range_layer.show_cell(cells)


func get_movable_cells(start_position: Vector2i, max_action: int) -> Array[Vector2i]:
	# 优先队列
	var priority_queue: Array[Dictionary] = []
	# 可到达的位置
	var reachable: Array[Vector2i] = []
	# 每个格子的最小消耗
	var min_costs: Dictionary = {} 
	
	_push_to_queue(priority_queue, start_position, 0)
	min_costs[start_position] = 0
	
	while  not priority_queue.is_empty():
		var current = _pop_min_cost(priority_queue)
		var current_cell = current['cell']
		var current_cost = current['cost']
		
		if current_cost > max_action:
			continue
		
		reachable.append(current_cell)
		
		for dir in DIRECTIONS:
			var neighbor = current_cell + dir
			if not _is_cell_inside_map(neighbor):
				continue
			
			var move_cost = _get_movement_cost(neighbor)
			
			if move_cost >= 9999:
				continue
			
			var new_cost = current_cost + move_cost
			if new_cost > max_action:
				continue
			
			if not min_costs.has(neighbor) or new_cost < min_costs[neighbor]:
				min_costs[neighbor] = new_cost
				_push_to_queue(priority_queue, neighbor, new_cost)
	
	return reachable

# 辅助函数：获取指定格子的地形移动消耗
func _get_movement_cost(_cell: Vector2i) -> int:
	return 1  # 默认返回基础消耗1

# 辅助函数：检查坐标是否在地图范围内
func _is_cell_inside_map(cell: Vector2i) -> bool:
	var used_rect = grass.get_used_rect()
	return used_rect.has_point(cell)

# 辅助函数：弹出并返回cost最小的元素
func _pop_min_cost(queue: Array) -> Dictionary:
	return queue.pop_front()

# 辅助函数：将元素按cost升序插入到队列中
func _push_to_queue(queue: Array, cell: Vector2i, cost: int):
	var idx = 0
	while idx < queue.size() and queue[idx]["cost"] < cost:
		idx += 1
	queue.insert(idx, {"cell": cell, "cost": cost})

func compute_highlighted():
	var mouse = get_local_mouse_position()
	var map_position = grass.local_to_map(mouse)
	set_highlighted(map_position)

func _process(_delta: float) -> void:
	compute_highlighted()

# 设置高亮
func set_highlighted(p_position: Vector2i):
	var local = grass.map_to_local(p_position)
	highlighted_line.position = local


func get_map_coordinate(p_global_position: Vector2) -> Vector2i:
	var local = to_local(p_global_position)
	return grass.local_to_map(local)


func get_local_position(p_position: Vector2i) -> Vector2:
	var local = grass.map_to_local(p_position)
	return local
