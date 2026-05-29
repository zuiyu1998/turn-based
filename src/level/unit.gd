extends RefCounted
class_name Unit

# 单位的坐标
func get_start_pos() -> Vector2i:
	return Vector2i.ZERO

# 获取移动的消耗表
func get_move_cost_map() -> Dictionary:
	return {}

# 获取移动力
func get_max_move_action() -> int:
	return 0
