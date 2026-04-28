extends CharacterBody2D
class_name Player

@onready var gameplay_attribute_component: GameplayAttributeComponent = $GameplayAttributeComponent
@onready var mobile_range_layer_client: MobileRangeLayerClient = $MobileRangeLayerClient

@export
var data: PlayerData

func _ready() -> void:
	## 初始化组件
	gameplay_attribute_component.initialize([data.attribute_set])


func do_initialize(context: PlayerInitializeContext):
	mobile_range_layer_client.do_initialize(context.server)


func show_movable_areas():
	mobile_range_layer_client.show_movable_areas(global_position, 0)


class PlayerInitializeContext:
	var server: MobileRangeLayerServer
