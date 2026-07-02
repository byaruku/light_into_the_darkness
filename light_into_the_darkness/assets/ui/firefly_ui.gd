class_name FireflyUI
extends CanvasLayer

@export var firefly_icon_scene: PackedScene

@onready var container = $MarginContainer/FireflyContainer


func add_firefly():
	var icon = firefly_icon_scene.instantiate()
	
	icon.position = Vector2(randf_range(0, container.size.x), randf_range(0, container.size.y))
	
	container.add_child(icon)
