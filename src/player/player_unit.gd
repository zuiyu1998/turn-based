extends Unit
class_name PlayerUnit

var start_pos: Vector2i
var move_cost_map: Dictionary
var max_move_action: int

static func initialize(p_start_pos: Vector2i,  p_move_cost_map: Dictionary, p_max_move_action: int) -> Unit:
	var unit = PlayerUnit.new()
	unit.start_pos = p_start_pos
	unit.move_cost_map = p_move_cost_map
	unit.max_move_action = p_max_move_action
	return unit

# 单位的坐标
func get_start_pos() -> Vector2i:
	return start_pos

# 获取移动的消耗表
func get_move_cost_map() -> Dictionary:
	return move_cost_map

# 获取移动力
func get_max_move_action() -> int:
	return max_move_action
