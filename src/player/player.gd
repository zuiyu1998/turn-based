extends CharacterBody2D

@onready var gameplay_attribute_component: GameplayAttributeComponent = $GameplayAttributeComponent

@export
var data: PlayerData

func _ready() -> void:
	## 初始化组件
	gameplay_attribute_component.initialize([data.attribute_set])
