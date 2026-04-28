extends Node
class_name MobileRangeLayerClient

var server: MobileRangeLayerServer

## 显示单位的移动区域
func show_movable_areas(p_position: Vector2,p_max_action: int):
	if not server:
		printerr("MobileRangeLayerServer not found.")
	server.show_movable_areas(p_position, p_max_action)


func do_initialize(p_server: MobileRangeLayerServer):
	server = p_server
