extends RefCounted
class_name MapGrid

var _data: Dictionary = {
}

func clear():
	_data.clear()

func get_data() -> Dictionary:
	return _data

func set_item(key:Vector2i, item:MapGridItem):
	_data[key] = item


func get_item(key: Vector2i) -> MapGridItem:
	return _data.get(key)


class MapGridItem:
	var unit: Node2D
	var terrain_class: MapEnums.TerrainClass
	var move_cost: int
