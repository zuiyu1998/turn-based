extends CharacterBody2D
class_name Player

@onready var gameplay_attribute_component: GameplayAttributeComponent = $GameplayAttributeComponent
@onready var mobile_range_layer_client: MobileRangeLayerClient = $MobileRangeLayerClient

@export
var data: PlayerData

var move_cost_map = {
	MapEnums.TerrainClass.Grass: 1,
}

func _ready() -> void:
	## 初始化组件
	gameplay_attribute_component.initialize([data.attribute_set])

func _process(delta: float) -> void:
	show_movable_areas()
	
	var target = mobile_range_layer_client.get_map_coordinate(get_global_mouse_position())
	show_move_path(target)

func do_initialize(context: PlayerInitializeContext):
	mobile_range_layer_client.do_initialize(context.server)


func show_movable_areas():
	mobile_range_layer_client.show_movable_areas(global_position, 2)


func show_move_path(target: Vector2i):
	var start_pos = mobile_range_layer_client.get_map_coordinate(global_position)
	var unit = PlayerUnit.initialize(start_pos, move_cost_map, 2)
	
	return mobile_range_layer_client.show_move_path(unit, target)

class PlayerInitializeContext:
	var server: MobileRangeLayerServer
