class_name FireflyUI
extends CanvasLayer

@export var firefly_icon_scene: PackedScene

@onready var container = $MarginContainer/FireflyContainer
@onready var label = $Label

var counter := 0


func add_firefly():
	var icon = firefly_icon_scene.instantiate()
	
	icon.position = Vector2(randf_range(0, container.size.x), randf_range(0, container.size.y))
	
	container.add_child(icon)
	
	add_to_counter()


func add_to_counter():
	counter += 1
	label.text = str(counter) + "/6"
