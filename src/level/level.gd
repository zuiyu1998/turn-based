extends Node2D
class_name Level

@onready var game_area: GameMap = $GameMap

@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var context = Player.PlayerInitializeContext.new()
	context.server = MapMobileRangeLayerServer.new_server(game_area)
	player.do_initialize(context)
	
	player.show_movable_areas()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
