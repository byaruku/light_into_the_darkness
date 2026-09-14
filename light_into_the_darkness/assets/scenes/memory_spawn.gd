extends Node2D

signal spawner_ready


func _ready() -> void:
	SceneManager.wait_for_spawn = true
	await $SpawnerRow.spawn()
	SceneManager.wait_for_spawn = false
