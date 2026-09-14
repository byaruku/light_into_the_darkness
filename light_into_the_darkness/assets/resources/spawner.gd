class_name Spawner
extends Node2D


@export var objects : Array[Node2D] = []
@export var min_distance := 100

var spawn_positions : Array[Vector2]= []


func spawn_objects() -> void:
	await get_tree().process_frame


func clear_spawn_positions() -> void:
	spawn_positions.clear()
