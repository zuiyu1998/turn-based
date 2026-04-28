extends MobileRangeLayerServer
class_name MapMobileRangeLayerServer

var game_map: GameMap

static func new_server(p_game_map: GameMap) -> MapMobileRangeLayerServer:
	var server = MapMobileRangeLayerServer.new()
	server.game_map = p_game_map
	return server

func show_movable_areas(p_global_position: Vector2, max_action: int):
	var coordinate = game_map.get_map_coordinate(p_global_position)
	print("[MapMobileRangeLayerServer] local_position %s" % coordinate)
	
	var cells = game_map.get_movable_cells(coordinate, max_action)
	game_map.show_movable_areas(cells)
