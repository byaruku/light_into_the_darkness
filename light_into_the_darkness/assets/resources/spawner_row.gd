class_name SpawnerRow
extends Node2D

@export var spawner: Array[SpawnArea] = []

func spawn() -> void:
	for s in spawner:
		if s is TreeSpawner:
			await s.generate()
		await s.spawn_objects()
