extends Node
class_name MobileRangeLayerClient

var server: MobileRangeLayerServer

func get_map_coordinate(p_global_position: Vector2,) -> Vector2i:
	if not server:
		printerr("MobileRangeLayerServer not found.")
	return server.get_map_coordinate(p_global_position)


# 显示单位的移动区域
func show_movable_areas(p_position: Vector2,p_max_action: int):
	if not server:
		printerr("MobileRangeLayerServer not found.")
	server.show_movable_areas(p_position, p_max_action)


# 获取移动路径
func show_move_path(unit: Unit, target: Vector2i):
	if not server:
		printerr("MobileRangeLayerServer not found.")
	return server.show_move_path(unit, target)


func do_initialize(p_server: MobileRangeLayerServer):
	server = p_server
