extends Node2D

signal spawner_ready


func _ready() -> void:
	await $SpawnerRow.spawn()
	spawner_ready.emit()
