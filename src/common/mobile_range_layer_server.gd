extends Node
class_name MobileRangeLayerServer

func get_map_coordinate(_p_global_position: Vector2,) -> Vector2i:
	return Vector2i.ZERO

func show_movable_areas(_p_global_position: Vector2, _p_max_action: int):
	pass

func show_move_path(_unit: Unit, _target: Vector2i):
	pass
